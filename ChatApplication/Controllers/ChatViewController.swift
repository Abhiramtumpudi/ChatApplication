//
//  ChatViewController.swift
//  ChatApplication
//
//  Created by Abhiram Tumpudi on 13/09/24.
//

import UIKit
import MessageKit

struct Message : MessageType {
    var sender: any MessageKit.SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKit.MessageKind
}

struct Sender : SenderType {
    var senderId: String
    var displayName: String
    var photoUrl : String
    
}

class ChatViewController: MessagesViewController {
    
    private var messages = [Message]()
    
    private var selfSender = Sender(senderId: "1",
                                    displayName: "Joe Smith",
                                    photoUrl: "")

    override func viewDidLoad() {
        super.viewDidLoad()

        messages.append(Message(sender: selfSender,
                                messageId: "1",
                                sentDate: Date(),
                                kind: .text("hello World Message1")))
        messages.append(Message(sender: selfSender,
                                messageId: "2",
                                sentDate: Date(),
                                kind: .text("Hello World Message2")))
        messages.append(Message(sender: selfSender,
                                messageId: "3",
                                sentDate: Date(),
                                kind: .text("Hello World Message3")))
        // Do any additional setup after loading the view.
        messagesCollectionView.messagesDataSource      = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate  = self

    }

}

extension ChatViewController : MessagesDataSource , MessagesLayoutDelegate , MessagesDisplayDelegate  {
    
    
    
    func currentSender() -> any MessageKit.SenderType {
        return selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> any MessageKit.MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return messages.count
    }
    
}
