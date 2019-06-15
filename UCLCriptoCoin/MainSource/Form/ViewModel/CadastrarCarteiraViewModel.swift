//
//  CadastrarCarteiraViewModel.swift
//  UCLCriptoCoin
//
//  Created by Bruno Vieira on 09/05/19.
//  Copyright © 2019 Bruno iOS Dev. All rights reserved.
//

import Foundation

struct WalletKeysUser {
    static let private_key = "private_key_internal"
    static let public_key = "public_key_internal"
}

struct Carteira {
    var publicKey: String?
    var privateKey: String?
    var saldo: Double?
}

class CarteiraViewModel {
    
    var carteira = Carteira()
    
    init() {
        let privateKey = UserDefaults.standard.value(forKey: WalletKeysUser.private_key) as? String
        let publicKey = UserDefaults.standard.value(forKey: WalletKeysUser.public_key) as? String
        self.carteira.publicKey = publicKey
        self.carteira.privateKey = privateKey
    }
    
    func cadastrarCarteira(password: String?, _ completed: @escaping (String?,String?) -> Void) {
        let api = CriptoCoinAPI()
        api.cadastrarCarteira { (result) in
            switch result {
            case .success(let wallet):
                if let senha = password, let encrypted = try? EncrypDecrypHelp.encryptMessage(text: wallet.private_key, password: senha) {
                    UserDefaults.standard.setValue(encrypted, forKey: WalletKeysUser.private_key)
                    UserDefaults.standard.setValue(wallet.public_key, forKey: WalletKeysUser.public_key)
                    completed(nil,encrypted)
                } else {
                    completed("Falha ao encriptografar chave", nil)
                    return
                }
                
            case .failure(let error):
                completed(error.localizedDescription, nil)
                break
            }
        }
    }
    
    func mudarChavePublica(password: String?, _ completed: @escaping (String?) -> Void) {
        guard let password = password,
            let encrytedKey = UserDefaults.standard.value(forKey: WalletKeysUser.private_key) as? String,
        let private_key = try? EncrypDecrypHelp.decryptMessage(textCrypted: encrytedKey, password: password) else {
            completed("Falha ao descriptografar a chave privada. Tente novamente.")
            return
        }
        let api = CriptoCoinAPI()
        
        api.mudarChavePublica(private_key, { (result) in
            switch result {
            case .success(let chave):
                self.carteira.publicKey = chave
                UserDefaults.standard.setValue(chave, forKey: WalletKeysUser.public_key)
                completed(nil)
                break
            case .failure(let error):
                completed(error.localizedDescription)
            }
        })
    }
    
    func pegarBalanco(_ completed: @escaping (Result<String,Error>) -> Void) {

        guard let publicKey = self.carteira.publicKey else {
            completed(.failure("Chave inválida. Gere uma nova" as! Error))
            return
        }
        let api = CriptoCoinAPI()
        
        api.pegarBalanco(publicKey, { (result) in
            switch result {
            case .success(let saldo):
                self.carteira.saldo = saldo?.balance
                completed(.success("OK"))
            case .failure(let error):
                completed(.failure(error))
            }
        })
    }
    
}
