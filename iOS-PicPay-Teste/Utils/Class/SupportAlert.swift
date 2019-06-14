//
//  SupportAlert.swift
//  iOS-PicPay-Teste
//
//  Created by Bruno Vieira on 05/04/19.
//  Copyright © 2019 Bruno iOS Dev. All rights reserved.
//

import UIKit

struct Alert {
    
    func normalAlert(with title: String, and text: String = "") {
        let alerta = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let action1 = UIAlertAction(title: "OK", style: .default)
        alerta.addAction(action1)
        self.controller?.present(alerta, animated: true, completion: nil)
    }
    
    func normalAlert(with title: String, and text: String = "", handler: (() -> Void)? = nil) {
        let alerta = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let action1 = UIAlertAction(title: "OK", style: .default) { (_) in
            handler?()
        }
        alerta.addAction(action1)
        self.controller?.present(alerta, animated: true, completion: nil)
    }
    
    func showAlertWithTryAgain(title: String, text: String, completion: @escaping () -> Void) {
        let alerta = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let action1 = UIAlertAction(title: "OK", style: .destructive, handler: nil)
        let action2 = UIAlertAction(title: "Try Again", style: .default, handler: { _ in
            completion()
        })
        alerta.addAction(action1)
        alerta.addAction(action2)
        controller?.present(alerta, animated: true, completion: nil)
    }
    
    init(_ controller: UIViewController?) {
        self.controller = controller
    }
    
    var controller: UIViewController?
    
    func loading(title: String, message: String = "") {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let indicator = UIActivityIndicatorView(style: .gray)
        indicator.tintColor = .black
        indicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        indicator.isUserInteractionEnabled = false
        indicator.startAnimating()
        alertController.view.addSubview(indicator)
        indicator.anchorXY(centerX: nil, centerY: alertController.view.centerYAnchor, top: nil, leading: alertController.view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 20, bottom: 0, right: 0))
        self.controller?.present(alertController, animated: true, completion: nil)
    }
    
    func dissmiss() {
        self.controller?.dismiss(animated: true, completion: nil)
    }
    
    func showAlertWithTextField(with title: String,_ handler: @escaping (String?) -> Void) {
        var field: UITextField?
        
        let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            field = textField
        }
        
        let action1 = UIAlertAction(title: "OK", style: .default, handler: { _ in
            handler(field?.text)
        })
        let action2 = UIAlertAction(title: "Cancelar", style: .destructive, handler: { _ in
            
        })
        alertController.addAction(action1)
        alertController.addAction(action2)
        
        
        self.controller?.present(alertController, animated: true, completion: nil)
    }
}
