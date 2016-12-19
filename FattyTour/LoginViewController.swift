//
//  LoginViewController.swift
//  test1
//
//  Created by admin on 6/12/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController{
    
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var loginIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(forName: NSNotification.Name(notifictionNames.loginSuccess), object: nil, queue: nil){
            notification in
            DispatchQueue.main.async{
                self.loginBtn.isEnabled = true
                self.loginIndicator.stopAnimating()
                self.dismissLoginView(true)
            }
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(notifictionNames.loginFailed), object: nil, queue: nil){
            notification in
            DispatchQueue.main.async{
                self.loginBtn.isEnabled = true
                self.loginIndicator.stopAnimating()
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction private func Login(_ sender: UIButton) {
        let username = usernameTxt.text!
        let password = passwordTxt.text!
        
        communicationCore.Login(username, password: password)
        loginBtn.isEnabled = false
        loginIndicator.startAnimating()
    }
    
    @IBAction func closeLoginView(_ sender: UIBarButtonItem) {
        dismissLoginView(true)
    }
    
    private func dismissLoginView(_ result: Bool){
        if(result){
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
}
