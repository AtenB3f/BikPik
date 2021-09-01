//
//  HabitViewController.swift
//  BikPik
//
//  Created by jihee moon on 2021/09/01.
//

import UIKit

class HabitViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var btnAddHabit: UIButton!
    @IBAction func btnAddHabit(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "AddHabitVC") as! AddHabitViewController
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true, completion: nil)
    }
    
}
