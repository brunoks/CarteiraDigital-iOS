//
//  CriptoCoinAPI.swift
//  iOS-PicPay-Teste
//
//  Created by Bruno Vieira on 30/05/19.
//  Copyright © 2019 Bruno iOS Dev. All rights reserved.
//

import Foundation

class CriptoCoinAPI {
    
    private let baseurl = "https://uclcriptocoin.herokuapp.com/"
    
    enum CasesRequest {
        case success(String)
        case failure(String)
    }
    
    enum EndPoint: String {
        case gerarCarteira
        case gerarChavePublica
        case transacao
        case saldo
        
        var raw: String {
            switch self {
            case .gerarCarteira:
                return "generate_wallet"
            case .gerarChavePublica:
                return "generate_public_key"
            case .transacao:
                return "transaction"
            case .saldo:
                return "balance"
            }
        }
    }
    
    func cadastrarCarteira(_ completed: @escaping (Result<NewWalletModel,Error>) -> Void) {
        let url = "\(baseurl)" + EndPoint.gerarCarteira.raw
        
        BrunoFire.request(url) { (error, keys: NewWalletModel?) in
            if let error = error {
                completed(.failure(error))
            } else if let keys = keys {
                completed(.success(keys))
            } else {
                completed(.failure("Erro criar carteira" as! Error))
            }
            
        }
    }
    
    func mudarChavePublica(_ privateKey: String, _ completed: @escaping (Result<String,Error>) -> Void) {
        
        let url = "\(baseurl)" + EndPoint.gerarChavePublica.raw
        
        let parametros: [String:Any] = [
            "private_key":privateKey
        ]
        
        BrunoFire.request(url, method: .post, parameters: parametros) { (error, public_key: NewPublicKeyModel?) in
            if let error = error {
                completed(.failure(error))
            } else if let key = public_key?.public_key {
                completed(.success(key))
            } else {
                completed(.failure("Erro criar carteira" as! Error))
            }
        }
    }
    
    func pegarBalanco(_ publicKey: String, _ completed: @escaping (Result<Balanco?,Error>) -> Void) {
        
        let url = "\(baseurl)" + EndPoint.saldo.raw
        
        let parametros: [String:Any] = [
            "public_key":publicKey,
        ]
        
        BrunoFire.requestPayment(url, method: .post, parameters: parametros) { (error, saldo: Balanco?) in
            if let error = error {
                completed(.failure(error))
            }
            completed(.success(saldo))
        }
    }
    
    func pagarSomebody(privateKey: String, publicKey: String, valor: String,_ completed: @escaping (CasesRequest) -> Void) {
        let valor = valor.replacingOccurrences(of: ",", with: ".")
        let url = "\(baseurl)" + EndPoint.transacao.raw
        let parametros: [String:Any] = [
            "private_key":privateKey,
            "public_key":publicKey,
            "value":valor
        ]
        BrunoFire.requestPayment(url, method: .post, parameters: parametros) { (error, retorno: Transaction?) in
            if let error = error {
                completed(.failure(error.localizedDescription))
            }
            if let mensagem = retorno?.message {
                completed(.success(mensagem))
            } else {
                completed(.failure(error?.localizedDescription ?? "Erro realizar pagamento"))
            }
        }
    }
    
}
