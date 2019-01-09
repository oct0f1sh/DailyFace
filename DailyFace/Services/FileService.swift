//
//  FileService.swift
//  DailyFace
//
//  Created by Duncan MacDonald on 1/8/19.
//  Copyright © 2019 Duncan MacDonald. All rights reserved.
//

import Foundation
import UIKit

class FileService {
    static let dir: URL = {
        return try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    }()
    
    static func saveImage(_ image: UIImage, filename: String) {
        let imagePath = FileService.dir.appendingPathComponent("\(filename).png")
        
        guard let imageData = image.jpegData(compressionQuality: 1) else {
            // handle failed conversion
            print("jpg error")
            return
        }
        
        do {
            // save image to document directory
            try imageData.write(to: imagePath)
            print("saved at: \(imagePath)")
        } catch {
            print(error)
        }
    }
    
    static func getImages() -> [URL] {
        return try! FileManager.default.contentsOfDirectory(at: FileService.dir, includingPropertiesForKeys: nil, options: .skipsHiddenFiles).sorted(by: {$0.path < $1.path})
    }
}
