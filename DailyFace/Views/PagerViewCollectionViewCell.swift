//
//  PagerViewCollectionViewCell.swift
//  DailyFace
//
//  Created by Duncan MacDonald on 1/11/19.
//  Copyright © 2019 Duncan MacDonald. All rights reserved.
//

import UIKit
import FSPagerView

protocol PagerViewCollectionViewCellDelegate: class {
    func pageViewDidSwipeToDelete(_ cell: PagerViewCollectionViewCell)
}

class PagerViewCollectionViewCell: FSPagerViewCell {
    
    weak var delegate: PagerViewCollectionViewCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        
        // setup pan gesture recongnizer to the view (contentView)
//        contentView.addGesture(...)
        
    }
    
    private var offset: CGFloat?
    
    @objc private func panGesutre(_ guesture: UIPanGestureRecognizer) {
        switch guesture.state {
        case .began:
            //set the offset
            break
        case .changed:
            // find where the gesture is using
//            let yPoint = guesture.location(in: <#T##UIView?#>).y
            
            // pan the contentView by the yPoint
//            contentView.frame.origin.y = yPoint
            break
        case .ended:
            // check if the yPoint is at a delete posistion
            
            //if yes, send the delegate method
//            delegate.pageViewDidSwipeToDelete(self)
            
            //if no, position the contentView back in the original location
            break
        default:
            break
        }
    }
}
