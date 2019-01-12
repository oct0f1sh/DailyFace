//
//  PagerViewCollectionViewCell.swift
//  DailyFace
//
//  Created by Duncan MacDonald on 1/11/19.
//  Copyright © 2019 Duncan MacDonald. All rights reserved.
//

import UIKit
import FSPagerView

protocol ContentViewCellDelegate: class {
    func pageViewDidSwipeToDelete(_ cell: ContentViewCell)
}

class ContentViewCell: FSPagerViewCell {
    
    weak var delegate: ContentViewCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGesutre(_:)))
        contentView.addGestureRecognizer(gestureRecognizer)
    }
    
    private var offset: CGFloat?
    
    @objc private func panGesutre(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            offset = gesture.location(in: superview).y - contentView.frame.origin.y
            
        case .changed:
            // pan the contentView by the yPoint
            let yPoint = gesture.location(in: superview).y - offset!
            contentView.frame.origin.y = yPoint
            
        case .ended:
            // check if the yPoint is at a delete posistion
            if contentView.frame.origin.y < -200 {
                delegate?.pageViewDidSwipeToDelete(self)
            } else {
                // animate cell back to origin
                UIView.animate(withDuration: 0.25) {
                    self.contentView.frame.origin.y = self.contentView.bounds.origin.y
                }
            }
            
        default:
            break
        }
    }
}
