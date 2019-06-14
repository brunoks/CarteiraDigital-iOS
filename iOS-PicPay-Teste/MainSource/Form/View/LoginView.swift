//
//  LoginView.swift
//  iOS-PicPay-Teste
//
//  Created by Bruno Vieira on 26/05/19.
//  Copyright © 2019 Bruno iOS Dev. All rights reserved.
//

import UIKit
import GoogleSignIn

class LoginView: UIView {
    
    let titlelabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 3
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 29)
        label.text = "Login na sua conta UCL"
        return label
    }()
    let descTitlelabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = """
        Antes de começar, precisamos que você faça login em sua conta @UCL. Isto é apenas para mantermos sua chave privada segura
        \nNão distribuiremos nenhum dado pessoal!.
        """
        return label
    }()
    
    lazy var signInButton = GIDSignInButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    fileprivate func configure() {
        self.addSubview(self.titlelabel)
        self.addSubview(self.descTitlelabel)
        self.addSubview(self.signInButton)
        
        self.titlelabel.anchorXY(centerX: self.centerXAnchor, centerY: nil, top: self.centerYAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 20, right: 0), size: .init(width: 300, height: 100))
        
        self.descTitlelabel.anchorXY(centerX: self.centerXAnchor, centerY: nil, top: self.titlelabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 5, left: 0, bottom: 0, right: 0), size: .init(width: 320, height: 100))
        
        self.signInButton.anchorXY(centerX: self.centerXAnchor, centerY: nil, top: self.descTitlelabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 5, left: 0, bottom: 0, right: 0), size: .init(width: 210, height: 40))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
