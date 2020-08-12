//
//  KYTabBarItemContentView.swift
//  KYTabBarController
//
//  Created by SIU Suet Long on 11/8/2020.
//  Copyright © 2020 KY-iOS. All rights reserved.
//

import UIKit

public class KYTabBarItemContentView: UIView {
    
    //MARK: - Property
    //MARK: Appearance
    open var tabHeight: CGFloat = 42.0
    
    open var animationDuration: TimeInterval = 0.3
    
    open var cornerRadius: CGFloat = CGFloat.greatestFiniteMagnitude
    open var insets = UIEdgeInsets.zero
    open var selected: Bool = false
    open var selectionEnabled: Bool = true
    
    open var unselectedTintColor: UIColor? {
        didSet {
            self.reloadView()
        }
    }
    
    open var selectedTintColor: UIColor? {
        didSet {
            self.reloadView()
        }
    }
    
    open var selectedBackgroundColor: UIColor? {
        didSet {
            self.reloadView()
        }
    }
    
    open var title: String? {
        didSet {
            self.titleLabel.text = title
            self.layoutIfNeeded()
        }
    }
    
    //MARK: Views
    open var contentStackView: UIStackView = {
        let contentStackView = UIStackView()
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.axis = .horizontal
        contentStackView.alignment = .center
        contentStackView.distribution = .fillProportionally
        contentStackView.isUserInteractionEnabled = true
        contentStackView.spacing = 10.0
        
        return contentStackView
    }()
    
    open var assetView: UIView = {
        let assetView = UIView.init(frame: CGRect.zero)
        assetView.backgroundColor = .clear
        assetView.isHidden = true

        return assetView
    }()
    
    open var titleLabel: UILabel = {
        let titleLabel = UILabel.init(frame: CGRect.zero)
        titleLabel.backgroundColor = .clear
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        return titleLabel
    }()
    
    //TODO: Badge View
    
//    open var badgeValue: String? {
//        didSet {
//            if let _ = badgeValue {
//                self.badgeView.badgeValue = badgeValue
//                self.addSubview(badgeView)
//                self.updateLayout()
//            } else {
//                // Remove when nil.
//                self.badgeView.removeFromSuperview()
//            }
//            badgeChanged(animated: true, completion: nil)
//        }
//    }
//    open var badgeColor: UIColor? {
//        didSet {
//            if let _ = badgeColor {
//                self.badgeView.badgeColor = badgeColor
//            } else {
//                self.badgeView.badgeColor = ESTabBarItemBadgeView.defaultBadgeColor
//            }
//        }
//    }
//    open var badgeView: ESTabBarItemBadgeView = ESTabBarItemBadgeView() {
//        willSet {
//            if let _ = badgeView.superview {
//                badgeView.removeFromSuperview()
//            }
//        }
//        didSet {
//            if let _ = badgeView.superview {
//                self.updateLayout()
//            }
//        }
//    }
//    open var badgeOffset: UIOffset = UIOffset.init(horizontal: 6.0, vertical: -22.0) {
//        didSet {
//            if badgeOffset != oldValue {
//                self.updateLayout()
//            }
//        }
//    }
    
    //MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = false
        self.configureSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureSubviews()
    }
    
    //MARK: - View Configuration
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = min(self.cornerRadius, self.tabHeight/2)
     }
    
    private func configureSubviews() {
        self.heightAnchor.constraint(equalToConstant: self.tabHeight).isActive = true
        self.assetView.heightAnchor.constraint(equalToConstant: self.tabHeight*0.8).isActive = true

        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 15)

        //Add height constraint of the view
        self.heightAnchor.constraint(equalToConstant: self.tabHeight).isActive = true
        
        self.addSubview(self.contentStackView)
        
        self.contentStackView.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: 16).isActive = true
        self.contentStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.contentStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.contentStackView.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -16).isActive = true
        self.contentStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.contentStackView.addArrangedSubview(self.assetView)
        self.contentStackView.addArrangedSubview(self.titleLabel)
        
        self.setNeedsLayout()
    }
    
    // MARK: - INTERNAL METHODS
    
    internal func reloadView() {
        self.tintColor = self.selected ? self.selectedTintColor : self.unselectedTintColor

        if self.selectedBackgroundColor != nil{
            self.backgroundColor = self.selected ? self.selectedBackgroundColor : .clear
        } else {
            self.backgroundColor = self.selected ? self.unselectedTintColor : .clear
        }
        
        if self.selected {
            self.titleLabel.textColor = self.selected ? self.selectedTintColor : self.unselectedTintColor
        } else {
            self.titleLabel.textColor = self.selected ? self.selectedTintColor : self.unselectedTintColor
        }
        
        self.titleLabel.textColor = self.selected ? self.selectedTintColor : self.unselectedTintColor
        
        if self.assetView.subviews.count > 0 {
            if (self.assetView.isHidden) {
                self.assetView.isHidden = false
            }
            
            if self.selected {
                if (self.titleLabel.isHidden) { self.titleLabel.isHidden = false }
            } else {
                if (!self.titleLabel.isHidden) { self.titleLabel.isHidden = true }
            }
        } else {
            if (!self.assetView.isHidden) {
                self.assetView.isHidden = true
            }
        }
        
    }

    internal func fold() {
        self.selected = false
        UIView.animate(withDuration: animationDuration, delay:  animationDuration/3, usingSpringWithDamping: 4.0, initialSpringVelocity: 1.0, options: .transitionCrossDissolve, animations: {
            self.reloadView()
        }, completion: nil)
        
        if self.assetView.subviews.count > 0 {
            UIView.animate(withDuration: animationDuration/2, delay: 0.0, animations: {
                self.titleLabel.alpha = 0.0
            }, completion: nil)
        }
    }

    internal func unfold() {
        self.selected = true
        if self.assetView.subviews.count > 0 {
            UIView.animate(withDuration: animationDuration/2, delay: animationDuration/2.5, animations: {
                self.titleLabel.alpha = 1.0
            }, completion: nil)
        }
        
        UIView.animate(withDuration: animationDuration, delay: 0.0, usingSpringWithDamping: 4.0, initialSpringVelocity: 1.0, options: .transitionCrossDissolve, animations: {
            self.reloadView()
        }, completion: nil)
    }
    
    open var widthConstraint : NSLayoutConstraint?
    
    internal func createWidthConstraint(_ constant: CGFloat) {
        self.widthConstraint = self.widthAnchor.constraint(equalToConstant: constant)
        self.widthConstraint?.isActive = true
    }
    
    internal func updateWidthConstraint(_ constant: CGFloat) {
        if self.widthConstraint != nil {
            self.widthConstraint?.constant = constant
            self.widthConstraint?.isActive = true
        } else {
            self.createWidthConstraint(constant)
        }
    }
    
    func deactiveWidthConstraint() {
        self.widthConstraint?.isActive = false
    }
}
