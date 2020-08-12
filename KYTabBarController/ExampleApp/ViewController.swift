//
//  ViewController.swift
//  ExampleApp
//
//  Created by SIU Suet Long on 10/8/2020.
//  Copyright © 2020 KY-iOS. All rights reserved.
//

import UIKit
import KYTabBarController

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let eventsVC = SampleViewController()
//        let evemtstabBarItem = KYTabBarItem.init(KYTabBarItemImageContentView(image: #imageLiteral(resourceName: "menu"), selectedImage: #imageLiteral(resourceName: "menu")), title: "Events", tag: 0)
        let evemtstabBarItem = KYTabBarItem.init(KYTabBarItemLottieContentView(animationName: "menubarRoutePage", placeholderImage:#imageLiteral(resourceName: "menu")), title: "Events", tag: 0)
        evemtstabBarItem.selectedTintColor = #colorLiteral(red: 0.9843137255, green: 0.7254901961, blue: 0.1803921569, alpha: 1)
        eventsVC.tabBarItem = evemtstabBarItem
        let searchVC = SampleViewController()
        let searchtabBarItem = KYTabBarItem.init(KYTabBarItemImageContentView(image: #imageLiteral(resourceName: "clock"), selectedImage: #imageLiteral(resourceName: "clock")), title: "Search", tag: 0)
        searchtabBarItem.selectedTintColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        searchVC.tabBarItem = searchtabBarItem
        let activityVC = SampleViewController()
        let activityBarItem = KYTabBarItem.init(KYTabBarItemImageContentView(image: #imageLiteral(resourceName: "dashboard"), selectedImage: #imageLiteral(resourceName: "dashboard")), title: "Activity", tag: 0)
        activityBarItem.selectedTintColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        activityVC.tabBarItem = activityBarItem
        let settingsVC = SampleViewController()
        let settintstabBarItem = KYTabBarItem.init(KYTabBarItemImageContentView(image: #imageLiteral(resourceName: "folder"), selectedImage: #imageLiteral(resourceName: "clock")), title: "Settings", tag: 0)
        settintstabBarItem.selectedTintColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        settingsVC.tabBarItem = settintstabBarItem
        let tabBarController = KYTabBarController()
        tabBarController.viewControllers = [eventsVC, searchVC, activityVC]
        tabBarController.setItemCornerRadius(10.0)
        tabBarController.setUnselectedItemTintColor(.gray)
        self.present(tabBarController, animated: true, completion: nil)
    }


}

