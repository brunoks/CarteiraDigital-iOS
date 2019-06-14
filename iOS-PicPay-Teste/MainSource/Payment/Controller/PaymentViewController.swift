//
//  PaymentViewController.swift
//  iOS-PicPay-Teste
//
//  Created by Mac Novo on 04/12/18.
//  Copyright © 2018 Bruno iOS Dev. All rights reserved.
//

import UIKit

protocol CheckViewControllerProtocol: class {
    func didPaymentSuccess(with message: String, valor: String?, destino: String?)
}

class PaymentViewController: UIViewController {

    deinit {
        print("Removeu referência")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.configureNavTitle()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navibar.removeFromSuperview()
        self.removeBackLabelAndChangeColor(with: .lightGreen)
    }
    
    let paymentView: ViewButton = {
        let view = ViewButton()
        view.button.isUserInteractionEnabled = false
        view.button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        view.button.isHidden = false
        view.button.backgroundColor = .lightGray
        view.button.setTitle("Pagar", for: .normal)
        view.button.addTarget(self, action: #selector(actionPagamento(_:)), for: .touchUpInside)
        return view
    }()
    
    
    let navibar = NaviBarCustom()
    let payment = PaymentView()
    let viewModel:CredCardViewModel = CredCardViewModel()
    weak var delegate: CheckViewControllerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePaymentView()
    }
    
    fileprivate func configurePaymentView() {
        self.view.addSubview(self.payment)
        self.payment.fillSuperview()
        self.view.backgroundColor = .strongBlack
        self.payment.valuePayment.delegate = self
        self.payment.editCredcard.addTarget(self, action: #selector(pushNewCredCardFormVC), for: .touchUpInside)
    }
    
    fileprivate func configureNavTitle() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
//        navigationBar.addSubview(self.navibar)
//        self.navibar.anchor(top: nil, leading: navigationBar.leadingAnchor, bottom: navigationBar.bottomAnchor, trailing: navigationBar.trailingAnchor, padding: .init(), size: .init(width: 0, height: 60))
    }
    
    @objc
    fileprivate func actionPagamento(_ sender: DefaultButton) {
        Alert(self).showAlertWithTextField(with: "Digite sua senha para realizar o pagamento") { [weak self] (chave) in
            self?.realizarPagamento(password: chave)
        }
    }
    
    @objc
    fileprivate func realizarPagamento(password: String?) {
        self.paymentView.button.isUserInteractionEnabled = false
        self.paymentView.button.backgroundColor = .lightGray
    
        if let valor = self.payment.valuePayment.text,
            let password = password {
            self.viewModel.pagarSomebody(password: password, valor: valor) { [weak self] (error, retorno)  in
                
                if let error = error {
                    self?.didPaymentFailure(error)
                } else if let mensagem = retorno {
                    self?.didPaymentSuccess(mensagem)
                } else {
                    self?.didPaymentFailure("Erro servidor")
                }
            }
        } else {
            Alert(self).normalAlert(with: "Digite um valor")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.payment.valuePayment.endEditing(true)
    }
    
    @objc fileprivate func pushNewCredCardFormVC() {
        let viewc = CarteiraViewController()
        self.navigationController?.pushViewController(viewc, animated: true)
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }
    override var inputAccessoryView: UIView? {
        return self.paymentView
    }
}

extension PaymentViewController: UITextFieldDelegate {
    
    func didPaymentSuccess(_ message: String) {
        self.delegate?.didPaymentSuccess(with: message, valor: self.viewModel.valor, destino: self.viewModel.destinatarioPublicKey)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func didPaymentFailure(_ message: String) {
        Alert(self).showAlertWithTryAgain(title: "Erro na transação", text: message) {
            
        }
        self.paymentView.button.isUserInteractionEnabled = true
        self.paymentView.button.backgroundColor = .lightGreen
        self.changeButtonState(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.payment.valuePayment.changeColor()
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.payment.valuePayment.returnDefaultColor()
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let str = textField.text! + string
        var strchg = str.removeCharacters()
        let num = strchg.count
        
        if string == "" && textField.text!.last == "0" {
            self.changeButtonState(false)
        }
        if string != "" {
            self.changeButtonState(true)
            if num > 3 {
                textField.text =  strchg.maskOnTypingPayment()
                return false
            } else {
                if strchg.first == "0" {
                    strchg.removeFirst()
                }
                let st = "0,0" + strchg
                textField.text = st
                return false
            }
        } else {
            textField.text = strchg.removeMaskPayment()
            if Int(strchg) == 0 {
                self.changeButtonState(false)
            }
            return false
        }
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    fileprivate func changeButtonState(_ state: Bool) {
        if state {
            self.paymentView.button.isUserInteractionEnabled = state
            self.paymentView.button.backgroundColor = .lightGreen
        } else {
            self.paymentView.button.isUserInteractionEnabled = state
            self.paymentView.button.backgroundColor = .lightGray
        }
    }
    
}
