//
//  VideoService.swift
//  DailyFace
//
//  Created by Duncan MacDonald on 1/9/19.
//  Copyright © 2019 Duncan MacDonald. All rights reserved.
//

import Foundation
import UIKit
import SwiftVideoGenerator
import Nuke

class VideoService {
    static func generateVideo(from urls: [URL], completion: @escaping (URL?, Error?) -> Void) {
        
//        VideoGenerator.current.fileName = "test"
//        VideoGenerator.current.videoDurationInSeconds = 10
//        VideoGenerator.current.shouldOptimiseImageForVideo = true
//        VideoGenerator.current.videoBackgroundColor = .purple
        
//        let images = urls.compactMap { UIImage(contentsOfFile: $0.path) }
        
//        VideoGenerator.current.generate(withImages: images, andAudios: [], andType: .multiple, { (prog) in
//            print(prog)
//        }, success: { (vidUrl) in
//            print("successfully generated video at: \(vidUrl)")
//            completion(vidUrl, nil)
//        }) { (err) in
//            print("error generating video: \(err)")
//            completion(nil, err)
//        }
        let builder = TimeLapseBuilder(photos: urls.compactMap({ UIImage(contentsOfFile: $0.path ) }))
        
        builder.build({ (prog) in
            print(prog)
        }, success: { (url) in
            print("saved video at: \(url)")
            completion(url, nil)
        }) { (err) in
            print("error generating video: \(err.localizedDescription)")
            completion(nil, err)
        }
    }
    
    static func experimentalGenerateVideo(from urls: [URL], completion: @escaping (URL?, Error?) -> Void) {
    }
}
