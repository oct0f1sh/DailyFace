//
//  ContentViewController.swift
//  DailyFace
//
//  Created by Duncan MacDonald on 1/8/19.
//  Copyright © 2019 Duncan MacDonald. All rights reserved.
//

import Foundation
import UIKit

class ContentViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    var capturedImage: UIImage!
    var capturedDate: String!
    
    @IBAction func retakeButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        imageView.image = capturedImage
        
        FileService.saveImage(capturedImage, filename: capturedDate)
    }
}
