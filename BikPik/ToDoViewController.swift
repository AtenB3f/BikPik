//
//  ToDoViewController.swift
//  BikPik
//
//  Created by jihee moon on 2021/06/05.
//

import UIKit

class ToDoViewController: UIViewController {
    
    @IBOutlet weak var Day: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // today Label Change
        let nowDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        let strDate = dateFormatter.string(from: nowDate)
        Day.text = strDate
    }
    override func viewWillAppear(_ animated: Bool) {
        // To Do List Data Load
    }
    
    
    @IBAction func btnMenu(_ sender: Any) {
        
    }
    
    @IBOutlet weak var btnAddTask: UIButton!
    @IBAction func btnAddTask(_ sender: Any) {
        // Present Add To Do VC
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddToDoVC") as! AddToDoViewController
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true, completion: nil)
    }

    
}
