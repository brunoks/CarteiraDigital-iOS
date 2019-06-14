//
//  PrimingController.swift
//  iOS-PicPay-Teste
//
//  Created by Mac Novo on 04/12/18.
//  Copyright © 2018 Bruno iOS Dev. All rights reserved.
//

import UIKit
import GoogleSignIn

class PrimingController: UIViewController {
    
    //Replace the color of next viewcontroller and change he's color to green
    override func viewWillDisappear(_ animated: Bool) {
        self.removeBackLabelAndChangeColor(with: .lightGreen)
    }
    
    
    lazy var priming: PrimingView = { [unowned self] in
        let view = PrimingView()
        view.assignButton.addTarget(self, action: #selector(fazerLoginGoogle), for: .touchUpInside)
        return view
    }()
    
    
    lazy var loginView = LoginView()
    override func viewDidLoad() {
        super.viewDidLoad()
        ConfigurePrimingVC()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        GIDSignIn.sharedInstance()?.signOut()
    }
    
    fileprivate func ConfigurePrimingVC() {
        self.view.backgroundColor = .strongBlack
        self.view.addSubview(self.priming)
        self.priming.fillSuperviewLayoutGuide()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        let scopes = ["https://www.googleapis.com/auth/userinfo.profile"]
        GIDSignIn.sharedInstance().scopes = scopes
        self.navigationController?.navigationBar.prefersLargeTitles = true
        if let appdelegate = UIApplication.shared.delegate as? AppDelegate {
            appdelegate.googleDelegate = self
        }
    }
    
    @objc
    fileprivate func fazerLoginGoogle() {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func salvarChaveCriptografada(text: String) {
        let file = "uclCriptoCoinChave.txt"
        
        let filename = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(file)
        
        do {
            try text.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
            
            let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
            activityVC.transitioningDelegate = self
            self.present(activityVC, animated: true, completion: nil)
        } catch {
        }
    }
    
    func abrirArquivoComChaveCriptografada() -> String? {
        
        let importMenu = UIDocumentPickerViewController(documentTypes: ["public.text"], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
        
        return nil
    }
    
    @objc
    fileprivate func cadastrarCarteira(with password: String?) {
        
        let wallet = CarteiraViewModel()
        Alert(self).loading(title: "Carregando")
        wallet.cadastrarCarteira(password: password) { [weak self] (erro, chave) in
            Alert(self).dissmiss()
            if let strong = self {
                if let erro = erro {
                    Alert(strong).normalAlert(with: "Erro ao realizar cadastro", and: erro)
                } else if let chave = chave {
                    self?.salvarChaveCriptografada(text: chave)
                }
            }
        }
    }
    
//    Alert(strong).normalAlert(with: "Cadastro realizado com sucesso") { [weak self] in
//    self?.chamaTelaPagamento()
//    }
    @objc fileprivate func chamaTelaPagamento() {
        let viewc = CarteiraViewController()
        self.present(viewc, animated: true, completion: nil)
    }
}

extension PrimingController: GIDSignInUIDelegate, DidSignInGmailUCL {
    func didSignIn(_ profile: GIDGoogleUser?) {
        
        UserDefaults.standard.setValue(profile!.profile.imageURL(withDimension: 100)?.absoluteString, forKey: "profile_image")
        
        Alert(self).showAlertWithTextField(with: "Digite uma senha pra salvar a chave privada") { [weak self] (senha) in
            self?.cadastrarCarteira(with: senha)
        }
    }
}


extension PrimingController: UIDocumentPickerDelegate, UINavigationControllerDelegate, UIViewControllerTransitioningDelegate {
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        print("import result : \(myURL)")
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
}


protocol DidSignInGmailUCL: class {
    func didSignIn(_ profile: GIDGoogleUser?)
}
