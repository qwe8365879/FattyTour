//
//  CommunicationCore.swift
//  test1
//
//  Created by admin on 12/12/16.
//  Copyright © 2016 admin. All rights reserved.
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

class CommunicationCore{
    private let encryptKey = "jjcustomize"
    private var logined = false
    private var loginedUser: User = User(id: "0", fullName: "")
    
    var isLogined: Bool {
        get{
            return logined
        }
    }
    
    var getLoginedUser: User? {
        get{
            return loginedUser
        }
    }
    
    struct Urls {
        static let host = "https://test-qwe8365879.c9users.io/"
        static let api = "wp-admin/admin-ajax.php"
    }
    
    internal func Login(_ username: String, password: String, completionHandler: @escaping (Any) -> () ) -> User?{
        print("try login")
        let url = URL(string: Urls.host + Urls.api)!
        let passwordEncrypted = password.encrypt(key: encryptKey)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let postString = "action=jj_test&username=\(username)&password=\(passwordEncrypted)"
        
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let result = try? JSONSerialization.jsonObject(with: data)
            if let dict = result as? [String: Any]{
                for (k, v) in dict{
                    print(k)
                    print(v)
                }
                if let hasError = dict["hasError"]{
                    if !(hasError as! (Bool)) {
                        let defaults = UserDefaults.standard
                        
                        defaults.setValue(username, forKey: UserLocalStorageKeys.username)
                        defaults.setValue(passwordEncrypted, forKey: UserLocalStorageKeys.password)
                        
                        defaults.synchronize()
                        
                        if let userData = dict["userData"] as? [String: Any]{
                            self.loginedUser.fullName = userData["display_name"] as! String
                            self.loginedUser.id = userData["ID"] as! String
                        }
                        completionHandler(self.loginedUser)
                        self.logined = true
                    }else{
                        let defaults = UserDefaults.standard
                        
                        defaults.removeObject(forKey: UserLocalStorageKeys.username)
                        defaults.removeObject(forKey: UserLocalStorageKeys.password)
                        
                        defaults.synchronize()
                        completionHandler(false)
                        self.logined = false
                    }
                }else{
                    completionHandler(false)
                    self.logined = false
                }
            }
            
        }
        task.resume()
        return self.loginedUser
    }
    
    internal func request(location: String = "") -> URLRequest?{
        let urlEncodedLocation = location.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        if let url = URL(string: Urls.host + urlEncodedLocation) {
            let urlRequest = URLRequest(url: url)
            return urlRequest
        }
        return nil
    }
    
    
}
