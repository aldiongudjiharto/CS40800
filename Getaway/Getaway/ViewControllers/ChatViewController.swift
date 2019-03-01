//
//  ChatViewController.swift
//  Getaway
//
//  Created by Dhriti Chawla on 2/28/19.
//  Copyright © 2019 Avinash Singh. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController

class ChatViewController: JSQMessagesViewController {
    var messages = [JSQMessage]()
    var ChatsRef = Database.database().reference()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
//        if #available(iOS 11.0, *) {
//           let bottomPadding = view.safeAreaInsets.bottom
//            self.view.set        }
        
        self.tabBarController?.tabBar.isHidden = true
        //
        senderDisplayName = "User"
        senderId = "000"
        
        var userDictionary:[String: String] = ["":""]
        FirebaseClient().retrieveUserInformation(completion: {(userDict) in
            userDictionary = userDict
            
            self.senderDisplayName = "\(userDictionary["firstName"]!)" + " " +
            "\(userDictionary["lastName"]!)"
            self.senderId = userDictionary["username"]!
            
            self.title = "Chat: \(self.senderDisplayName!)"
        })
        //
        
        
        inputToolbar.contentView.leftBarButtonItem = nil
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        let query = ChatsRef.child("Chats").queryLimited(toLast: 10)
        
        _ = query.observe(.childAdded, with: { [weak self] snapshot in
            
            if  let data        = snapshot.value as? [String: String],
                let id          = data["sender_id"],
                let name        = data["name"],
                let text        = data["text"],
                !text.isEmpty
            {
                if let message = JSQMessage(senderId: id, displayName: name, text: text)
                {
                    self?.messages.append(message)
                    self?.finishReceivingMessage()
                }
            }
        })
    }
    
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData!
    {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return messages.count
    }
    
    lazy var outgoingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.outgoingMessagesBubbleImage(with: UIColor(red:0.2, green:0.6, blue:0.74, alpha:1.0))
    }()
    
    lazy var incomingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.incomingMessagesBubbleImage(with: UIColor(red:0.5, green:0.2, blue:0.54, alpha:1.0))
    }()
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource!
    {
        return messages[indexPath.item].senderId == senderId ? outgoingBubble : incomingBubble
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource!
    {
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString!
    {
        return messages[indexPath.item].senderId == senderId ? nil : NSAttributedString(string: messages[indexPath.item].senderDisplayName)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat
    {
        return messages[indexPath.item].senderId == senderId ? 0 : 15
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!)
    {
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        let ref = ChatsRef.child("Chats").childByAutoId()

        let message = ["sender_id": senderId, "name": senderDisplayName, "text": text]

        ref.setValue(message)
        finishSendingMessage()
    }
    
    
}
