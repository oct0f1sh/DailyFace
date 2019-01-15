//
//  PhotoView.swift
//  DailyFace
//
//  Created by Duncan MacDonald on 1/15/19.
//  Copyright © 2019 Duncan MacDonald. All rights reserved.
//

import Foundation
import UIKit

class PhotoView: TimelapseView {
    override func layoutVideoPlayer() {
        playerView = UIView(frame: CGRect(x: borderWidth, y: borderWidth, width: self.popupView.bounds.width - (borderWidth * 2), height: self.popupView.bounds.height - (30 + borderWidth * 2)))
        
        let imgView = UIImageView(frame: playerView.bounds)
        imgView.image = UIImage(contentsOfFile: contentURL.path)
        
        playerView.addSubview(imgView)
        
        self.popupView.addSubview(playerView)
    }
    
    override func layoutButtons() {
        let cancelButton = UIButton(frame: CGRect(x: borderWidth - 5, y: self.playerView.frame.maxY + borderWidth / 2, width: 30, height: 30))
        cancelButton.setImage(UIImage(imageLiteralResourceName: "exit"), for: .normal)
        cancelButton.setTitleColor(.black, for: .normal)
        cancelButton.addTarget(self, action: #selector(self.cancelButtonTapped(_:)), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(self.buttonSelected(_:)), for: .touchDown)
        cancelButton.addTarget(self, action: #selector(self.buttonDeselected(_:)), for: .touchUpInside)
        
        let shareButton = UIButton(frame: CGRect(x: self.popupView.frame.maxX - (30 + borderWidth), y: self.popupView.bounds.maxY - (30 + borderWidth / 2), width: 30, height: 30))
        shareButton.setImage(UIImage(named: "share"), for: .normal)
        shareButton.setTitleColor(.black, for: .normal)
        shareButton.addTarget(self, action: #selector(self.shareButtonTapped(_:)), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(self.buttonSelected(_:)), for: .touchDown)
        shareButton.addTarget(self, action: #selector(self.buttonDeselected(_:)), for: .touchUpInside)
        
        let deleteButton = UIButton(frame: CGRect(x: self.popupView.center.x - 15, y: self.playerView.frame.maxY + borderWidth / 2, width: 30, height: 30))
        deleteButton.setImage(UIImage(named: "trash"), for: .normal)
        deleteButton.setTitleColor(.black, for: .normal)
        deleteButton.addTarget(self, action: #selector(self.deleteButtonTapped(_:)), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(self.buttonSelected(_:)), for: .touchDown)
        deleteButton.addTarget(self, action: #selector(self.buttonDeselected(_:)), for: .touchUpInside)
        
        self.popupView.addSubview(cancelButton)
        self.popupView.addSubview(shareButton)
        self.popupView.addSubview(deleteButton)
    }
}
