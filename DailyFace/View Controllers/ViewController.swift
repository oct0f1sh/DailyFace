//
//  ViewController.swift
//  DailyFace
//
//  Created by Duncan MacDonald on 1/8/19.
//  Copyright © 2019 Duncan MacDonald. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    // IBOUTLETS
    
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var face: UIStackView!
    @IBOutlet weak var captureButton: UIButton!
    
    // VARIABLES
    
    var captureSession = AVCaptureSession()
    var frontCamera: AVCaptureDevice?
    
    var photoOutput: AVCapturePhotoOutput?
    
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var image: UIImage?
    
    var dateString: String?
    
    // FUNCTIONS
    
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        
        let devices = deviceDiscoverySession.devices
        
        for device in devices {
            if device.position == AVCaptureDevice.Position.front {
                frontCamera = device
            }
        }
    }
    
    func setupInputOutput() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: frontCamera!)
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            
            captureSession.addOutput(photoOutput!)
        } catch {
            print(error)
        }
    }
    
    func setupPreviewLayer() {
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer!.frame = self.view.frame
        
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
    }
    
    func startRunningCaptureSession() {
        captureSession.startRunning()
    }
    
    func setupDateLabel() {
        let date = Date()
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let year = calendar.component(.year, from: date)
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        let second = calendar.component(.second, from: date)
        
        dateString = String(format: "%02d-%02d-%04d:%02d:%02d:%02d", month, day, year, hour, minute, second)
        
        var labelString = dateString!.split(separator: ":")[0].description
        labelString = DateHelper.formatDate(date: labelString)
        
        dateButton.setTitle(labelString, for: .normal)
    }
    
    func fadeFace() {
        UIView.animate(withDuration: 0.75) {
            self.face.alpha = 0.3
        }
    }
    
    func animateCaptureButton() {
        UIView.animate(withDuration: 0.15, animations: {
            self.captureButton.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            self.captureButton.backgroundColor = .white
//            self.captureButton.setTitle("✔️", for: .normal)
        }) { (_) in
            UIView.animate(withDuration: 0.15, animations: {
                self.captureButton.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.captureButton.backgroundColor = .clear
//                self.captureButton.setTitle("", for: .normal)
            })
        }
    }
    
    func setupCaptureButton() {
        captureButton.layer.cornerRadius = 30
        captureButton.layer.borderWidth = 4
        captureButton.layer.borderColor = UIColor.white.cgColor
        captureButton.layer.backgroundColor = UIColor.clear.cgColor
    }
    
    // IBACTIONS
    
    @IBAction func photoButtonTapped(_ sender: UIButton) {
        animateCaptureButton()
        
        let settings = AVCapturePhotoSettings()
        
        photoOutput?.capturePhoto(with: settings, delegate: self)
        
        // if a new photo is taken while still on this view, then get a new filename
        setupDateLabel()
    }
    
    @IBAction func unwindToCamera(segue: UIStoryboardSegue) {}
    
    // OVERRIDES
    
    override func viewDidLoad() {
        setupDateLabel()
        setupCaptureButton()
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
        fadeFace()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupDateLabel()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhoto" {
            let destination: ContentViewController = segue.destination as! ContentViewController
        }
    }
}

extension ViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            image = UIImage(data: imageData)?.resizeImageUsingVImage(size: CGSize(width: 900, height: 1200))
            
            FileService.saveImage(image!, filename: dateString!)
        }
        
//        self.performSegue(withIdentifier: "showPhoto", sender: self)
    }
}
