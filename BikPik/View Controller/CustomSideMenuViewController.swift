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
        
        setLayout()
    }
    
    private func setLayout() {
        self.presentationStyle = .menuSlideIn
        
        if UITraitCollection.current.userInterfaceIdiom == .phone {
            self.menuWidth = self.view.frame.width * 0.8
        }
        else if UITraitCollection.current.userInterfaceIdiom == .pad {
            self.menuWidth = self.view.frame.width * 0.35
        }
        self.presentDuration = 0.6
        self.dismissDuration = 0.6
        self.leftSide = false
    }
}
