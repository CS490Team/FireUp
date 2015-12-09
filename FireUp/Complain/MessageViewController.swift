//
//  MessageViewController.swift
//  Fire Up
//
//  Created by HuangHanxun on 11/5/15.
//  Copyright © 2015 sunkai. All rights reserved.
//

import UIKit

class MessageViewController: JSQMessagesViewController {

    var room:PFObject!
    var incomingUser:PFUser!
    var users = [PFUser]()
    
    var messages = [JSQMessage]()
    var messageObject = [PFObject]()
    
    var outgoingBubleImage: JSQMessagesBubbleImage!
    var incomingBubleImage: JSQMessagesBubbleImage!
    
    var selfAvatar: JSQMessagesAvatarImage!
    var incomingAvatar: JSQMessagesAvatarImage!
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.hidden = false;
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.hidden = true;
        self.title = "Messages"
        self.senderId = PFUser.currentUser().objectId
        self.senderDisplayName = PFUser.currentUser().username
        let selfUsername = PFUser.currentUser().username as! NSString
        let incomingUsername = incomingUser.username as! NSString
        selfAvatar = JSQMessagesAvatarImageFactory.avatarImageWithUserInitials(selfUsername.substringWithRange(NSMakeRange(0,2)), backgroundColor: UIColor.blackColor(), textColor: UIColor.whiteColor(), font: UIFont.systemFontOfSize(14), diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault))
        incomingAvatar = JSQMessagesAvatarImageFactory.avatarImageWithUserInitials(selfUsername.substringWithRange(NSMakeRange(0,2)), backgroundColor: UIColor.blackColor(), textColor: UIColor.whiteColor(), font: UIFont.systemFontOfSize(14), diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault))
        
        if PFUser.currentUser()["User_Profile_Picture"] != nil {
            let self_profileImageFile = PFUser.currentUser()["User_Profile_Picture"] as! PFFile
            self_profileImageFile.getDataInBackgroundWithBlock{ (selfdata:NSData!, self_error:NSError!) -> Void in
                if self_error == nil {
                    let selfImage = UIImage(data: selfdata)
                    self.selfAvatar = JSQMessagesAvatarImageFactory.avatarImageWithImage(selfImage, diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault))
                    
                }
            }
        }
        
        if incomingUser["User_Profile_Picture"] != nil {
            let incoming_profileImageFile = incomingUser["User_Profile_Picture"] as! PFFile
            incoming_profileImageFile.getDataInBackgroundWithBlock{ (incominguserdata:NSData!, incoming_error:NSError!) -> Void in
                if incoming_error == nil {
                    let incomingImage = UIImage(data: incominguserdata)
                     self.incomingAvatar = JSQMessagesAvatarImageFactory.avatarImageWithImage(incomingImage, diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault))
                }
            }
        }
        
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        outgoingBubleImage = bubbleFactory.outgoingMessagesBubbleImageWithColor(UIColor.lightGrayColor())
        incomingBubleImage = bubbleFactory.incomingMessagesBubbleImageWithColor(UIColor.blueColor())
        loadMessages()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadMessages", name: "reloadMessages", object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "reloadMessages", object: nil)
    }
    
    func loadMessages(){

        var lastMessage: JSQMessage? = nil
        if messages.last != nil{
            lastMessage = messages.last!
        }
        
        let messageQuery = PFQuery(className: "Message")
        messageQuery.whereKey("room", equalTo: self.room)
        messageQuery.limit = 500
        messageQuery.includeKey("user")
        messageQuery.orderByAscending("createdAt")
        
        if lastMessage != nil{
            messageQuery.whereKey("createdAt", greaterThan: lastMessage!.date)
        }


        messageQuery.findObjectsInBackgroundWithBlock { (results:[AnyObject]!, error: NSError!) -> Void in
            if error == nil{
                let messages = results as! [PFObject]
                for message in messages {
                    self.messageObject.append(message)
                    
                    let user = message["user"] as! PFUser
                    self.users.append(user)
                    
                    let chatMessage = JSQMessage(senderId: user.objectId, senderDisplayName: user.username, date: message.createdAt, text: message["content"] as! String)
                    self.messages.append(chatMessage)
                }
            }
            if results.count != 0{
                self.finishReceivingMessage()
            }
        }
    }
    
    
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        let message = PFObject(className: "Message")
        message["content"] = text
        message["room"] = room
        message["user"] = PFUser.currentUser()
        message.saveInBackgroundWithBlock { (success:Bool, error: NSError!) -> Void in
            if error == nil{
                self.loadMessages()
                
                let pushQuery = PFInstallation.query()
                pushQuery.whereKey("User", equalTo: self.incomingUser)
                let push = PFPush()
                push.setQuery(pushQuery)
                let pushDictionary = ["alert":text, "badge":"increment", "sound":""]
                push.setData(pushDictionary)
                push.sendPushInBackgroundWithBlock(nil)
                print(NSDate())
                self.room["LastUpdate"] = NSDate()
                self.room.saveInBackgroundWithBlock(nil)
                let unreadMessage = PFObject(className: "UnreadMessage")
                unreadMessage["User"] = self.incomingUser
                unreadMessage["Room"] = self.room
                unreadMessage.saveInBackgroundWithBlock(nil)
                
            }else {
                print("error sending message")
                
            }
        }
        self.finishSendingMessage()
        
    }
    
    
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return messages[indexPath.row]
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.row]
        if message.senderId == self.senderId{
            return outgoingBubleImage
        }
        
        return incomingBubleImage
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = messages[indexPath.row]
        if message.senderId == self.senderId{
            return selfAvatar
        }
        
        return incomingAvatar
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        if indexPath.item%3 == 0{
            let message = messages[indexPath.item]
            return JSQMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(message.date)
        }
        return nil
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.row]
        if message.senderId == self.senderId{
            cell.textView?.textColor = UIColor.blackColor()
        }else{
            cell.textView?.textColor = UIColor.whiteColor()
        }
        cell.textView?.linkTextAttributes = [NSForegroundColorAttributeName: (cell.textView?.textColor)!]
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        if indexPath.item%3 == 0 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        return 0
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        if (indexPath.item%3 == 0){
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        return 0
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
