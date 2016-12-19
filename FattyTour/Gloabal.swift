//
//  Gloabal.swift
//  FattyTour
//
//  Created by admin on 16/12/16.
//  Copyright © 2016 FattyTour. All rights reserved.
//

import Foundation


struct UserLocalStorageKeys {
    static let username = "username"
    static let password = "password"
}

struct User {
    var id: String
    var fullName : String
}

struct notifictionNames {
    static let loginSuccess = "LoginSuccess"
    static let loginFailed = "LoginFailed"
}

var communicationCore = CommunicationCore()
