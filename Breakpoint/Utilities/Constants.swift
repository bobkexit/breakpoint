//
//  Constants.swift
//  Breakpoint
//
//  Created by Николай Маторин on 15.12.2017.
//  Copyright © 2017 Николай Маторин. All rights reserved.
//

import Foundation
import Firebase

typealias AuthCompletionHandler = (_ success: Bool,_ error: Error?) -> Void
typealias CompletionHandler = (_ success: Bool) -> Void

// Data Base
let DB_BASE = Database.database().reference()

// Storyboard ids
let SB_AuthVC = "AuthVC"
let SB_LoginVC = "LoginVC"

let SEGUE_ToCreateAccount = "ToCreateAccount"
let UNWIND = "ToFeedVC"

// Place holders
let PLACEHOLDER_FOR_TEXTVIEW = "Type here..."

// Table cells
let FEED_CELL = "feedCell"
let GROUP_CELL = "groupCell"
let USER_CELL = "userCell"
