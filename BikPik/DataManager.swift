//
//  DataManager.swift
//  BikPik
//
//  Created by jihee moon on 2021/09/07.
//

import UIKit

class DataManager {
    
    static let dataMng = DataManager()
    private init() {
        
    }
    
    var tasks: [String: Task] = [:]         // KEY is [task name + "_" + ID]
    var taskIdList: [String : Int] = [:]    // KEY is [task name] , VALUE is [ID]
    var taskList: [String] = []             // VALUE is [task name]
    var selTaskList : [String] = []
    var selDate: String = Date.FullNowDate()
    
    
}
