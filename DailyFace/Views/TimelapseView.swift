//
//  TimelapseView.swift
//  DailyFace
//
//  Created by Duncan MacDonald on 1/14/19.
//  Copyright © 2019 Duncan MacDonald. All rights reserved.
//

import Foundation
import UIKit

class TimelapseView: UIView {
    let borderWidth: CGFloat = 10
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .blue
        
        self.layer.cornerRadius = 6
        
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        self.layoutVideoPlayer()
        self.layoutButtons()
    }
    
    func layoutVideoPlayer() {
        let player = UIView(frame: CGRect(x: borderWidth, y: borderWidth, width: self.bounds.width - (borderWidth * 2), height: self.bounds.height - (30 + borderWidth * 2)))
        player.backgroundColor = .red
        
        self.addSubview(player)
    }
    
    func layoutButtons() {
        let cancelButton = UIButton(frame: CGRect(x: borderWidth - 5, y: self.bounds.maxY - 35, width: 30, height: 30))
        cancelButton.setImage(UIImage(imageLiteralResourceName: "exit"), for: .normal)
        cancelButton.setTitleColor(.black, for: .normal)
        
        let shareButton = UIButton(frame: CGRect(x: self.bounds.maxX - 35, y: self.bounds.maxY - 35, width: 30, height: 30))
        shareButton.setImage(UIImage(named: "share"), for: .normal)
        shareButton.setTitleColor(.black, for: .normal)
        
        self.addSubview(cancelButton)
        self.addSubview(shareButton)
    }
}
