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
        
        dateString = "\(month)-\(day)-\(year):\(hour):\(minute):\(second)"
        let labelString = dateString!.split(separator: ":")[0].description
        
        dateButton.setTitle(labelString, for: .normal)
    }
    
    func fadeFace() {
        UIView.animate(withDuration: 0.75) {
            self.face.alpha = 0.3
        }
    }
    
    // ACTIONS
    
    @IBAction func photoButtonTapped(_ sender: UIButton) {
        let settings = AVCapturePhotoSettings()
        
        photoOutput?.capturePhoto(with: settings, delegate: self)
    }
    
    @IBAction func unwindToCamera(segue: UIStoryboardSegue) {}
    
    // OVERRIDES
    
    override func viewDidLoad() {
        setupDateLabel()
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
            destination.capturedImage = image
            destination.capturedDate = dateString
        }
    }
}

extension ViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            image = UIImage(data: imageData)
        }
        
        self.performSegue(withIdentifier: "showPhoto", sender: self)
    }
}
