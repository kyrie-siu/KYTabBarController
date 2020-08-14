//
//  KYTabBarItemLottieContentView.swift
//  ExampleApp
//
//  Created by SIU Suet Long on 12/8/2020.
//  Copyright © 2020 KY-iOS. All rights reserved.
//

import UIKit
import KYTabBarController
import Lottie

open class KYTabBarItemLottieContentView: KYTabBarItemContentView {
    
    open var animation: Animation?
    open var placeholderImage: UIImage!
    
    private var animationView: AnimationView?
    
    public init(animationName: String?, placeholderImage: UIImage!) {
        if let name = animationName {
            self.animation = Animation.named(name)
        }
        self.placeholderImage = placeholderImage
        super.init(frame: CGRect.zero)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func configureSubviews() {
        super.configureSubviews()
        
        self.animationView = AnimationView(animation: self.animation)

        if self.animation != nil, let animationView = self.animationView {
            animationView.translatesAutoresizingMaskIntoConstraints = false
            animationView.contentMode = .scaleAspectFill

            self.assetView.addSubview(animationView)
            
            animationView.leadingAnchor.constraint(equalTo: self.assetView.leadingAnchor).isActive = true
            animationView.topAnchor.constraint(equalTo: self.assetView.topAnchor).isActive = true
            animationView.trailingAnchor.constraint(equalTo: self.assetView.trailingAnchor).isActive = true
            animationView.bottomAnchor.constraint(equalTo: self.assetView.bottomAnchor).isActive = true
        }
                
        self.contentStackView.layoutIfNeeded()
    }
    
    open override func fold(animated: Bool) {
        super.fold(animated: animated)
        
        DispatchQueue.main.async {
            self.animationView?.stop()
        }
    }
    
    open override func unfold(animated: Bool) {
        super.unfold(animated: animated)
        
        DispatchQueue.main.async {
            self.animationView?.play()
        }
    }
}
