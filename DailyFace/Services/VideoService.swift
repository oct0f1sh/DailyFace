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
        let builder = VideoGenerator(photos: urls.compactMap({ UIImage(contentsOfFile: $0.path ) }))
        
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
}
