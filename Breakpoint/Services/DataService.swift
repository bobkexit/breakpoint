//
//  DataService.swift
//  Breakpoint
//
//  Created by Николай Маторин on 15.12.2017.
//  Copyright © 2017 Николай Маторин. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    static let instance = DataService()
    
    public private(set) var REF_BASE = DB_BASE
    public private(set) var REF_USERS = DB_BASE.child("users")
    public private(set) var REF_GROUPS = DB_BASE.child("groups")
    public private(set) var REF_FEED = DB_BASE.child("feed")
    
    public private(set) var FeedMessages = [Message]()
    
    func createDBUser(uid: String, userData: [String: Any]) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func uploadPost(withMessage message: String, forUID uid: String, withGroupKey groupKey: String?, completion: @escaping CompletionHandler) {
        
        REF_FEED.childByAutoId().updateChildValues(["content": message, "senderId": uid, "groupId": groupKey as Any])
        completion(true)
        
//        if groupKey != nil {
//            //REF_GROUPS.child(groupKey!).child("messages").
//        } else {
//            REF_FEED.childByAutoId().updateChildValues(["content": message, "senderId": uid])
//            completion(true)
//        }
    }
    
    func getFeedMessages(completion: @escaping CompletionHandler) {
        REF_FEED.observeSingleEvent(of: .value) { (feedMsgSnapshot) in
            guard let feedMsgSnapshot = feedMsgSnapshot.children.allObjects as? [DataSnapshot] else { return }
            self.FeedMessages.removeAll()
            for message in feedMsgSnapshot {
                if message.hasChild("groupId") {
                    continue
                }
                let content = message.childSnapshot(forPath: "content").value as! String
                let senderId = message.childSnapshot(forPath: "senderId").value as! String
                let feedMsg = Message(content: content, senderId: senderId)
                self.FeedMessages.insert(feedMsg, at: 0)
            }
            completion(true)
        }
    }
    
    func getFeedMessages(forGroup group: Group, completion: @escaping (_ messages: [Message]) -> ()) {
        var messages = [Message]()
        let ref = REF_FEED.queryOrdered(byChild: "groupId").queryEqual(toValue: group.id)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            let enumerator = snapshot.children
            while let msg = enumerator.nextObject() as? DataSnapshot {
                let content = msg.childSnapshot(forPath: "content").value as! String
                let senderId = msg.childSnapshot(forPath: "senderId").value as! String
                let message = Message(content: content, senderId: senderId)
                messages.append(message)
            }
            completion(messages)
        }
    }
    
    func getUserName(forUID uid: String, handler: @escaping (_ userName: String) -> Void) {
        REF_USERS.child(uid).observe(.value) { (snapshot) in
            let username = snapshot.childSnapshot(forPath: "email").value as! String
            handler(username)
        }
    }
    
     //TODO: replace with model
    func getEmail(forSearchQuery query: String, completion: @escaping (_ emailArray: [String]) -> ()) {
        var emailArray = [String]()
        let ref = REF_USERS.queryOrdered(byChild: "email").queryStarting(atValue: query).queryEnding(atValue: query + "\u{f8ff}")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            let enumerator = snapshot.children
            while let user = enumerator.nextObject() as? DataSnapshot {
                let email = user.childSnapshot(forPath: "email").value as! String
                if email == Auth.auth().currentUser?.email {
                    continue
                }
                emailArray.append(email)
            }
            completion(emailArray)
        }
    }
    
    func getEmails(forGroup group: Group, completion: @escaping (_ emails: [String]) -> ()) {
        var emails = [String]()
        group.members.forEach { (id) in
            getUserName(forUID: id, handler: { (email) in
                emails.append(email)
                if emails.count == group.members.count {
                    completion(emails)
                }
            })
        }
    }
    
    //TODO: remove after replace with model
    func getIDs(forUsernames usernames: [String], completion: @escaping (_ uids: [String]) -> ()) {
        var uids = [String]()
        for username in usernames {
            let ref = REF_USERS.queryOrdered(byChild: "email").queryEqual(toValue: username)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let enumerator = snapshot.children
                while let user = enumerator.nextObject() as? DataSnapshot {
                    uids.append(user.key)
                }
                
                if uids.count == usernames.count {
                    completion(uids)
                }
            })
        }
    }
    
    func createGroup(withTitle title: String, andDescription description: String, forUserIds userIds: [String], completion: @escaping CompletionHandler) {
        //REF_GROUPS.childByAutoId().updateChildValues(["title": title, "description": description, "members": userIds])
        
        var members = [String:Bool]()
        userIds.forEach { (id) in
            members[id] = true
        }
        REF_GROUPS.childByAutoId().updateChildValues(["title": title, "description": description, "members": members])
        completion(true)
    }
    
    func getGroups(forUserId id: String, completion: @escaping (_ groups: [Group]) -> ()) {
        var groups = [Group]()
        let ref = REF_GROUPS.queryOrdered(byChild: "members/\(id)").queryEqual(toValue: true)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            
            let enumerator = snapshot.children
            while let group = enumerator.nextObject() as? DataSnapshot {
                let id = group.key
                let title = group.childSnapshot(forPath: "title").value as! String
                let description = group.childSnapshot(forPath: "description").value as! String

                var members = [String]()
                group.childSnapshot(forPath: "members").children.forEach({ (child) in
                    let child = child as! DataSnapshot
                    members.append(child.key)
                })

                let newGroup = Group(id: id, title: title, description: description, members: members)
                groups.append(newGroup)
            }
            completion(groups)
        }
    }
    
}
