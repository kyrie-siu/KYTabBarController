//
//  KYTabBarController.swift
//  KYTabBarController
//
//  Created by SIU Suet Long on 9/8/2020.
//  Copyright © 2020 KY-iOS. All rights reserved.
//

import UIKit

open class KYTabBarController: UITabBarController {

    fileprivate var shouldSelectItem = true

    open override var selectedViewController: UIViewController? {
        willSet {
            guard self.shouldSelectItem,
                let newValue = newValue else {
                self.shouldSelectItem = true
                return
            }
            guard let tabBar = self.tabBar as? KYTabBar, let index = viewControllers?.firstIndex(of: newValue) else {
                return
            }
            tabBar.select(itemAt: index, animated: true)
        }
    }

    open override var selectedIndex: Int {
        willSet {
            guard self.shouldSelectItem else {
                self.shouldSelectItem = true
                return
            }
            guard let tabBar = self.tabBar as? KYTabBar else {
                return
            }
            tabBar.select(itemAt: selectedIndex, animated: true)
        }
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBar = { () -> KYTabBar in
            let tabBar = KYTabBar()
            tabBar.delegate = self
            tabBar.customDelegate = self
            return tabBar
        }()
        self.setValue(tabBar, forKey: "tabBar")
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.deviceOrientationDidChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    deinit {
       NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    var tabBarHeight: CGFloat = 72
    public func setTabBarHeight(_ height: CGFloat) {
        self.tabBarHeight = height
        self.updateTabBarSize()
    }

    private func updateTabBarSize() {
        if let tabBar = self.tabBar as? KYTabBar {
            var size = tabBar.bounds.size
            size.height = self.tabBarHeight + self.view.safeAreaInsets.bottom
            tabBar.tabBarItemHeight = size.height
        }
    }
    
    public func setTabBarBackgroundColor(_ color: UIColor) {
        if let tabBar = self.tabBar as? KYTabBar {
            tabBar.backgroundColor = color
        }
    }
    
    public func setItemCornerRadius(_ radius: CGFloat) {
        if let tabBar = self.tabBar as? KYTabBar {
            tabBar.cornerRadius = radius
        }
    }
    
    public func setUnselectedItemTintColor(_ color: UIColor) {
        if let tabBar = self.tabBar as? KYTabBar {
            tabBar.unselectedItemTintColor = color
        }
    }

    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.updateTabBarSize()
    }

    open override func viewSafeAreaInsetsDidChange() {
        if #available(iOS 11.0, *) {
            super.viewSafeAreaInsetsDidChange()
        }
        self.updateTabBarSize()
    }
    
    @objc func deviceOrientationDidChanged() {
        guard let tabBar = tabBar as? KYTabBar else {
            return
        }
        tabBar.reload(true)
    }

    open override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let idx = tabBar.items?.firstIndex(of: item) else {
            return
        }
        if let controller = self.viewControllers?[idx] {
            self.shouldSelectItem = false
            self.selectedIndex = idx
            self.delegate?.tabBarController?(self, didSelect: controller)
        }
    }
}

extension KYTabBarController: KYTabBarDelegate {
    internal func tabBar(_ tabBar: UITabBar, shouldSelect item: UITabBarItem) -> Bool {
        if let index = tabBar.items?.firstIndex(of: item), let vc = self.viewControllers?[index] {
            return self.delegate?.tabBarController?(self, shouldSelect: vc) ?? true
        }
        return true
    }
}
