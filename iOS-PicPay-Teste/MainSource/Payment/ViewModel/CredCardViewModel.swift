//
//  CredCardViewModel.swift
//  iOS-PicPay-Teste
//
//  Created by Mac Novo on 07/12/18.
//  Copyright © 2018 Bruno iOS Dev. All rights reserved.
//

import Foundation


class CredCardViewModel {
    
    var carteira: Carteira?
    var destinatarioPublicKey: String?
    var valor: String?
    
    func pagarSomebody(password: String, valor: String,_ completed: @escaping (_ error: String?,_ retorno: String?) -> Void) {
        
        guard let encrypted = self.carteira?.privateKey,
            let decrypted = try? EncrypDecrypHelp.decryptMessage(textCrypted: encrypted, password: password),
            let publicKey = self.destinatarioPublicKey else {
                completed("Erro descriptografar a chave privada. Tente de novo.", nil)
                return
        }
        let api = CriptoCoinAPI()
        
        api.pagarSomebody(privateKey: decrypted, publicKey: publicKey, valor: valor) { (result) in
            switch result {
            case .success(let text):
                self.valor = valor
                completed(nil,text)
            case .failure(let error):
                completed(error, nil)

            }
        }
    }

}
