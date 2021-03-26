//
//  AppConfig.swift
//  TodoApp
//
//  Created by Komkrit.Sir on 24/3/2564 BE.
//

import SwiftyUserDefaults
import UIKit

struct AppConfig {
    static let baseUrl = "https://api-nodejs-todolist.herokuapp.com"
}

enum UserLoginState {
    case login
    case notLogin
}

class UserProfileManager: NSObject {
    static func getUserLoginState() -> UserLoginState {
        if (Defaults[.loginStatus] ?? false) == true {
            return UserLoginState.login
        } else {
            return UserLoginState.notLogin
        }
    }

    static func setUserLoginState(isLogin: Bool) {
        Defaults[.loginStatus] = isLogin
    }

    static func removeUserDefault() {
        Defaults[._id] = nil
        Defaults[.age] = nil
        Defaults[.name] = nil
        Defaults[.email] = nil
        Defaults[.createdAt] = nil
        Defaults[.updatedAt] = nil
        Defaults[.v] = nil
        Defaults[.token] = nil
    }
}

extension DefaultsKeys {
    static let loginStatus = DefaultsKey<Bool?>("loginStatus")
    static let _id = DefaultsKey<String?>("user-id")
    static let age = DefaultsKey<Int?>("user-age")
    static let name = DefaultsKey<String?>("user-name")
    static let email = DefaultsKey<String?>("user-email")
    static let createdAt = DefaultsKey<String?>("user-createdAt")
    static let updatedAt = DefaultsKey<String?>("user-updatedAt")
    static let v = DefaultsKey<Int?>("user-v")
    static let token = DefaultsKey<String?>("user-token")
}
