//
//  KYTaBbar.swift
//  KYTabBarController
//
//  Created by SIU Suet Long on 9/8/2020.
//  Copyright © 2020 KY-iOS. All rights reserved.
//

import UIKit

internal protocol YKTabBarDelegate: NSObjectProtocol {

    func tabBar(_ tabBar: UITabBar, shouldSelect item: UITabBarItem) -> Bool
    func tabBar(_ tabBar: UITabBar, shouldHijack item: UITabBarItem) -> Bool
    func tabBar(_ tabBar: UITabBar, didHijack item: UITabBarItem)
}

open class KYTabBar: UITabBar {
    
    //MARK: - Property
    internal weak var customDelegate: YKTabBarDelegate?
     
    internal var containers = [KYTabBarItemContainer]()
    
    open override var items: [UITabBarItem]? {
        didSet {
            self.reloadView()
        }
    }
    
    //MARK: - Appearance
    
    open var tabBarItemHeight: CGFloat = 48.0
    open override var tintColor: UIColor! {
        didSet {
            for item in self.items! {
                if let kyItem = item as? KYTabBarItem {
                    if kyItem.selectedTintColor == nil {
                        kyItem.selectedTintColor = tintColor
                    }
                }
            }
        }
    }
    
    open override var unselectedItemTintColor: UIColor! {
        didSet {
            for item in self.items! {
                if let kyItem = item as? KYTabBarItem {
                    kyItem.unselectedTintColor = unselectedItemTintColor
                }
            }
        }
    }
    
    ///Corner Radius of bar items
    ///(tabBarItemHeight/2) by default
    var cornerRadius: CGFloat! = CGFloat.greatestFiniteMagnitude {
        didSet {
            for item in self.items! {
                if let kyItem = item as? KYTabBarItem {
                    kyItem.contentView?.cornerRadius = cornerRadius
                }
            }
        }
    }
    
    open override var backgroundColor: UIColor? {
        didSet {
            self.barTintColor = backgroundColor
        }
    }
    
    //MARK: - Methods
    
    /*
     Change TabBar Height
     */
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        if tabBarItemHeight > 0.0 {
            sizeThatFits.height = tabBarItemHeight
        }
        return sizeThatFits
    }
    
    open override func setItems(_ items: [UITabBarItem]?, animated: Bool) {
        super.setItems(items, animated: animated)
        self.reloadView()
        
        if self.selectedItem == nil, self.items!.count > 0 {
            self.select(itemAt: 0, animated: true)
        }
    }
    
    var view: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private var containerBottomSpace: NSLayoutConstraint!
    
    override open func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        self.containerBottomSpace.constant = -self.safeAreaInsets.bottom
    }
    
    private var minButtonWidth: CGFloat = 0
    
    var basementStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.isUserInteractionEnabled = true
        stackView.spacing = 12.0
        
        return stackView
    }()
    
    func removeAllContainers() {
        //Remove all native tabBarButton
        self.subviews.filter { String(describing: type(of: $0)) == "UITabBarButton" }.forEach { $0.removeFromSuperview() }
        
        for container in self.containers {
            container.removeFromSuperview()
        }
        self.containers.removeAll()
    }
    
    private func initialView() {
        self.isTranslucent = false
        
        self.tintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        self.unselectedItemTintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        //For dark mode
        if #available(iOS 13, *) {
            self.barTintColor = .systemBackground
        } else {
            self.barTintColor = .white
        }
        
        self.addSubview(self.view)
        
        self.view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        self.view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        self.view.topAnchor.constraint(equalTo: self.topAnchor, constant: 1).isActive = true
        
        let bottomOffset: CGFloat = self.safeAreaInsets.bottom
        self.containerBottomSpace = self.view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -bottomOffset)
        self.containerBottomSpace.isActive = true
        
        self.view.addSubview(self.basementStackView)
        
        self.basementStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.basementStackView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.basementStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.basementStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    private func reloadView() {
        if self.containerBottomSpace == nil {
            self.initialView()
        }
        
        self.removeAllContainers()
        guard let items = self.items else {
            fatalError("Initial view failed cause no items!")
        }
        
        for (idx, item) in items.enumerated() {
            let container = KYTabBarItemContainer(self, tag: 1000 + idx)
            self.containers.append(container)
            
            if let item = item as? KYTabBarItem, let contentView = item.contentView {
                container.addSubview(contentView)
                
                contentView.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
                contentView.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
                contentView.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
            }
            
            self.basementStackView.addArrangedSubview(container)
        }
        
        self.layoutIfNeeded()
    }
    
    func reload(_ animated:Bool) {
        guard let itemsCount = self.items?.count else {
            fatalError("Reload view failed cause no items!")
        }
        
        self.minButtonWidth = CGFloat(self.view.bounds.width) / CGFloat(itemsCount)
        
        for item in self.items as! [KYTabBarItem] {
            if let contentView = item.contentView {
                contentView.deactiveWidthConstraint()
            }
        }
                
        var fitWidth: CGFloat = self.minButtonWidth
        for item in self.items as! [KYTabBarItem] {
            if let contentView = item.contentView, contentView.selected {
                fitWidth = max(contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).width, self.minButtonWidth)
                break
            }
        }
        
        let reminingAverageWidth = ((self.view.bounds.width - (self.basementStackView.spacing * CGFloat(itemsCount-1)) - fitWidth)/CGFloat(itemsCount-1))
        print("container width =", self.view.bounds.width)
        print("fitWidth =", fitWidth, "reminingAverageWidth =", reminingAverageWidth)
        
        for item in self.items as! [KYTabBarItem] {
            if let contentView = item.contentView {
                contentView.updateWidthConstraint(contentView.selected ? fitWidth : reminingAverageWidth)
            }
        }
        
        UIView.animate(withDuration: 0.2) {
            self.basementStackView.layoutIfNeeded()
        }
    }
    
    //MARK: - Actions
    
    @objc func selectAction(_ sender: AnyObject?) {
        guard let container = sender as? KYTabBarItemContainer else {
            return
        }
        select(itemAt: container.tag - 1000, animated: true)
    }
    
    func select(itemAt index: Int, animated: Bool = false) {
        guard index < self.items!.count else {
            print("out of bounds!")
            return
        }
        
        guard let item = self.items?[index] else {
            return
        }
        
        for (idx, item) in self.items!.enumerated() {
            if let kyItem = item as? KYTabBarItem {
                kyItem.setSelected(selected: (idx == index), animated: animated)
            }
        }
        self.reload(false)
        
        self.delegate?.tabBar?(self, didSelect: item)
    }
    
    
}
