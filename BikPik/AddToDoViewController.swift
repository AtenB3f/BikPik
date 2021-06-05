//
//  AddToDoViewController.swift
//  BikPik
//
//  Created by jihee moon on 2021/06/05.
//

import UIKit

class AddToDoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var navigationAddTask: UINavigationBar!
    
    @IBAction func btnCancle(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    
    @IBAction func btnAdd(_ sender: Any) {
    }
}
