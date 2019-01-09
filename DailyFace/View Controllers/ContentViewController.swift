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
    
    var firstDate: String {
//        return urls[0].path.split(separator: "/").description.split(separator: ":")[0].description
        return urls.first!.path.split(separator: "/").last!.description.split(separator: ":")[0].description
//        return urls.first!.path.split(separator: "/").description.split(separator: ":")[0].description
    }
    
    var lastDate: String {
//        return urls.last!.path.split(separator: "/").description.split(separator: ":")[0].description
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
    
    // IBACTIONS
    
    @IBAction func retakeButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
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
