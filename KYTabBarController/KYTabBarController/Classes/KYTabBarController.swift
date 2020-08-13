//
//  KYTabBarController.swift
//  KYTabBarController
//
//  Created by SIU Suet Long on 9/8/2020.
//  Copyright © 2020 KY-iOS. All rights reserved.
//

import UIKit

open class KYTabBarController: UITabBarController {
    
    fileprivate var ignoreNextSelection = false

    /// Observer tabBarController's selectedViewController. change its selection when it will-set.
    open override var selectedViewController: UIViewController? {
        willSet {
            guard let newValue = newValue else {
                // if newValue == nil ...
                return
            }
            guard !self.ignoreNextSelection else {
                self.ignoreNextSelection = false
                return
            }
            guard let tabBar = self.tabBar as? KYTabBar, let items = tabBar.items, let index = viewControllers?.firstIndex(of: newValue) else {
                return
            }
            let value = (index > items.count - 1) ? items.count - 1 : index
            tabBar.select(itemAt: value, animated: false)
        }
    }
    
    /// Observer tabBarController's selectedIndex. change its selection when it will-set.
    open override var selectedIndex: Int {
        willSet {
            guard !self.ignoreNextSelection else {
                self.ignoreNextSelection = false
                return
            }
            guard let tabBar = self.tabBar as? KYTabBar, let items = tabBar.items else {
                return
            }
            let value = (newValue > items.count - 1) ? items.count - 1 : newValue
            tabBar.select(itemAt: value, animated: false)
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
        guard let index = tabBar.items?.firstIndex(of: item) else {
            return
        }
        
        if let viewController = viewControllers?[index] {
            self.ignoreNextSelection = true
            self.selectedIndex = index
            self.delegate?.tabBarController?(self, didSelect: viewController)
        }
    }
}

extension KYTabBarController: KYTabBarDelegate {
    internal func tabBar(_ tabBar: UITabBar, shouldSelect item: UITabBarItem) -> Bool {
        if let index = tabBar.items?.firstIndex(of: item), let viewController = self.viewControllers?[index] {
            let shouldSelect = self.delegate?.tabBarController?(self, shouldSelect: viewController) ?? true
            self.animateToTab(toIndex: index)
            return shouldSelect
        }
        return true
    }
    
    func animateToTab(toIndex: Int) {
        guard let tabViewControllers = self.viewControllers,
            let selectedVC = self.selectedViewController else { return }

        guard let fromView = selectedVC.view,
            let toView = tabViewControllers[toIndex].view,
            let fromIndex = tabViewControllers.firstIndex(of: selectedVC),
            fromIndex != toIndex else { return }

        // Add the toView to the tab bar view
        fromView.superview?.addSubview(toView)

        // Position toView off screen (to the left/right of fromView)
        let screenWidth = UIScreen.main.bounds.size.width
        let scrollRight = toIndex > fromIndex
        let offset = (scrollRight ? screenWidth : -screenWidth)
        toView.center = CGPoint(x: fromView.center.x + offset, y: toView.center.y)

        // Disable interaction during animation
        view.isUserInteractionEnabled = false
        
        toView.subviews.forEach {$0.alpha = 0.0}
        
        UIView.animate(withDuration: 0.25,
                       delay: 0.1,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       options: .curveEaseOut,
                       animations: {
                        // Slide the views by -offset
                        fromView.subviews.forEach {$0.alpha = 0.0}
                        fromView.center = CGPoint(x: fromView.center.x - offset, y: fromView.center.y)
                        toView.subviews.forEach {$0.alpha = 1.0}
                        toView.center = CGPoint(x: toView.center.x - offset, y: toView.center.y)

        }, completion: { _ in
            // Remove the old view from the tabbar view.
            fromView.removeFromSuperview()
            self.selectedIndex = toIndex
            self.view.isUserInteractionEnabled = true
        })
    }
}
