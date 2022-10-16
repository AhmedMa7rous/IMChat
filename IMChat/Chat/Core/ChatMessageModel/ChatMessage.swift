//
//  MessageModel.swift
//  IMChat
//
//  Created by Ma7rous on 16/10/2022.
//

import Foundation

public protocol ChatMessage: Codable {
    var kind: Chat.Kind? { get set }
    var fromYou: Bool? { get set }
    var date: String? { get set }
}

public protocol ChatMessageImage: ChatMessage {
    var image: String? { get set }
}

public extension Array {
    func transform<T: Codable>(_ model: T.Type) -> [T] {
        var list: [T] = []
        self.forEach { item in
            if let newItem = item as? T {
                list.append(newItem)
            }
        }
        return list
    }
}



