//
//  SwiftUIView.swift
//
//
//  Created by Alisa Mylnikova on 06.12.2023.
//

import SwiftUI
import MediaCache

public extension ChatView where MessageContent == EmptyView {

    init(messages: [Message],
         chatType: ChatType = .conversation,
         replyMode: ReplyMode = .quote,
         didSendMessage: @escaping (DraftMessage) -> Void,
         inputViewBuilder: @escaping InputViewBuilderClosure,
         messageMenuAction: MessageMenuActionClosure?,
         urlLoader: URLLoader) {
        self.type = chatType
        self.didSendMessage = didSendMessage
        self.sections = ChatView.mapMessages(messages, chatType: chatType, replyMode: replyMode)
        self.ids = messages.map { $0.id }
        self.inputViewBuilder = inputViewBuilder
        self.messageMenuAction = messageMenuAction
        self.urlLoader = urlLoader
    }
}

public extension ChatView where InputViewContent == EmptyView {

    init(messages: [Message],
         chatType: ChatType = .conversation,
         replyMode: ReplyMode = .quote,
         didSendMessage: @escaping (DraftMessage) -> Void,
         messageBuilder: @escaping MessageBuilderClosure,
         messageMenuAction: MessageMenuActionClosure?,
         urlLoader: URLLoader) {
        self.type = chatType
        self.didSendMessage = didSendMessage
        self.sections = ChatView.mapMessages(messages, chatType: chatType, replyMode: replyMode)
        self.ids = messages.map { $0.id }
        self.messageBuilder = messageBuilder
        self.messageMenuAction = messageMenuAction
        self.urlLoader = urlLoader
    }
}

public extension ChatView where MenuAction == DefaultMessageMenuAction {

    init(messages: [Message],
         chatType: ChatType = .conversation,
         replyMode: ReplyMode = .quote,
         didSendMessage: @escaping (DraftMessage) -> Void,
         messageBuilder: @escaping MessageBuilderClosure,
         inputViewBuilder: @escaping InputViewBuilderClosure,
         urlLoader: URLLoader) {
        self.type = chatType
        self.didSendMessage = didSendMessage
        self.sections = ChatView.mapMessages(messages, chatType: chatType, replyMode: replyMode)
        self.ids = messages.map { $0.id }
        self.messageBuilder = messageBuilder
        self.inputViewBuilder = inputViewBuilder
        self.urlLoader = urlLoader
    }
}

public extension ChatView where MessageContent == EmptyView, InputViewContent == EmptyView {

    init(messages: [Message],
         chatType: ChatType = .conversation,
         replyMode: ReplyMode = .quote,
         didSendMessage: @escaping (DraftMessage) -> Void,
         messageMenuAction: MessageMenuActionClosure?,
         urlLoader: URLLoader) {
        self.type = chatType
        self.didSendMessage = didSendMessage
        self.sections = ChatView.mapMessages(messages, chatType: chatType, replyMode: replyMode)
        self.ids = messages.map { $0.id }
        self.messageMenuAction = messageMenuAction
        self.urlLoader = urlLoader
    }
}

public extension ChatView where InputViewContent == EmptyView, MenuAction == DefaultMessageMenuAction {

    init(messages: [Message],
         chatType: ChatType = .conversation,
         replyMode: ReplyMode = .quote,
         didSendMessage: @escaping (DraftMessage) -> Void,
         messageBuilder: @escaping MessageBuilderClosure,
         urlLoader: URLLoader) {
        self.type = chatType
        self.didSendMessage = didSendMessage
        self.sections = ChatView.mapMessages(messages, chatType: chatType, replyMode: replyMode)
        self.ids = messages.map { $0.id }
        self.messageBuilder = messageBuilder
        self.urlLoader = urlLoader
    }
}

public extension ChatView where MessageContent == EmptyView, MenuAction == DefaultMessageMenuAction {

    init(messages: [Message],
         chatType: ChatType = .conversation,
         replyMode: ReplyMode = .quote,
         didSendMessage: @escaping (DraftMessage) -> Void,
         inputViewBuilder: @escaping InputViewBuilderClosure,
         urlLoader: URLLoader) {
        self.type = chatType
        self.didSendMessage = didSendMessage
        self.sections = ChatView.mapMessages(messages, chatType: chatType, replyMode: replyMode)
        self.ids = messages.map { $0.id }
        self.inputViewBuilder = inputViewBuilder
        self.urlLoader = urlLoader
    }
}

public extension ChatView where MessageContent == EmptyView, InputViewContent == EmptyView, MenuAction == DefaultMessageMenuAction {

    init(messages: [Message],
         chatType: ChatType = .conversation,
         replyMode: ReplyMode = .quote,
         didSendMessage: @escaping (DraftMessage) -> Void,
         urlLoader: URLLoader) {
        self.type = chatType
        self.didSendMessage = didSendMessage
        self.sections = ChatView.mapMessages(messages, chatType: chatType, replyMode: replyMode)
        self.ids = messages.map { $0.id }
        self.urlLoader = urlLoader
    }
}
