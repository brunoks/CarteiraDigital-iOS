//
//  TransactionsModel.swift
//  UCLCriptoCoin
//
//  Created by Bruno Vieira on 08/06/19.
//  Copyright © 2019 Bruno iOS Dev. All rights reserved.
//

import Foundation

struct Transaction: Decodable {
    var message: String?
}

struct Balanco: Decodable {
    var balance: Double?
}

struct NewWalletModel: Decodable {
    let private_key: String!
    let public_key: String!
}

struct NewPublicKeyModel: Decodable {
    let public_key: String!
}

struct GmailProfile: Decodable {
    let picture: String?
    let locale: String?
    let azp: String?
    let given_name: String?
    let family_name: String?
    let aud: String?
    let hd: String?
    let iat: Int?
    let email_verified: Int?
    let iss: String?
    let exp: Int?
    let sub: Int?
    let email: String?
    let at_hash: String?
    let name: String?
}
