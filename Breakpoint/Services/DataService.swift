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
    public private(set) var _REF_FEED = DB_BASE.child("feed")
    
    func createDBUser(uid: String, userData: Dictionary<String, Any>) {
        REF_BASE.child(uid).updateChildValues(userData)
    }
}
