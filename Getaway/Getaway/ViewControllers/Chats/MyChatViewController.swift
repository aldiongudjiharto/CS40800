//
//  MyChatViewController.swift
//  Getaway
//
//  Created by Dhriti Chawla on 3/6/19.
//  Copyright © 2019 Avinash Singh. All rights reserved.
//

import UIKit
import Firebase

class MyChatViewController: JSQMessagesViewController {
    var friendUsername = ""
    var friendName = ""
    var myUsername = ""
    
    var friendsDict1:[String: String] = ["":""]
    var list = [""]
    var messages = [JSQMessage]()
    var ChatsRef = Database.database().reference().child("Chats")
    private var newMessageRefHandle: DatabaseHandle?
    
    
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
            
            self.myUsername = userDictionary["username"]!
            
            self.title = "\(self.friendUsername)"
            
            self.observeMessages()
            
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
    
    private func observeMessages() {
        
        let Ref = ChatsRef.child(myUsername).child(friendUsername)
        
        let messageQuery = Ref.queryLimited(toLast:25)
        
        // 2. We can use the observe method to listen for new
        // messages being written to the Firebase DB
        newMessageRefHandle = messageQuery.observe(.childAdded, with: { (snapshot) -> Void in
            // 3
            if let messageData = snapshot.value as? [String: String],
                let id = messageData["senderId"] as! String!,
                let name = messageData["senderName"] as! String!,
                let time = messageData["time"] as! String!,
                let text = messageData["text"] as! String!,
                text.characters.count > 0 {
                // 4
                self.addMessage(withId: id, name: name, text: text)
                
                // 5
                self.finishReceivingMessage()
            } else {
                print("Error! Could not decode message data")
            }
        })
        
    }
    
    private func addMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            messages.append(message)
        }
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
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        let currTime = "\(date) \(hour):\(minutes):\(seconds)"
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        Database.database().reference().child("Chats").child(myUsername).child(friendUsername).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            let itemRef1 = self.ChatsRef.child(self.myUsername).child(self.friendUsername).child("\(snapshot.childrenCount)")
            let itemRef2 = self.ChatsRef.child(self.friendUsername).child(self.myUsername).child("\(snapshot.childrenCount)")
        
        
            let message = ["senderId": senderId, "senderName": senderDisplayName, "text": text,
                           "time": currTime]
        
        itemRef1.setValue(message)
        itemRef2.setValue(message)
        
        self.finishSendingMessage()
        })
    }
    
    
}
