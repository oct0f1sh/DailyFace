//
//  CollectionPagerView.swift
//  DailyFace
//
//  Created by Duncan MacDonald on 1/11/19.
//  Copyright © 2019 Duncan MacDonald. All rights reserved.
//

import UIKit
import FSPagerView

protocol CollectionPagerViewEditDelegate: class {
    // collection view did swipe to delete function
    func collection(_ collectionPagerView: CollectionPagerView, didSwipeUpToDelete cell: PagerViewCollectionViewCell)
}

class CollectionPagerView: FSPagerView {
    
    weak var editDelegate: CollectionPagerViewEditDelegate?

    override func dequeueReusableCell(withReuseIdentifier identifier: String, at index: Int) -> FSPagerViewCell {
        let cellFromSuper = super.dequeueReusableCell(withReuseIdentifier: identifier, at: index)
        
        guard let cell = cellFromSuper as? PagerViewCollectionViewCell else {
            assertionFailure("failed to cast into PagerViewCollectionViewCell")
            
            return cellFromSuper
        }
        
        cell.delegate = self
        
        return cell
    }

}

extension CollectionPagerView: PagerViewCollectionViewCellDelegate {
    func pageViewDidSwipeToDelete(_ cell: PagerViewCollectionViewCell) {
        editDelegate?.collection(self, didSwipeUpToDelete: cell)
    }
}
