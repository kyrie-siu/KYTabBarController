//
//  MainTabBarController.swift
//  ExampleApp
//
//  Created by SIU Suet Long on 12/8/2020.
//  Copyright © 2020 KY-iOS. All rights reserved.
//

import UIKit
import KYTabBarController

class MainTabBarController: KYTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            self.setTabBarBackgroundColor(.systemBackground)
        } else {
            // Fallback on earlier versions
        }

        // Do any additional setup after loading the view.
        let routeVC = SampleViewController()
        //        let evemtstabBarItem = KYTabBarItem.init(KYTabBarItemImageContentView(image: #imageLiteral(resourceName: "menu"), selectedImage: #imageLiteral(resourceName: "menu")), title: "Events", tag: 0)
        let routeTabBarItem = KYTabBarItem.init(KYTabBarItemLottieContentView(animationName: "tab_route_light", placeholderImage:#imageLiteral(resourceName: "menu")), title: "Route", tag: 0)
        routeTabBarItem.selectedTintColor = #colorLiteral(red: 0.9843137255, green: 0.7254901961, blue: 0.1803921569, alpha: 1)
        routeVC.tabBarItem = routeTabBarItem
        
        let ycVC = SampleViewController()
        //        let evemtstabBarItem = KYTabBarItem.init(KYTabBarItemImageContentView(image: #imageLiteral(resourceName: "menu"), selectedImage: #imageLiteral(resourceName: "menu")), title: "Events", tag: 0)
        let ycTabBarItem = KYTabBarItem.init(KYTabBarItemLottieContentView(animationName: "tab_yc_light", placeholderImage:#imageLiteral(resourceName: "menu")), title: "YC", tag: 0)
        ycTabBarItem.selectedTintColor = #colorLiteral(red: 0.9843137255, green: 0.7254901961, blue: 0.1803921569, alpha: 1)
        ycVC.tabBarItem = ycTabBarItem
        
        let settingsVC = SampleViewController()
        //        let evemtstabBarItem = KYTabBarItem.init(KYTabBarItemImageContentView(image: #imageLiteral(resourceName: "menu"), selectedImage: #imageLiteral(resourceName: "menu")), title: "Events", tag: 0)
        let settingsTabBarItem = KYTabBarItem.init(KYTabBarItemLottieContentView(animationName: "tab_settings_light", placeholderImage:#imageLiteral(resourceName: "menu")), title: "Settings", tag: 0)
        settingsTabBarItem.selectedTintColor = #colorLiteral(red: 0.9843137255, green: 0.7254901961, blue: 0.1803921569, alpha: 1)
        settingsVC.tabBarItem = settingsTabBarItem
        
        self.viewControllers = [routeVC, ycVC, settingsVC]
        self.setItemCornerRadius(10.0)
        self.setUnselectedItemTintColor(.gray)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
