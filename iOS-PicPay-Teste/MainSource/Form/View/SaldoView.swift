//
//  SaldoView.swift
//  iOS-PicPay-Teste
//
//  Created by Bruno Vieira on 26/05/19.
//  Copyright © 2019 Bruno iOS Dev. All rights reserved.
//

import UIKit

class SaldoView: UIView {

    lazy var qrcodeImage: UIButton = {
        let image = UIButton()
        image.layer.cornerRadius = 7
        image.layer.masksToBounds = true
        image.backgroundColor = .lightGreen
        return image
    }()
    
    var setImage: UIImage? {
        set { self.qrcodeImage.setImage(newValue, for: .normal) }
        get { return nil }
    }
    
    lazy var activityNewQrCode: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.color = .white
        view.hidesWhenStopped = true
        return view
    }()
    
    func startActivity() {
        DispatchQueue.main.async { [weak self] in
            self?.activityNewQrCode.startAnimating()
        }
    }
    
    func stopActivity() {
        DispatchQueue.main.async { [weak self] in
            self?.activityNewQrCode.stopAnimating()
        }
    }
    
    lazy var saldolabel: UIButton = {
        let label = UIButton()
        label.setTitleColor(.lightGreen, for: .normal)
        label.titleLabel?.font = UIFont.boldSystemFont(ofSize: 46)
        label.setTitle("- -", for: .normal)
        return label
    }()
    
    var textSaldo: String? {
        get { return self.saldolabel.titleLabel?.text }
        set { self.saldolabel.setTitle(newValue, for: .normal) }
    }
    
    lazy var pagarButton: UIButton = {
        let button = UIButton()
        button.setTitle("Pagar", for: .normal)
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        button.backgroundColor = .lightGreen
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    fileprivate func configure() {
        self.addSubview(self.qrcodeImage)
        self.addSubview(self.saldolabel)
        self.addSubview(self.pagarButton)
        self.addSubview(self.activityNewQrCode)
        
        self.activityNewQrCode.anchorXY(centerX: self.qrcodeImage.centerXAnchor, centerY: nil, top: self.qrcodeImage.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 5, left: 0, bottom: 0, right: 0))
        
        self.qrcodeImage.anchorXY(centerX: self.centerXAnchor, centerY: nil, top: nil, leading: nil, bottom: self.saldolabel.topAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0), size: CGSize(width: 150, height: 150))
        
        self.saldolabel.anchorXY(centerX: self.centerXAnchor, centerY: nil, top: self.centerYAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 20, right: 0), size: .init(width: 300, height: 100))
        
        self.pagarButton.anchorXY(centerX: self.centerXAnchor, centerY: nil, top: nil, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 30, bottom: 10, right: 30), size: CGSize(width: 0, height: 60))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

}
