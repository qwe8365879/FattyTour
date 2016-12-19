//
//  MyProfileViewController.swift
//  test1
//
//  Created by admin on 13/12/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit

class MyProfileViewController: UIViewController {
    
    @IBOutlet weak var navigationBarTitle: UINavigationItem!
    @IBOutlet weak var showLoginViewBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(forName: NSNotification.Name(notifictionNames.loginSuccess), object: nil, queue: nil){
            notification in
            print("notification is \(notification)")
            DispatchQueue.main.async {
                self.navigationBarTitle.title = (notification.object as! User).fullName
                self.showLoginViewBtn.title = "切换用户"
            }
            
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(notifictionNames.loginFailed), object: nil, queue: nil){
            notification in
            print("notification is \(notification)")
            DispatchQueue.main.async {
                self.navigationBarTitle.title = "未登录"
                self.showLoginViewBtn.title = "登录"
                self.performSegue(withIdentifier: "segueLoginView", sender: self)
            }
            
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
                communicationCore.Login(username, password: password)
            }else{
                loginCompletion(true)
            }
        }else{
            print("no defualt data")
            loginCompletion(false)
        }
    }
    
    @IBAction func showLoginView(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "segueLoginView", sender: self)
    }
    
    private func loginCompletion(_ result: Bool){
        if(!result){
            navigationBarTitle.title = "未登录"
            showLoginViewBtn.title = "登录"
            self.performSegue(withIdentifier: "segueLoginView", sender: self)
        }else{
            navigationBarTitle.title = communicationCore.getLoginedUser!.fullName
            showLoginViewBtn.title = "切换用户"
            print(communicationCore.getLoginedUser!)
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
