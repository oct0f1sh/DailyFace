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
import AVKit

class ContentViewController: UIViewController {
    
    // IBOUTLETS
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pagerView: CollectionPagerView! {
        didSet {
            self.pagerView.register(PagerViewCollectionViewCell.self, forCellWithReuseIdentifier: "pagerCell")
        }
    }
    
    // VARIABLES
    
    var urls: [URL] = FileService.getImages()
    
    var firstDate: String {
        if urls.count > 0 {
            return urls.first!.path.split(separator: "/").last!.description.split(separator: ":")[0].description
        } else {
            return "no photos"
        }
    }
    
    var lastDate: String {
        if urls.count > 0 {
            return urls.last!.path.split(separator: "/").last!.description.split(separator: ":")[0].description
        } else {
            return "no photos"
        }
    }
    
    // FUNCTIONS
    
    func setupPagerView() {
        pagerView.transformer = FSPagerViewTransformer(type: .overlap)
        pagerView.itemSize = CGSize(width: 270, height: 375)
        pagerView.collectionView.clipsToBounds = false
        pagerView.editDelegate = self
    }
    
    func setupDateLabel() {
        if firstDate == lastDate {
            dateLabel.text = firstDate
        } else {
            dateLabel.text = "\(firstDate) to \(lastDate)"
        }
    }
    
    func playVideo(url: URL) {
        let player = AVPlayer(url: url)
        let playerVC = AVPlayerViewController()
        playerVC.player = player
        
        self.present(playerVC, animated: true) {
            player.play()
        }
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
        
        let url = urls[index]
        
        Nuke.loadImage(with: url, into: cell.imageView!)
        cell.textLabel?.text = url.path.split(separator: "/").last?.description.split(separator: ":").first?.description
        
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, shouldSelectItemAt index: Int) -> Bool {
        return false
    }
}

extension ContentViewController: CollectionPagerViewEditDelegate {
    func collection(_ collectionPagerView: CollectionPagerView, didSwipeUpToDelete cell: PagerViewCollectionViewCell) {
        
        let index = collectionPagerView.index(for: cell)
        
        //remove the data by the given index
    }
}
