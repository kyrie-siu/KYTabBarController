//
//  KYTabBarItemContainer.swift
//  KYTabBarController
//
//  Created by SIU Suet Long on 11/8/2020.
//  Copyright © 2020 KY-iOS. All rights reserved.
//

import UIKit

internal class KYTabBarItemContainer: UIControl {
    
    internal init(_ target: AnyObject?, tag: Int) {
        super.init(frame: CGRect.zero)
        self.tag = tag
        
        self.addTarget(target, action: #selector(KYTabBar.selectAction(_:)), for: .touchUpInside)
        self.addTarget(target, action: #selector(KYTabBar.highlightAction(_:)), for: .touchDown)
        self.addTarget(target, action: #selector(KYTabBar.highlightAction(_:)), for: .touchDragEnter)
        self.addTarget(target, action: #selector(KYTabBar.dehighlightAction(_:)), for: .touchDragExit)

        self.backgroundColor = .clear
        self.isAccessibilityElement = true
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var b = super.point(inside: point, with: event)
        if !b {
            for subview in self.subviews {
                if subview.point(inside: CGPoint.init(x: point.x - subview.frame.origin.x, y: point.y - subview.frame.origin.y), with: event) {
                    b = true
                }
            }
        }
        return b
    }

}
