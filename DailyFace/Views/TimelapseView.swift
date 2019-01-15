//
//  TimelapseView.swift
//  DailyFace
//
//  Created by Duncan MacDonald on 1/14/19.
//  Copyright © 2019 Duncan MacDonald. All rights reserved.
//

import Foundation
import UIKit
import AVKit

protocol TimelapseViewDelegate: class {
    func didShare(item videoUrl: URL)
    func didDelete(item contentURL: URL)
}

class TimelapseView: UIView {
    let borderWidth: CGFloat = 20
    
    let popupSize: CGRect = CGRect(x: 0, y: 0, width: 290, height: 410)
    
    var popupView: UIView!
    var backgroundView: UIView!
    var playerView: UIView!
    
    var contentURL: URL!
    
    weak var delegate: TimelapseViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        self.layoutBackground()
        self.layoutPopupView()
        self.layoutVideoPlayer()
        self.layoutButtons()
        
        self.popupView.center = self.center
    }
    
    func layoutPopupView() {
        popupView = UIView(frame: popupSize)
        popupView.backgroundColor = .white
        popupView.layer.cornerRadius = 6
        
        self.addSubview(popupView)
    }
    
    func layoutVideoPlayer() {
        playerView = UIView(frame: CGRect(x: borderWidth, y: borderWidth, width: self.popupView.bounds.width - (borderWidth * 2), height: self.popupView.bounds.height - (30 + borderWidth * 2)))
        
        let player = AVPlayer(url: contentURL)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = playerView.bounds
        playerView.layer.addSublayer(playerLayer)
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { [weak self] _ in
            player.seek(to: CMTime.zero)
            player.play()
        }
        
        self.popupView.addSubview(playerView)
        
        player.play()
    }
    
    func layoutButtons() {
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
        
        self.popupView.addSubview(cancelButton)
        self.popupView.addSubview(shareButton)
    }
    
    func layoutBackground() {
        backgroundView = UIView(frame: self.frame)
        backgroundView.backgroundColor = .gray
        backgroundView.alpha = 0.75
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(cancelButtonTapped(_:)))
        backgroundView.addGestureRecognizer(tap)
        
        self.addSubview(backgroundView)
    }
    
    @objc
    func cancelButtonTapped(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    @objc
    func shareButtonTapped(_ sender: UIButton) {
        delegate?.didShare(item: contentURL)
    }
    
    @objc
    func deleteButtonTapped(_ sender: UIButton) {
        self.removeFromSuperview()
        
        delegate?.didDelete(item: contentURL)
    }
    
    @objc
    func buttonSelected(_ sender: UIButton) {
        sender.alpha = 0.3
    }
    
    @objc
    func buttonDeselected(_ sender: UIButton) {
        sender.alpha = 1
    }
}
