//
//  SettingViewController.swift
//  BikPik
//
//  Created by jihee moon on 2021/10/18.
//

import UIKit
import SnapKit

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func navBtnBack(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
