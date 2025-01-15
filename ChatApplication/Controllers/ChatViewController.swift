//
//  ChatViewController.swift
//  ChatApplication
//
//  Created by Abhiram Tumpudi on 13/09/24.
//

import UIKit
import MessageKit
import InputBarAccessoryView

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
    
    public let OtherUserEmail : String
    
    public var isNewConverstaion = false
    
    init(with email : String) {
        self.OtherUserEmail = email
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("init coder has not implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        messagesCollectionView.messagesDataSource      = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate  = self
        messageInputBar.delegate = self

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()
    }

}

extension ChatViewController : InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty else {return}
        
        // send message
        print("Sending : \(text)")
        if isNewConverstaion {
            // create new converstaion in db
            
        } else {
            // otherwise append to conversation data
        }
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
