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
