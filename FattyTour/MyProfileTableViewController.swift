//
//  MyProfileViewController.swift
//  test1
//
//  Created by admin on 13/12/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit

class MyProfileTableViewController: UITableViewController {
    
    @IBOutlet weak var showLoginViewLbl: UILabel!
    @IBOutlet weak var loginNameLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(forName: NSNotification.Name(notifictionNames.loginSuccess), object: nil, queue: nil){
            notification in
            DispatchQueue.main.async {
                self.loginNameLbl.text = (notification.object as! User).fullName
                self.showLoginViewLbl.text = "切换用户"
            }
            
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(notifictionNames.loginFailed), object: nil, queue: nil){
            notification in
            DispatchQueue.main.async {
                self.loginNameLbl.text = "未登录"
                self.showLoginViewLbl.text = "登录"
            }
            
        }
        
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
    
    private func loginCompletion(_ result: Bool){
        if(!result){
            loginNameLbl.text = "未登录"
            showLoginViewLbl.text = "登录"
        }else{
            loginNameLbl.text = communicationCore.getLoginedUser!.fullName
            showLoginViewLbl.text = "切换用户"
            print(communicationCore.getLoginedUser!)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "myAirportTransOrdersSegue"){
            let targetViewController = (segue.destination as! AirportTransOrdersTableViewController)
            targetViewController.orderType = "my_order"
            targetViewController.orderTypeTitle.title = "我的订单"
        }
        if(segue.identifier == "pendingAirportTransOrdersSegue"){
            let targetViewController = (segue.destination as! AirportTransOrdersTableViewController)
            targetViewController.orderType = "pending_order"
            targetViewController.orderTypeTitle.title = "新的订单"
        }
        if(segue.identifier == "bookedAirportTransOrdersSegue"){
            let targetViewController = (segue.destination as! AirportTransOrdersTableViewController)
            targetViewController.orderType = "booked_order"
            targetViewController.orderTypeTitle.title = "已抢订单"
        }
    }
    

}
