//
//  QrCodeView.swift
//  iOS-PicPay-Teste
//
//  Created by Bruno Vieira on 27/04/19.
//  Copyright © 2019 Bruno iOS Dev. All rights reserved.
//

import Foundation
import UIKit

class QrCodeView: UIView {
    lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    lazy var ilustrationQR: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "qr-code-square")
        return view
    }()
    
    lazy var closeButton: UIButton = { [unowned self] in
        let button = UIButton()
        button.setImage(UIImage(named: "close-icon"), for: .normal)
        button.addTarget(self, action: #selector(self.actionCloseButton), for: .touchUpInside)
        return button
    }()
    
    var closeAction: () -> Void = { }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configure() {
        self.addSubview(self.backgroundView)
        //self.addSubview(self.ilustrationQR)
        self.addSubview(self.closeButton)
        
        self.bringSubviewToFront(self.closeButton)
        
        self.backgroundView.fillSuperview()
        
        self.closeButton.anchor(top: self.layoutMarginsGuide.topAnchor, leading: nil, bottom: nil, trailing: self.layoutMarginsGuide.trailingAnchor, padding: .init(), size: .init(width: 50, height: 50))
        
        //self.ilustrationQR.centerInSuperview(size:  CGSize(width: 390, height: 375))
    }
    
    @objc
    private func actionCloseButton() {
        self.closeAction()
    }
    
}
