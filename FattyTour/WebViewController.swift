//
//  WebViewController.swift
//  test1
//
//  Created by admin on 6/12/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    private var communicationCore = CommunicationCore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self
        if let request = communicationCore.request(location: "接送机订单/"){
            webView.loadRequest(request)
        }else{
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
