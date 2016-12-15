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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private var communicationCore = CommunicationCore()
    
    @IBAction private func Login(_ sender: UIButton) {
        let username = usernameTxt.text!
        let password = passwordTxt.text!
        
        if let _ = communicationCore.Login(username, password: password, completionHandler: dismissLoginView){
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @IBAction func closeLoginView(_ sender: UIBarButtonItem) {
        dismissLoginView(true)
    }
    
    private func dismissLoginView(_ result: Any){
        
        switch result {
        case is Bool:
            if(result as! Bool){
                self.dismiss(animated: true, completion: nil)
            }
            break
        default:
            break
        }
    }
    
}
