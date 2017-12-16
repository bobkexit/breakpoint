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
        if groupKey != nil {
            // send to group ref
        } else {
            REF_FEED.childByAutoId().updateChildValues(["content": message, "senderId": uid])
            completion(true)
        }
    }
    
    func getFeedMessages(completion: @escaping CompletionHandler) {
        REF_FEED.observeSingleEvent(of: .value) { (feedMsgSnapshot) in
            guard let feedMsgSnapshot = feedMsgSnapshot.children.allObjects as? [DataSnapshot] else { return }
            self.FeedMessages.removeAll()
            for message in feedMsgSnapshot {
                let content = message.childSnapshot(forPath: "content").value as! String
                let senderId = message.childSnapshot(forPath: "senderId").value as! String
                let feedMsg = Message(content: content, senderId: senderId)
                self.FeedMessages.insert(feedMsg, at: 0)
            }
            completion(true)
        }
    }
    
    func getUserName(forUID uid: String, handler: @escaping (_ userName: String) -> Void) {
        REF_USERS.child(uid).observe(.value) { (snapshot) in
            let username = snapshot.childSnapshot(forPath: "email").value as! String
            handler(username)
        }
    }
    
    func getEmail(forSearchQuery query: String, completion: @escaping (_ emailArray: [String]) -> ()) {
        var emailArray = [String]()
        REF_USERS.queryOrdered(byChild: "email").queryStarting(atValue: query).observeSingleEvent(of: .value) { (snapshot) in
            let enumerator = snapshot.children
            while let user = enumerator.nextObject() as? DataSnapshot {
                let email = user.childSnapshot(forPath: "email").value as! String
                emailArray.append(email)
            }
        }
        completion(emailArray)
    }
}
