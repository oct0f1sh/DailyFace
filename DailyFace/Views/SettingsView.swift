//
//  SettingsView.swift
//  DailyFace
//
//  Created by Duncan MacDonald on 1/28/19.
//  Copyright © 2019 Duncan MacDonald. All rights reserved.
//

import Foundation
import UIKit

class SettingsView: UIView {
    let borderWidth: CGFloat = 20
    
    let popupSize: CGRect = CGRect(x: 0, y: 0, width: 290, height: 410)
    
    var popupView: UIView!
    var backgroundView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func layoutPopupView() {
        popupView = UIView(frame: popupSize)
        popupView.backgroundColor = .white
        popupView.layer.cornerRadius = 6
        
        self.addSubview(popupView)
    }
    
    func layoutBackground() {
        backgroundView = UIView(frame: self.frame)
        backgroundView.backgroundColor = .gray
        backgroundView.alpha = 0.75
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(cancelButtonTapped(_:)))
//        backgroundView.addGestureRecognizer(tap)
        
        self.addSubview(backgroundView)
    }
}
