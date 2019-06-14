//
//  CryptoClass.swift
//  iOS-PicPay-Teste
//
//  Created by Bruno Vieira on 11/06/19.
//  Copyright © 2019 Bruno iOS Dev. All rights reserved.
//

import Foundation
import RNCryptor

class EncrypDecrypHelp {
    static func encryptMessage(text: String, password: String) throws -> String {
        let messageData = text.data(using: .utf8)!
        let cipherData = RNCryptor.encrypt(data: messageData, withPassword: password)
        return cipherData.base64EncodedString()
    }
    
    static func decryptMessage(textCrypted: String, password: String) throws -> String {
        
        let encryptedData = Data(base64Encoded: textCrypted)!
        let decryptedData = try RNCryptor.decrypt(data: encryptedData, withPassword: password)
        let decryptedString = String(data: decryptedData, encoding: .utf8)!
        
        return decryptedString
    }
}
