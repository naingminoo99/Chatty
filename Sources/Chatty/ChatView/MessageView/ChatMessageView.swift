//
//  ChatMessageView.swift
//  
//
//  Created by Alisa Mylnikova on 20.03.2023.
//

import SwiftUI

struct ChatMessageView<MessageContent: View>: View {

    typealias MessageBuilderClosure = ChatView<MessageContent, EmptyView, DefaultMessageMenuAction>.MessageBuilderClosure

    @ObservedObject var viewModel: ChatViewModel

    var messageBuilder: MessageBuilderClosure?

    let row: MessageRow
    let chatType: ChatType
    let avatarSize: CGFloat
    let tapAvatarClosure: ChatView.TapAvatarClosure?
    let messageUseMarkdown: Bool
    let isDisplayingMessageMenu: Bool
    let showMessageTimeView: Bool
    let messageFont: UIFont

    var body: some View {
        Group {
            if let messageBuilder = messageBuilder {
                // Capture the result of the message builder
                let messageContent = messageBuilder(
                    row.message,
                    row.positionInUserGroup,
                    row.commentsPosition,
                    { viewModel.messageMenuRow = row },
                    viewModel.messageMenuAction()) { attachment in
                        self.viewModel.presentAttachmentFullScreen(attachment)
                    }

                // Check if the builder provided an empty view
                if messageContent is EmptyView {
                    // If it's an EmptyView, show the default MessageView
                    defaultMessageView
                } else {
                    // Otherwise, show the message content built by the builder
                    messageContent
                }
            } else {
                // If there is no messageBuilder at all, fallback to the default MessageView
                defaultMessageView
            }
        }
        .id(row.message.id)
    }
    // Default message view as a reusable property
    @ViewBuilder
    private var defaultMessageView: some View {
        MessageView(
            message: row.message,
            positionInUserGroup: row.positionInUserGroup,
            chatType: chatType,
            avatarSize: avatarSize,
            tapAvatarClosure: tapAvatarClosure,
            messageUseMarkdown: messageUseMarkdown,
            isDisplayingMessageMenu: isDisplayingMessageMenu,
            showMessageTimeView: showMessageTimeView,
            font: messageFont
        )
        .environmentObject(viewModel)
    }
}
