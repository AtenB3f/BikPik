//
//  ToDoViewController.swift
//  BikPik
//
//  Created by jihee moon on 2021/06/05.
//

import UIKit

class ToDoViewController: UIViewController {
    
    @IBOutlet weak var Day: UILabel!
    @IBOutlet weak var scrlToDoList: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // today Label Change
        let nowDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        let strDate = dateFormatter.string(from: nowDate)
        Day.text = strDate
    }
    
    
    @IBAction func btnMenu(_ sender: Any) {
        
    }
    
    @IBAction func btnAddTask(_ sender: Any) {
        
    }
    
}
