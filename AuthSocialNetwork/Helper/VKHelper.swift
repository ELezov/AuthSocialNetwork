//
//  VKHelper.swift
//  AuthSocialNetwork
//
//  Created by Eugene Lezov on 27.08.2018.
//  Copyright © 2018 Eugene Lezov. All rights reserved.
//

import Foundation
import VK_ios_sdk

class VKHelper {
    
    typealias BoolClosure = (Bool) -> Void
    
    enum Scope: String {
        case email
        case wall
        case photos
        case friends
    }
    
    enum Constants {
        static let VKApiKey = "6674533"
        static let accessTokenKey = "access_token"
    }
    
    static func authorize(scope:[String]) {
        VKSdk.authorize(scope)
    }
    
    static func initializeVKSdk(){
        VKSdk.initialize(withAppId: Constants.VKApiKey)
    }
    
    static func isWakeUpSession(scope:[String], completion: @escaping BoolClosure) {
        VKSdk.wakeUpSession(scope) { (state: VKAuthorizationState, error: Error?) in
            if state == .authorized {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    static func shareDialog(text: String, link:URL) -> VKShareDialogController {
        let shareDialog = VKShareDialogController()
        shareDialog.text = text
        shareDialog.shareLink = VKShareLink(title: "link", link: link)
        return shareDialog
    }
    
}
