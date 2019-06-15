//
//  CarteiraViewController.swift
//  UCLCriptoCoin
//
//  Created by Mac Novo on 04/12/18.
//  Copyright © 2018 Bruno iOS Dev. All rights reserved.
//

import UIKit
import CoreData

class CarteiraViewController: UIViewController {
    
    deinit {
        print("Removeu referência")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeBackLabelAndChangeColor(with: .lightGreen)
    }
    
    var isEditable = false
    lazy var saldoView = SaldoView()
    let wallet = CarteiraViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.navigationItem.hidesSearchBarWhenScrolling = true
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.barTintColor = .strongBlack
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        self.saldoView.qrcodeImage.addTarget(self, action: #selector(actionQrCodeButton), for: .touchUpInside)
        self.saldoView.saldolabel.addTarget(self, action: #selector(pegarBalancoCriptoMoeda), for: .touchUpInside)
        configureFormVC()
        pegarBalancoCriptoMoeda()
        if let public_key = self.wallet.carteira.publicKey {
            self.saldoView.qrcodeImage.setImage(gerarQRcode(public_key), for: .normal)
        }
    }

    @objc
    func pegarBalancoCriptoMoeda() {
        let alerta = Alert(self)
        self.saldoView.startActivity()
        self.saldoView.textSaldo = " - - "
        self.wallet.pegarBalanco { [weak self] (result) in
            self?.saldoView.stopActivity()
            switch result {
            case .success(_):
                if let saldo = self?.wallet.carteira.saldo {
                    self?.saldoView.textSaldo = "\(Double(round(1000*saldo)/1000))".formataSaldo
                }
                break
            case .failure(_):
                alerta.normalAlert(with: "Erro ao atualizar saldo")
            }
        }
    }
    
    @objc
    func actionQrCodeButton() {
        Alert(self).showAlertWithTextField(with: "Digite sua senha") { [weak self] (password) in
            self?.gerarNovaChavePublica(password: password)
        }
    }
    
    func gerarNovaChavePublica(password: String?) {
        self.saldoView.startActivity()
        wallet.mudarChavePublica(password: password) { [weak self] (result) in
            self?.saldoView.stopActivity()
            
            if let error = result {
                Alert(self).normalAlert(with: error)
                return
            }
            if let chave = self?.wallet.carteira.publicKey {
                self?.saldoView.setImage = self?.gerarQRcode(chave)
            }
        }
    }
    
    func gerarQRcode(_ public_key: String) -> UIImage? {
        let data = public_key.data(using: String.Encoding.ascii)
        if let qrFilter = CIFilter(name: "CIQRCodeGenerator") {
            qrFilter.setValue(data, forKey: "inputMessage")
            if let qrImage = qrFilter.outputImage {
                let transform = CGAffineTransform(scaleX: 10, y: 10)
                let scaledQrImage = qrImage.transformed(by: transform)
                return UIImage(ciImage: scaledQrImage)
            }
        }
        return nil
    }
    
    @objc fileprivate func goToQrCodeViewController() {
        let qrView = QRCodeViewController()
        qrView.delegate = self
        self.present(qrView, animated: true, completion: nil)
    }
    
    fileprivate func configureFormVC() {
        
        self.view.backgroundColor = .strongBlack
        self.navigationItem.titleView = UIView()
        
        self.view.addSubview(self.saldoView)
        self.saldoView.anchor(top: self.view.layoutMarginsGuide.topAnchor, leading: self.view.leadingAnchor, bottom: self.view.layoutMarginsGuide.bottomAnchor, trailing: self.view.trailingAnchor)
        
        self.saldoView.pagarButton.addTarget(self, action: #selector(goToQrCodeViewController), for: .touchUpInside)
    }
    
}

extension CarteiraViewController: ProtocolQrCodeCatch {
    func didGetDataQrCodeProtocol(_ string: String) {
        let view = PaymentViewController()
        view.viewModel.destinatarioPublicKey = string
        view.viewModel.carteira = self.wallet.carteira
        view.delegate = self
        self.navigationController?.pushViewController(view, animated: true)
    }
}

extension CarteiraViewController: CheckViewControllerProtocol {
    func didPaymentSuccess(with message: String, valor: String?, destino: String?) {
        
        let viewcontroller = CheckingViewController()
        viewcontroller.destinatario = destino
        viewcontroller.valor = valor
        let data = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YYYY hh:mm"
        viewcontroller.successView.data.text = formatter.string(from: data)
        viewcontroller.modalPresentationStyle = .overFullScreen
        self.present(viewcontroller, animated: true, completion: nil)
    }
}
