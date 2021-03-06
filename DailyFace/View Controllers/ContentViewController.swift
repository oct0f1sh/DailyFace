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
import AVKit
import JGProgressHUD

class ContentViewController: UIViewController {
    
    // MARK: MARK: IBOUTLETS
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var timelapseButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var pagerView: ContentPagerView! {
        didSet {
            self.pagerView.register(ContentViewCell.self, forCellWithReuseIdentifier: "pagerCell")
        }
    }
    
    // MARK: VARIABLES
    
    var urls: [URL] = FileService.getImages()
    
    var hud: JGProgressHUD!
    
    var firstDate: String {
        if urls.count > 0 {
            let dateString = urls.first!.path.split(separator: "/").last!.description.split(separator: ":")[0].description
            return DateHelper.formatDate(date: dateString)
        } else {
            return "no photos"
        }
    }
    
    var lastDate: String {
        if urls.count > 0 {
            let dateString = urls.last!.path.split(separator: "/").last!.description.split(separator: ":")[0].description
            return DateHelper.formatDate(date: dateString)
        } else {
            return "no photos"
        }
    }
    
    // MARK: FUNCTIONS
    
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
            dateLabel.text = "\(firstDate) - \(lastDate)"
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
    
    func animateDelete(cell: ContentViewCell) {
        UIView.animate(withDuration: 4) {
            cell.alpha = 0
        }
        
        self.pagerView.scrollToItem(at: self.urls.count - 1, animated: true)
        
        urls = FileService.getImages()
        
        pagerView.reloadData()
    }
    
    func setupProgressIndicator() {
        DispatchQueue.main.async {
            self.hud = JGProgressHUD(style: .dark)
            self.hud.indicatorView = JGProgressHUDPieIndicatorView()
            self.hud.textLabel.text = "Generating timelapse"
            self.hud.progress = 0
            self.hud.show(in: self.view)
            
            self.timelapseButton.isUserInteractionEnabled = false
        }
    }
    
    func updateProgressIndicator(progress: Double) {
        DispatchQueue.main.async {
            self.hud.progress = Float(progress)
        }
    }
    
    func endProgressIndicator() {
        DispatchQueue.main.async {
            self.hud.progress = 1
            self.hud.dismiss()
        }
    }
    
    func presentTimelapseView(url: URL) {
        let timelapseView = TimelapseView(frame: self.view.frame)
        timelapseView.contentURL = url
        timelapseView.delegate = self
        
        self.view.addSubview(timelapseView)
    }
    
    func reloadPagerView() {
        urls = FileService.getImages()
        
        pagerView.reloadData()
    }
    
    // MARK: IBACTIONS
    
    @IBAction func buttonSelected(_ sender: UIButton) {
        sender.alpha = 0.3
    }
    
    @IBAction func buttonDeselected(_ sender: UIButton) {
        sender.alpha = 1
    }
    
    @IBAction func retakeButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func videoButtonTapped(_ sender: Any) {
        VideoService.generateVideo(from: urls, completion: { (url, err) in
            guard err == nil else { return }

            if let url = url {
                DispatchQueue.main.async {
                    self.presentTimelapseView(url: url)

                    self.timelapseButton.isUserInteractionEnabled = true
                }
            }

        }) { (prog) in
            // Update activity indicator
            if prog.completedUnitCount == 1 {
                // show activity indicator
                self.setupProgressIndicator()
            } else if prog.completedUnitCount > 1 && prog.completedUnitCount < prog.totalUnitCount {
                // update activity indicator
                self.updateProgressIndicator(progress: prog.fractionCompleted)
            } else {
                // update activity indicator and remove it
                self.endProgressIndicator()
            }
            print("\(prog.completedUnitCount) of \(prog.totalUnitCount)")
        }
    }
    
    // MARK: OVERRIDES
    
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

// MARK: PAGER VIEW

extension ContentViewController: FSPagerViewDataSource, FSPagerViewDelegate {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return urls.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "pagerCell", at: index)
        
        let url = urls[index]
        
        cell.imageView!.image = UIImage(contentsOfFile: url.path)
        
        cell.textLabel?.text = url.path.split(separator: "/").last?.description.split(separator: ":").first?.description
        
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, shouldSelectItemAt index: Int) -> Bool {
        return true
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        let imgURL = urls[index]
        
        let photoView = PhotoView(frame: self.view.frame)
        photoView.contentURL = imgURL
        photoView.delegate = self
        
        self.view.addSubview(photoView)
        
        pagerView.deselectItem(at: index, animated: true)
    }
}

extension ContentViewController: ContentPagerViewEditDelegate {
    func collection(_ collectionPagerView: ContentPagerView, didSwipeUpToDelete cell: ContentViewCell) {
        
        let index = collectionPagerView.index(for: cell)
        let url = urls[index]
        
        animateDelete(cell: cell)
        
        FileService.deleteImage(url: url) { }
    }
}

// MARK: TIMELAPSE VIEW

extension ContentViewController: TimelapseViewDelegate {
    func didShare(item videoUrl: URL) {
        let activityItems: [Any] = [videoUrl, "Check out this timelapse I made with DailyFace!"]
        let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        activityController.popoverPresentationController?.sourceView = view
        activityController.popoverPresentationController?.sourceRect = view.frame
        
        self.present(activityController, animated: true, completion: nil)
    }
    
    func didDelete(item contentURL: URL) {
        FileService.deleteImage(url: contentURL) {
            self.reloadPagerView()
        }
    }
}
