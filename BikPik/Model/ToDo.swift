//
//  ToDo.swift
//  BikPik
//
//  Created by jihee moon on 2021/06/14.
//

struct Task: Codable, Equatable{
    var id : Int = 0
    var name : String = ""
    var inToday : Bool = false
    var date : String = ""
    var time : String = "00:00"
    var alram : Bool = false
    var notiUUID: String?
    var isDone : Bool = false
    var tag : String?
    var color : String?     //0xFFFFFF
    
    init() {
        
    }
    
    init(name: String, date:String, inToday:Bool) {
        self.name = name
        self.date = date
        self.inToday = inToday
    }
    
}
