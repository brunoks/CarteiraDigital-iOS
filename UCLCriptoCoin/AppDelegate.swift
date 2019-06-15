//
//  AppDelegate.swift
//  iOS-PicPay-Teste
//
//  Created by Mac Novo on 03/12/18.
//  Copyright © 2018 Bruno iOS Dev. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
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

