//
//  SampleViewController.swift
//  ExampleApp
//
//  Created by SIU Suet Long on 10/8/2020.
//  Copyright © 2020 KY-iOS. All rights reserved.
//

import UIKit

class SampleViewController: UIViewController {

    var titleLabel: UILabel = {
        var label = UILabel()
        label.textColor = #colorLiteral(red: 0.1579992771, green: 0.1818160117, blue: 0.5072338581, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 55.0, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        titleLabel.text = tabBarItem.title
        view.addSubview(titleLabel)

        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        view.setNeedsLayout()
    }

    func inverseColor() {
        view.backgroundColor = titleLabel.textColor
        titleLabel.textColor = UIColor.white
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return view.backgroundColor == UIColor.white ? .default : .lightContent
    }

}
