//
//  MyProfileViewController.swift
//  test1
//
//  Created by admin on 13/12/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit

class MyProfileViewController: UIViewController {
    private var communicationCore = CommunicationCore()
    
    @IBOutlet weak var navigationBarTitle: UINavigationItem!
    @IBOutlet weak var showLoginViewBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let defaults = UserDefaults.standard
        if let username = defaults.string(forKey: UserLocalStorageKeys.username), let password = defaults.string(forKey: UserLocalStorageKeys.password)?.decryption(key: "jjcustomize") {
            if(!communicationCore.isLogined){
                print("not login")
                if let loginedUser = communicationCore.Login(username, password: password, completionHandler: loginCompletion){
                }
            }else{
                
            }
        }else{
            print("no defualt data")
            loginCompletion(false)
        }
    }
    
    @IBAction func showLoginView(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "segueLoginView", sender: self)
    }
    
    private func loginCompletion(_ result: Any){
        switch result {
        case is User:
            navigationBarTitle.title = (result as! User).fullName
            showLoginViewBtn.title = "切换用户"
            break
        case is Bool:
            if(!(result as! Bool)){
                showLoginViewBtn.title = "登录"
                self.performSegue(withIdentifier: "segueLoginView", sender: self)
            }
            break
        default:
            self.performSegue(withIdentifier: "segueLoginView", sender: self)
            break
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
