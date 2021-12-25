//
//  CustomSideMenuViewController.swift
//  BikPik
//
//  Created by jihee moon on 2021/10/13.
//

import UIKit
import SideMenu

class CustomSideMenuViewController: SideMenuNavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presentationStyle = .menuSlideIn
        self.menuWidth = self.view.frame.width * 0.8
        self.presentDuration = 0.8
        self.dismissDuration = 0.8
    }
    
}
