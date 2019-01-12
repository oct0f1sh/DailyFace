//
//  CollectionPagerView.swift
//  DailyFace
//
//  Created by Duncan MacDonald on 1/11/19.
//  Copyright © 2019 Duncan MacDonald. All rights reserved.
//

import UIKit
import FSPagerView

protocol ContentPagerViewEditDelegate: class {
    // collection view did swipe to delete function
    func collection(_ collectionPagerView: ContentPagerView, didSwipeUpToDelete cell: ContentViewCell)
}

class ContentPagerView: FSPagerView {
    
    weak var editDelegate: ContentPagerViewEditDelegate?

    override func dequeueReusableCell(withReuseIdentifier identifier: String, at index: Int) -> FSPagerViewCell {
        let cellFromSuper = super.dequeueReusableCell(withReuseIdentifier: identifier, at: index)
        
        guard let cell = cellFromSuper as? ContentViewCell else {
            assertionFailure("failed to cast into PagerViewCollectionViewCell")
            
            return cellFromSuper
        }
        
        cell.delegate = self
        
        return cell
    }

}

extension ContentPagerView: ContentViewCellDelegate {
    func pageViewDidSwipeToDelete(_ cell: ContentViewCell) {
        editDelegate?.collection(self, didSwipeUpToDelete: cell)
    }
}
