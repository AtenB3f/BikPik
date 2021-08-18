//
//  testViewController.swift
//  BikPik
//
//  Created by jihee moon on 2021/07/23.
//

import UIKit

class testViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewTest.backgroundColor = .black
        rootView.addSubview(viewTest)
        // Do any additional setup after loading the view.
        size = testView.frame
    }
    
    var size: CGRect?
    @IBOutlet weak var testView: UIView!
    
    @IBOutlet var rootView: UIView!
    @IBOutlet weak var testSwt: UISwitch!
    
    
    let viewTest: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 80))
    let labelTest: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
    @IBOutlet weak var label: UILabel!
    @IBAction func testSwt(_ sender: Any) {
        
        if testSwt.isOn {
            print("ON")
            labelTest.text = "ON"
            labelTest.backgroundColor = .brown
            labelTest.textColor = .white
            labelTest.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
            viewTest.frame = CGRect(x: 100, y: 300, width: 100, height: 80)
            viewTest.backgroundColor = .yellow
            viewTest.addSubview(labelTest)
            rootView.addSubview(viewTest)
            
            //  testView.frame = size!
            //testView.backgroundColor = .black
        } else {
            print("OFF")
            labelTest.text = "OFF"
            labelTest.textColor = .white
            labelTest.backgroundColor = .red
            labelTest.frame = CGRect(x: 0, y: 0, width: 100, height: 0)
            viewTest.frame = CGRect(x: 100, y: 300, width: 100, height: 30)
            viewTest.backgroundColor = .blue
            rootView.addSubview(viewTest)
            viewTest.addSubview(labelTest)
            
            //testView.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
            //testView.backgroundColor = .purple
        }
    }
    
    @IBOutlet weak var testBtn: UIButton!
    @IBAction func testBtn(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)

    }
}
