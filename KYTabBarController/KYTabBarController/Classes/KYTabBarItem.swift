//
//  KYTabBarItem.swift
//  KYTabBarController
//
//  Created by SIU Suet Long on 9/8/2020.
//  Copyright © 2020 KY-iOS. All rights reserved.
//

import UIKit

open class KYTabBarItem: UITabBarItem {
    
    open var contentView: KYTabBarItemContentView?
    
    // MARK: - UIBarItem properties
    
    /// default is nil
    open override var title: String? {
        didSet { self.contentView?.title = title }
    }
    
    /// default is 0
    open override var tag: Int {
        didSet { self.contentView?.tag = tag }
    }
    
    open var selected: Bool = false {
        didSet {
            selected ? self.contentView?.unfold() : self.contentView?.fold()
        }
    }
    
    @IBInspectable public var selectedTintColor: UIColor?{
        didSet {
            self.contentView?.selectedTintColor = selectedTintColor
        }
    }
    
    @IBInspectable public var unselectedTintColor: UIColor? {
        didSet {
            self.contentView?.unselectedTintColor = unselectedTintColor
        }
    }
    
    @IBInspectable public var selectedBackgroundColor: UIColor? {
        didSet {
            self.contentView?.selectedBackgroundColor = selectedBackgroundColor
        }
    }
    
    public init(_ contentView: KYTabBarItemContentView, title: String?, tag: Int) {
        super.init()
        self.contentView = contentView
        self.setProperties(title, tag)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setProperties(_ title: String?,_ tag: Int) {
        self.title = title
        self.tag = tag
    }
}

