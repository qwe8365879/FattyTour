//
//  Communications.swift
//  test1
//
//  Created by admin on 7/12/16.
//  Copyright © 2016 admin. All rights reserved.
//

import Foundation
import CryptoSwift

extension String{
    
    func encrypt(key: String, expiry: Int = 0) -> String{
        let cKeyLength = 4
        let key = key.md5()
        
        let keyA = key.subCharString(with: 0 ..< 16).md5()
        let keyB = key.subCharString(with: 16 ..< 32).md5()
        
        var keyC = String(Int(NSDate().timeIntervalSince1970*1000))
        keyC = keyC.substring(with: keyC.index(keyC.endIndex, offsetBy: -cKeyLength)..<keyC.endIndex)
        
        let encryptKey = keyA + (keyA + keyC).md5()
        let keyLength = encryptKey.characters.count
        
        let timeNow = time(nil)
        var encryptedString = String(format: "%010d", expiry > 0 ? expiry + timeNow : 0)
        encryptedString += (self + keyB).md5().subCharString(with: 0..<16) + self
        let encryptedStringLength = encryptedString.characters.count
        
        var result = ""
        var box = Array(0...127)
        var randomKey = Array<Int>()
        
        for i in 0...127{
            randomKey.append( Int(encryptKey.charAt(i: i % keyLength).asciiValue!) )
        }
        
        var j = 0
        for i in 0...127{
            j = (j + box[i] + randomKey[i]) % 128
            let temp = box[i]
            box[i] = box[j]
            box[j] = temp
        }
        
        var a = 0
        j = 0
        for i in 0...(encryptedStringLength - 1){
            a = (a + 1) % 128
            j = (j + box[a]) % 128
            let temp = box[a]
            box[a] = box [j]
            box[j] = temp
            let k = box[a] + box[j]
            let ascii = Int(encryptedString.charAt(i: i).asciiValue!) ^ ( box[k % 128] )
            result += String(Character(UnicodeScalar(ascii)!))
        }
        
        let output = keyC + (result.data(using: .utf8)?.base64EncodedString())!
        
        return output
    }
    
    func decryption(key: String, expiry: Int = 0) -> String{
        let cKeyLength = 4
        let key = key.md5()
        
        let keyA = key.subCharString(with: 0 ..< 16).md5()
        let keyB = key.subCharString(with: 16 ..< 32).md5()
        
        let keyC = self.subCharString(with: 0 ..< cKeyLength)
        
        let encryptKey = keyA + (keyA + keyC).md5()
        let keyLength = encryptKey.characters.count
        
        let timeNow = time(nil)
        var encryptedString = String(data: Data(base64Encoded: self.subCharString(from: cKeyLength))!, encoding: .utf8)!
        let encryptedStringLength = encryptedString.characters.count
        
        var result = ""
        var box = Array(0...127)
        var randomKey = Array<Int>()
        
        for i in 0...127{
            randomKey.append( Int(encryptKey.charAt(i: i % keyLength).asciiValue!) )
        }
        
        var j = 0
        for i in 0...127{
            j = (j + box[i] + randomKey[i]) % 128
            let temp = box[i]
            box[i] = box[j]
            box[j] = temp
        }
        
        var a = 0
        j = 0
        for i in 0...(encryptedStringLength - 1){
            a = (a + 1) % 128
            j = (j + box[a]) % 128
            let temp = box[a]
            box[a] = box [j]
            box[j] = temp
            let k = box[a] + box[j]
            let ascii = Int(encryptedString.charAt(i: i).asciiValue!) ^ ( box[k % 128] )
            result += String(Character(UnicodeScalar(ascii)!))
        }
        let expiryDuration = Int(result.subCharString(with: 0 ..< 10))!
        if( (expiryDuration == 0 || expiryDuration - timeNow > 0) && result.subCharString(with: 10 ..< 26) == (result.subCharString(from: 26) + keyB).md5().subCharString(with: 0 ..< 16)){
            return result.subCharString(from: 26)
        }else{
            return ""
        }
    }
    
    func charAt (i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }
    
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func subCharString(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func subCharString(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func subCharString(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
    
    var asciiArray: [UInt32]{
        return unicodeScalars.filter{$0.isASCII}.map{$0.value}
    }
}

extension Character{
    var asciiValue: UInt32? {
        return String(self).unicodeScalars.filter{$0.isASCII}.first?.value
    }
}
