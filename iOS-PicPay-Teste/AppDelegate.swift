//
//  AppDelegate.swift
//  iOS-PicPay-Teste
//
//  Created by Mac Novo on 03/12/18.
//  Copyright © 2018 Bruno iOS Dev. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import GoogleSignIn
import FirebaseAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let err = error {
            print(err)
            return
        }
        
        guard let idToken = user.authentication.idToken else { return }
        guard let accessTokan = user.authentication.accessToken else { return }
        
        let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessTokan)
        Auth.auth().signInAndRetrieveData(with: credentials) { [weak self] (authResult, error) in
            if let err = error {
                print("Failed to create a Firebase User with google Account")
                print(err)
                return
            }
            
            self?.self.googleDelegate?.didSignIn(user)
            
        }
    }
    
    weak var googleDelegate: DidSignInGmailUCL?
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("disconnect")
    }
    
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        window = UIWindow()
        
        if UserDefaults.standard.value(forKey: WalletKeysUser.private_key) != nil {
            let viewcontroller = CarteiraViewController()
            viewcontroller.navigationController?.isNavigationBarHidden = true
            window?.rootViewController = UINavigationController(rootViewController: viewcontroller)
        } else {
            window?.rootViewController = UINavigationController(rootViewController: PrimingController())
        }
        
        window?.makeKeyAndVisible()
        return true
    }

}

