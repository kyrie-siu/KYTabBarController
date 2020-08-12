//
//  KYTabBarItemImageContentView.swift
//  KYTabBarController
//
//  Created by SIU Suet Long on 12/8/2020.
//  Copyright © 2020 KY-iOS. All rights reserved.
//

import UIKit

public class KYTabBarItemImageContentView: KYTabBarItemContentView {
    
    open var image: UIImage!
    
    open var selectedImage: UIImage!
    
    public init(image: UIImage!, selectedImage: UIImage!) {
        self.image = image
        self.selectedImage = image
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func configureSubviews() {
        super.configureSubviews()
        
        let imageView = UIImageView(image: self.image)
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.assetView.addSubview(imageView)
        
        imageView.leadingAnchor.constraint(equalTo: self.assetView.leadingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: self.assetView.topAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.assetView.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.assetView.bottomAnchor).isActive = true
                
        self.contentStackView.layoutIfNeeded()
    }
    
    public override func fold() {
        super.fold()
    }
    
    public override func unfold() {
        super.unfold()
    }
    
}
