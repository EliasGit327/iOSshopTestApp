//
//  UserVCViewController.swift
//  iOSshopTestApp
//
//  Created by Elias on 20/06/2019.
//  Copyright © 2019 Elias. All rights reserved.
//

import UIKit

class UserVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setTitleLogo(navigationItem: navigationItem)
    
    }

    public func setTitleLogo( navigationItem : UINavigationItem ) {
        
        //Title View
        let imageView = UIImageView(image: UIImage(named: "user_transp.png"))
        imageView.contentMode = .scaleAspectFit
        
        navigationItem.titleView = imageView
    }
}
