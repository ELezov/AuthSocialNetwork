//
//  ViewController.swift
//  AuthSocialNetwork
//
//  Created by Eugene Lezov on 27.08.2018.
//  Copyright © 2018 Eugene Lezov. All rights reserved.
//

import UIKit
import VK_ios_sdk

class ViewController: UIViewController {
    
    enum AuthType {
        case auth
        case notAuth
    }
    
    var state: AuthType = .notAuth {
        didSet {
            self.stateLabel.text = (state == .auth) ? "authorized" : "no authorized"
            self.authButton.setTitle((state == .auth) ? "logout" : "login", for: .normal)
        }
    }

    // MARK: - Outlets
    
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var authButton: UIButton!
    
    // MARK: - Actions
    
    @IBAction func logInTapped(_ sender: Any) {
        switch state {
        case .notAuth:
            VKHelper.authorize(scope: [])
        case .auth:
            VKSdk.forceLogout()
            state = .notAuth
        }
        
    }

    // MARK: - ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let vkInstance = VKSdk.initialize(withAppId: "6674533")
        vkInstance?.register(self)
        vkInstance?.uiDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        VKHelper.isWakeUpSession(scope: []) { [weak self] (isAuthorized) in
            self?.stateLabel.text = (isAuthorized) ? "authorized" : "no authorized"
        }
    }
}

extension ViewController: VKSdkDelegate {
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        state = (result.token != nil) ? .auth : .notAuth
        
        if state == .auth {
            VKApi
                .friends()
                .get()
                .execute(
                    resultBlock: { (_ response: VKResponse<VKApiObject>?) in
                        // List of friends
                        print(response?.json ?? "")
                },
                    errorBlock: { error in
                        print(error?.localizedDescription ?? "")
                })
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension ViewController: VKSdkUIDelegate {
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        self.present(controller, animated: true, completion: nil)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        let vc = VKCaptchaViewController.captchaControllerWithError(captchaError)
        vc?.present(in: self.navigationController?.topViewController)
    }
}

