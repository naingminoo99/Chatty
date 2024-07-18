//
//  Created by Alex.M on 20.06.2022.
//

import Foundation
import Combine
import _PhotosUI_SwiftUI

final class InputViewModel: ObservableObject {

    @Published var text = ""
    @Published var attachments = InputViewAttachments()
    @Published var state: InputViewState = .empty
    @Published var showActivityIndicator = false
    
    var recordingPlayer: RecordingPlayer?
    var didSendMessage: ((DraftMessage) -> Void)?

    private var recorder = Recorder()

    private var saveEditingClosure: ((String) -> Void)?

    private var recordPlayerSubscription: AnyCancellable?
    private var subscriptions = Set<AnyCancellable>()

    // Media Picker
    @Published var photoPickerItems: [PhotosPickerItem] = []
    @Published var showPicker = false
    @Published var mediaPickerFilter: PHPickerFilter?

    
    func onStart() {
        subscribeValidation()
        subscribePicker()
    }

    func onStop() {
        subscriptions.removeAll()
    }

    func reset() {
        DispatchQueue.main.async { [weak self] in
            self?.attachments = InputViewAttachments()
            self?.photoPickerItems = []
            self?.showPicker = false
            self?.text = ""
            self?.saveEditingClosure = nil
            self?.subscribeValidation()
            self?.state = .empty
        }
    }

    func send() {
        recorder.stopRecording()
        recordingPlayer?.reset()
        sendMessage()
            .store(in: &subscriptions)
    }

    func edit(_ closure: @escaping (String) -> Void) {
        saveEditingClosure = closure
        state = .editing
    }

    func inputViewAction() -> (InputViewAction) -> Void {
        { [weak self] in
            self?.inputViewActionInternal($0)
        }
    }

    private func inputViewActionInternal(_ action: InputViewAction) {
        switch action {
        case .photo:
            mediaPickerFilter = .images
            showPicker = true
            
            // TODO: fix this
//        case .video:
//            mediaPickerFilter = .videos
//            showPicker = true
//        case .media:
//            mediaPickerFilter = .any(of: [.images, .videos])
//            showPicker = true
            
//        TODO: Camera
        case .add:
            showPicker = true
        case .camera:
            showPicker = true
            
        case .send:
            send()
        case .recordAudioTap:
            state = recorder.isAllowedToRecordAudio ? .isRecordingTap : .waitingForRecordingPermission
            recordAudio()
        case .recordAudioHold:
            state = recorder.isAllowedToRecordAudio ? .isRecordingHold : .waitingForRecordingPermission
            recordAudio()
        case .recordAudioLock:
            state = .isRecordingTap
        case .stopRecordAudio:
            recorder.stopRecording()
            if let _ = attachments.recording {
                state = .hasRecording
            }
            recordingPlayer?.reset()
        case .deleteRecord:
            unsubscribeRecordPlayer()
            recorder.stopRecording()
            attachments.recording = nil
        case .playRecord:
            state = .playingRecording
            if let recording = attachments.recording {
                subscribeRecordPlayer()
                recordingPlayer?.play(recording)
            }
        case .pauseRecord:
            state = .pausedRecording
            recordingPlayer?.pause()
        case .saveEdit:
            saveEditingClosure?(text)
            reset()
        case .cancelEdit:
            reset()
        }
    }

    private func recordAudio() {
        if recorder.isRecording {
            return
        }
        Task { @MainActor in
            attachments.recording = Recording()
            let url = await recorder.startRecording { duration, samples in
                DispatchQueue.main.async { [weak self] in
                    self?.attachments.recording?.duration = duration
                    self?.attachments.recording?.waveformSamples = samples
                }
            }
            if state == .waitingForRecordingPermission {
                state = .isRecordingTap
            }
            attachments.recording?.url = url
        }
    }
}

private extension InputViewModel {

    func validateDraft() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            guard state != .editing else { return } // special case
            if !self.text.isEmpty || !self.attachments.medias.isEmpty {
                self.state = .hasTextOrMedia
            } else if self.text.isEmpty,
                      self.attachments.medias.isEmpty,
                      self.attachments.recording == nil {
                self.state = .empty
            }
        }
    }

    func subscribeValidation() {
        $attachments.sink { [weak self] _ in
            self?.validateDraft()
        }
        .store(in: &subscriptions)

        $text.sink { [weak self] _ in
            self?.validateDraft()
        }
        .store(in: &subscriptions)
    }

    func subscribePicker() {
        $showPicker
            .sink { [weak self] value in
                if !value {
                    self?.attachments.medias = []
                }
            }
            .store(in: &subscriptions)
    }

    func subscribeRecordPlayer() {
        recordPlayerSubscription = recordingPlayer?.didPlayTillEnd
            .sink { [weak self] in
                self?.state = .hasRecording
            }
    }

    func unsubscribeRecordPlayer() {
        recordPlayerSubscription = nil
    }
}

private extension InputViewModel {
    
    func mapAttachmentsForSend() -> AnyPublisher<[PickedMedia], Never> {
        return photoPickerItems.publisher
            .receive(on: DispatchQueue.global())
            .asyncMap { media in
                let item = try! await PickedMedia.loadData(media)
                return item
            }
            .compactMap { $0 }
            .collect()
            .eraseToAnyPublisher()
    }

    func sendMessage() -> AnyCancellable {
        showActivityIndicator = true
        return mapAttachmentsForSend()
            .receive(on: DispatchQueue.global())
            .compactMap { [attachments] pickedMedia in
                DraftMessage(
                    text: self.text,
                    medias: attachments.medias + pickedMedia,
                    recording: attachments.recording,
                    replyMessage: attachments.replyMessage,
                    createdAt: Date()
                )
            }
            .sink { [weak self] draft in
                DispatchQueue.main.async { [self, draft] in
                    self?.showActivityIndicator = false
                    self?.didSendMessage?(draft)
                    self?.reset()
                }
            }
    }
}

extension Publisher {
    func asyncMap<T>(
        _ transform: @escaping (Output) async -> T
    ) -> Publishers.FlatMap<Future<T, Never>, Self> {
        flatMap { value in
            Future { promise in
                Task {
                    let output = await transform(value)
                    promise(.success(output))
                }
            }
        }
    }
}
