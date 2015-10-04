//
//  FirstViewController.swift
//  Example
//
//  Created by Akiva Leffert on 9/24/15.
//  Copyright © 2015 Akiva Leffert. All rights reserved.
//

import UIKit
import SnapKit

let size = 100

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let leadingView = UIView()
        leadingView.backgroundColor = UIColor(red: 1.0, green: 157.0/255.0, blue: 0, alpha: 1)
        let trailingView = UIView()
        trailingView.backgroundColor = UIColor(red: 1.0, green: 157.0/255.0, blue: 0, alpha: 1)
        
        view.addSubview(leadingView)
        view.addSubview(trailingView)
        
        leadingView.snp_makeConstraints {make in
            make.width.equalTo(size)
            make.height.equalTo(size)
            make.leading.equalTo(view).offset(50)
            make.centerY.equalTo(view)
        }
        
        trailingView.snp_makeConstraints{make in
            make.width.equalTo(leadingView)
            make.height.equalTo(leadingView)
            make.trailing.equalTo(view).offset(-50)
            make.centerY.equalTo(view)
        }
    }

}

