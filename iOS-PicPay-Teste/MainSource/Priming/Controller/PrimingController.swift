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
        let alert = UIAlertController(title: "Já possui cadastro?", message: "Selecione sua chave privada ou crie uma nova. Lembre-se de guardar o arquivo gerado e anotar sua senha!", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Cadastrar", style: .default) { [weak self] (_) in
            Alert(self).showAlertWithTextField(with: "Digite uma senha pra salvar a chave privada") { (senha) in
                self?.cadastrarCarteira(with: senha)
            }
        }
        let action2 = UIAlertAction(title: "Sim", style: .default) { [weak self] (_) in
            let _ = self?.abrirArquivoComChaveCriptografada()
        }
        alert.addAction(action1)
        alert.addAction(action2)
        self.present(alert, animated: true, completion: nil)
    }
    
    func salvarChaveCriptografada(text: String) {
    
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        activityVC.transitioningDelegate = self
        activityVC.completionWithItemsHandler = { [weak self] (_,completed,_,_) in
            if completed {
                self?.chamaTelaPagamento()
            }
        }
        self.present(activityVC, animated: true, completion: nil)
    }
    
    func abrirArquivoComChaveCriptografada() {
        
        let importMenu = UIDocumentPickerViewController(documentTypes: ["public.text"], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
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
    
    func cadastroConcluido() {
        Alert(self).normalAlert(with: "Cadastro realizado com sucesso") { [weak self] in
            self?.chamaTelaPagamento()
        }
    }

    @objc fileprivate func chamaTelaPagamento() {
        let viewc = CarteiraViewController()
        self.present(UINavigationController(rootViewController: viewc), animated: true, completion: nil)
    }
    
    func possuiCadastro() {
        self.abrirArquivoComChaveCriptografada()
    }
    
    func naoPossuiCadastro() {
        Alert(self).showAlertWithTextField(with: "Digite uma senha pra salvar a chave privada") { [weak self] (senha) in
            self?.cadastrarCarteira(with: senha)
        }
    }
    
}

extension PrimingController: GIDSignInUIDelegate, DidSignInGmailUCL {
    func didSignIn(_ profile: GIDGoogleUser?) {
        UserDefaults.standard.setValue(profile!.profile.imageURL(withDimension: 100)?.absoluteString, forKey: "profile_image")
    }
}


extension PrimingController: UIDocumentPickerDelegate, UINavigationControllerDelegate, UIViewControllerTransitioningDelegate {
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        let path = myURL.path
        
        do {
            
            let text = try String(contentsOfFile: path)
            UserDefaults.standard.setValue(text, forKeyPath: WalletKeysUser.private_key)
            
            Alert(self).showAlertWithTextField(with: "Digite sua senha.") { [weak self] (senha) in
                self?.gerarChavePublica(password: senha)
            }
        } catch {
            Alert(self).normalAlert(with: "Erro ao selecionar arquivo. Tente novamente")
        }
    }
    
    func gerarChavePublica(password: String?) {
        let api = CarteiraViewModel()
        Alert(self).loading(title: "Carregando")
        api.mudarChavePublica(password: password) { (alerta) in
            Alert(self).dissmiss()
            if let error = alerta {
                Alert(self).normalAlert(with: error)
            }
            Alert(self).normalAlert(with: "Tudo pronto", and: "", handler: { [weak self] in
                self?.chamaTelaPagamento()
            })
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
}


protocol DidSignInGmailUCL: class {
    func didSignIn(_ profile: GIDGoogleUser?)
}
