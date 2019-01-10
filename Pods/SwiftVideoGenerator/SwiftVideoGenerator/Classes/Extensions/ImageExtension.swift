//
//  ImageExtension.swift
//  VideoGeneration
//
//  Created by DevLabs BG on 25.10.17.
//  Copyright © 2017 Devlabs. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// Method to scale an image to the given size while keeping the aspect ratio
    ///
    /// - Parameter newSize: the new size for the image
    /// - Returns: the resized image
    func scaleImageToSize(newSize: CGSize) -> UIImage? {
        var newImage: UIImage?
        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        if let context = UIGraphicsGetCurrentContext(), let cgImage = self.cgImage {
            context.interpolationQuality = .high
            let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
            context.concatenate(flipVertical)
            context.draw(cgImage, in: newRect)
            if let img = context.makeImage() {
                newImage = UIImage(cgImage: img)
            }
            UIGraphicsEndImageContext()
        }
        return newImage
    }
    
    /// Method to get a size for the image appropriate for video (dividing by 16 without overlapping 1200)
    ///
    /// - Returns: a size fit for video
    func getSizeForVideo() -> CGSize {
        let scale = UIScreen.main.scale
        var imageWidth = 16 * ((size.width / scale) / 16).rounded(.awayFromZero)
        var imageHeight = 16 * ((size.height / scale) / 16).rounded(.awayFromZero)
        var ratio: CGFloat!
        
        if imageWidth > 1400 {
            ratio = 1400 / imageWidth
            imageWidth = 16 * (imageWidth / 16).rounded(.towardZero) * ratio
            imageHeight = 16 * (imageHeight / 16).rounded(.towardZero) * ratio
        }
        
        if imageWidth < 800 {
            ratio = 800 / imageWidth
            imageWidth = 16 * (imageWidth / 16).rounded(.awayFromZero) * ratio
            imageHeight = 16 * (imageHeight / 16).rounded(.awayFromZero) * ratio
        }
        
        if imageHeight > 1200 {
            ratio = 1200 / imageHeight
            imageWidth = 16 * (imageWidth / 16).rounded(.towardZero) * ratio
            imageHeight = 16 * (imageHeight / 16).rounded(.towardZero) * ratio
        }
        
        return CGSize(width: imageWidth, height: imageHeight)
    }
    
    
    /// Method to resize an image to an appropriate video size
    ///
    /// - Returns: the resized image
    func resizeImageToVideoSize() -> UIImage? {
        let scale = UIScreen.main.scale
        let videoImageSize = getSizeForVideo()
        let imageRect = CGRect(x: 0, y: 0, width: videoImageSize.width * scale, height: videoImageSize.height * scale)
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: imageRect.width, height: imageRect.height), false, scale)
        if let _ = UIGraphicsGetCurrentContext() {
            draw(in: imageRect, blendMode: .normal, alpha: 1)
            
            if let resultImage = UIGraphicsGetImageFromCurrentImageContext() {
                UIGraphicsEndImageContext()
                return resultImage
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, true, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
