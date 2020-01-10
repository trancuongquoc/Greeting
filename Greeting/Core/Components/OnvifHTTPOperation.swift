//
//  ONVIFServiceOperation.swift
//  Greeting
//
//  Created by Quoc Cuong on 1/7/20.
//  Copyright © 2020 Tran Cuong. All rights reserved.
//

import Foundation

class OnvifHTTPOperation: HTTPCoreOperation {
    open var device: ONVIFDevice?
    
    override func httpParserOnSuccess() -> ContentParser {
        return .DEFAULT
    }
    
    override func requestURL() -> String {
        return device?.xAddr ?? ""
    }

    func randomAlphaNumericString(length: Int) -> String {
        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let allowedCharsCount = UInt32(allowedChars.count)
        var randomString = ""

        for _ in 0..<length {
            let randomNum = Int(arc4random_uniform(allowedCharsCount))
            let randomIndex = allowedChars.index(allowedChars.startIndex, offsetBy: randomNum)
            let newCharacter = allowedChars[randomIndex]
            randomString += String(newCharacter)
        }

        return randomString
    }
    
    func generateNonce() -> String {
        let randomString = self.randomAlphaNumericString(length: 24)
        return randomString
        //        return "LKqI7G/AikKCQrN0zqZFlg=="
    }
    
    func generateDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        let dateString = dateFormatter.string(from: Date())
        return dateString
    }
    
    func generatePasswordDigest(from password: String, with nonce: String, and dateString: String) -> String {
        guard let nonceData = Data(base64Encoded: nonce, options: .ignoreUnknownCharacters) else {
            print("PasswordDigest failed to encode!")
            return ""
        }
        
        let combinedString = dateString + password
        
        guard let combinedData = combinedString.data(using: .utf8) else {
            print("PasswordDigest failed to convert string!")
            return ""
        }
        
        let digest = (nonceData + combinedData).sha1
        
        return digest
    }
}
