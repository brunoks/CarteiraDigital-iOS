//
//  QRCodeViewController.swift
//  UCLCriptoCoin
//
//  Created by Bruno Vieira on 23/04/19.
//  Copyright © 2019 Bruno iOS Dev. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    lazy var qrCodeView = QrCodeView()
    var session = AVCaptureSession()
    var video: AVCaptureVideoPreviewLayer!
    weak var delegate: ProtocolQrCodeCatch?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        self.cameraConstruction()
    }
    
    fileprivate func configureView() {
        self.view.addSubview(self.qrCodeView)
        self.qrCodeView.fillSuperview()
        self.navigationController?.navigationBar.backgroundColor = .clear
        
        self.qrCodeView.closeAction = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    fileprivate func cameraConstruction() {
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            Alert(self).normalAlert(with: "Câmera indisponível. Vá em configurações e dê permissão para usar a câmera.")
            return
        }
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            session.addInput(input)
        } catch {
            print("error capture session")
        }
        
        let outPut = AVCaptureMetadataOutput()
        
        session.addOutput(outPut)
        outPut.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        outPut.metadataObjectTypes = [.qr]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        
        video.frame = self.view.frame
        self.qrCodeView.backgroundView.layer.addSublayer(video)
        session.startRunning()
    }
    
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if let metadata = metadataObjects.last {
            self.dismiss(animated: true) { [weak self] in
                self?.delegate?.didGetDataQrCodeProtocol(metadata.value(forKey: "stringValue") as! String)
            }
            self.session.stopRunning()
        }
    }
}
