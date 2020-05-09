//
//  CameraViewController.swift
//  Spreadly
//
//  Created by Michael Wlodawsky on 5/1/20.
//  Copyright © 2020 Spreadly. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession: AVCaptureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?

    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: .video, position: .back)
        
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("***Error: Failed to get the Camera Device")
            return
        }
        
        do {
            // Set capture input
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            
            // Set capture output and indicate we want QR Code data
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            // Set video feed
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = self.view.layer.frame
            self.view.layer.addSublayer(videoPreviewLayer!)
        } catch {
            print("\(error)")
            return
        }
        
        captureSession.startRunning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // No QR Code detected yet
        if metadataObjects.count == 0 {
            return
        }
        
        let metadataObject = metadataObjects.first as! AVMetadataMachineReadableCodeObject
        
        if metadataObject.type == AVMetadataObject.ObjectType.qr {
            if metadataObject.stringValue != nil {
                appDelegate.query = metadataObject.stringValue?.replacingOccurrences(of: "spreadly://?", with: "", options: [.caseInsensitive])
                performSegue(withIdentifier: "toMenu", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        captureSession.stopRunning()
    }

}
