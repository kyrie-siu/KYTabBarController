//
//  KYTabBarController.swift
//  KYTabBarController
//
//  Created by SIU Suet Long on 9/8/2020.
//  Copyright © 2020 KY-iOS. All rights reserved.
//

import UIKit

open class KYTabBarController: UITabBarController {

    fileprivate var shouldSelectOnTabBar = true

    open override var selectedViewController: UIViewController? {
        willSet {
            guard shouldSelectOnTabBar,
                  let newValue = newValue else {
                shouldSelectOnTabBar = true
                return
            }
            guard let tabBar = tabBar as? KYTabBar, let index = viewControllers?.firstIndex(of: newValue) else {
                return
            }
            tabBar.select(itemAt: index, animated: false)
        }
    }

    open override var selectedIndex: Int {
        willSet {
            guard shouldSelectOnTabBar else {
                shouldSelectOnTabBar = true
                return
            }
            guard let tabBar = tabBar as? KYTabBar else {
                return
            }
            tabBar.select(itemAt: selectedIndex, animated: false)
        }
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        let tabBar = KYTabBar()
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
            tabBar.tabBarHeight = size.height
        }
    }
    
    var itemCornerRadius: CGFloat?
    public func setItemCornerRadius(_ radius: CGFloat) {
        if let tabBar = self.tabBar as? KYTabBar {
            self.itemCornerRadius = radius
            tabBar.cornerRadius = radius
        }
    }
    
    var unselectedItemTintColor: UIColor = .black
    public func setUnselectedItemTintColor(_ color: UIColor) {
        if let tabBar = self.tabBar as? KYTabBar {
            self.unselectedItemTintColor = color
            tabBar.unselectedItemTintColor = color
        }
    }

    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateTabBarSize()
    }

    open override func viewSafeAreaInsetsDidChange() {
        if #available(iOS 11.0, *) {
            super.viewSafeAreaInsetsDidChange()
        }
        updateTabBarSize()
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
        if let controller = viewControllers?[idx] {
            shouldSelectOnTabBar = false
            selectedIndex = idx
            delegate?.tabBarController?(self, didSelect: controller)
        }
    }

}
