//
//  Encryption.swift
//  Numoholic
//
//  Created by Dror Chen on 12/16/15.
//  Copyright © 2015 Dror Chen. All rights reserved.
//

import Foundation

func Encryption (itemToEncrypt: String) -> [String] {
    let itemArray = Array(itemToEncrypt.characters)
    var encryptedString = ""
    var hashKey = ""
    
    for charInString in itemArray {
        let char = "\(charInString)" as NSString
        let charsAscii: Int = Int(char.characterAtIndex(0))
        var randomAscii: Int = Int(arc4random_uniform(UInt32(74)))+48
        
        while (charsAscii+randomAscii)%2 != 0 {
            randomAscii = Int(arc4random_uniform(UInt32(74)))+48
        }
        
        let aveAscii = (charsAscii+randomAscii)/2
        let aveString = String(UnicodeScalar(aveAscii))
        let randString = String(UnicodeScalar(randomAscii))
        
        encryptedString += randString
        hashKey += aveString
    }
    
    return [encryptedString, hashKey]
}

func Decryption (itemToDecrypt: String, hashKey: String) -> String {
    let itemArray = Array(itemToDecrypt.characters)
    let keyArray = Array(hashKey.characters)
    var decryptedString = ""
    
    for var i = 0; i < keyArray.count; i++ {
        let itemChar = "\(itemArray[i])" as NSString
        let keyChar = "\(keyArray[i])" as NSString
        let itemAscii: Int = Int(itemChar.characterAtIndex(0))
        let keyAscii: Int = Int(keyChar.characterAtIndex(0))
        
        decryptedString += String(UnicodeScalar(keyAscii*2-itemAscii))
    }
    
    return decryptedString
}

func saveAndEncryptUserDefaults (name: String, hash: String, item: String) {
    let itemEncrypted = Encryption(item)
    NSUserDefaults.standardUserDefaults().setObject(itemEncrypted[0], forKey: name)
    NSUserDefaults.standardUserDefaults().setObject(itemEncrypted[1], forKey: hash)
    NSUserDefaults.standardUserDefaults().synchronize()
}

func getAndDecryptUserDefaults (name: String, hash: String) -> String? {
    let encryptedString = NSUserDefaults.standardUserDefaults().objectForKey(name) as! String?
    let hashKey = NSUserDefaults.standardUserDefaults().objectForKey(hash) as! String?
    
    if encryptedString == nil || hashKey == nil {
        return nil
    }
    
    return Decryption(encryptedString!, hashKey: hashKey!)
}

func getLevel() -> Int! {
    let value = getAndDecryptUserDefaults("l", hash: "lH")
    
    if value != nil {
        return Int(value!)
    }
    return nil
}

func getRemovedAds() -> Bool! {
    let value = getAndDecryptUserDefaults("a", hash: "aH")
    
    if value != nil {
        return (NSString(string: value!)).boolValue
    }
    return nil
}
