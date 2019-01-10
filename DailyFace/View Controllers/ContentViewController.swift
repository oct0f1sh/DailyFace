//
//  ContentViewController.swift
//  DailyFace
//
//  Created by Duncan MacDonald on 1/8/19.
//  Copyright © 2019 Duncan MacDonald. All rights reserved.
//

import Foundation
import UIKit
import FSPagerView
import Nuke
//import AVFoundation
import Player

class ContentViewController: UIViewController {
    
    // IBOUTLETS
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "pagerCell")
        }
    }
    
    // VARIABLES
    
    var capturedImage: UIImage!
    var capturedDate: String!
    
    var urls: [URL] = FileService.getImages()
    
    let player = Player()
    
    var firstDate: String {
        return urls.first!.path.split(separator: "/").last!.description.split(separator: ":")[0].description
    }
    
    var lastDate: String {
        return urls.last!.path.split(separator: "/").last!.description.split(separator: ":")[0].description
    }
    
    // FUNCTIONS
    
    func setupPagerView() {
        pagerView.transformer = FSPagerViewTransformer(type: .overlap)
        pagerView.itemSize = CGSize(width: 270, height: 375)
    }
    
    func setupDateLabel() {
        if firstDate == lastDate {
            dateLabel.text = firstDate
        } else {
            dateLabel.text = "\(firstDate) to \(lastDate)"
        }
    }
    
    func playVideo(url: URL) {
//        let player = AVPlayer(url: url)
//        let playerLayer = AVPlayerLayer(player: player)
//        playerLayer.frame = self.view.bounds
//
//        self.view.layer.addSublayer(playerLayer)
//        player.play()
        self.player.playerDelegate = self
        self.player.playbackDelegate = self
        self.player.view.frame = self.view.bounds
        
        self.addChild(self.player)
        self.view.addSubview(self.player.view)
        self.player.didMove(toParent: self)
        
        self.player.url = url //URL(string: "https://v.cdn.vine.co/r/videos/AA3C120C521177175800441692160_38f2cbd1ffb.1.5.13763579289575020226.mp4")
        
        self.player.playFromBeginning()
    }
    
    // IBACTIONS
    
    @IBAction func retakeButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func videoButtonTapped(_ sender: Any) {
        VideoService.generateVideo(from: urls) { (vidUrl, err) in
            guard err == nil else { return }
            
            if let url = vidUrl {
                DispatchQueue.main.async {
                    self.playVideo(url: url)
                }
            }
        }
    }
    
    // OVERRIDES
    
    override func viewDidLoad() {
        imageView.image = capturedImage
        
        FileService.saveImage(capturedImage, filename: capturedDate)
        
        setupPagerView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        urls = FileService.getImages()
        
        pagerView.reloadData()
        
        setupDateLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        pagerView.scrollToItem(at: urls.count - 1, animated: true)
    }
}

// PAGER VIEW

extension ContentViewController: FSPagerViewDataSource, FSPagerViewDelegate {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return urls.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "pagerCell", at: index)
        
        Nuke.loadImage(with: urls[index], into: cell.imageView!)
        
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, shouldSelectItemAt index: Int) -> Bool {
        return false
    }
}

extension ContentViewController: PlayerDelegate {
    func playerReady(_ player: Player) {
        print("player ready")
    }
    
    func playerPlaybackStateDidChange(_ player: Player) {
        return
    }
    
    func playerBufferingStateDidChange(_ player: Player) {
        return
    }
    
    func playerBufferTimeDidChange(_ bufferTime: Double) {
        return
    }
    
    func player(_ player: Player, didFailWithError error: Error?) {
        print("error with player: \(error?.localizedDescription)")
    }
}

// VIDEO PLAYER

extension ContentViewController: PlayerPlaybackDelegate {
    func playerCurrentTimeDidChange(_ player: Player) {
        return
    }
    
    func playerPlaybackWillStartFromBeginning(_ player: Player) {
        print("starting from beginning")
    }
    
    func playerPlaybackDidEnd(_ player: Player) {
        print("playback ended")
    }
    
    func playerPlaybackWillLoop(_ player: Player) {
        print("looping playback")
    }
}
