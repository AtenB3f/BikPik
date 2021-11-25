//
//  Settings.swift
//  BikPik
//
//  Created by jihee moon on 2021/11/24.
//

import UIKit

struct SettingData: Codable, Equatable{
    var accountName: String? = nil
    var accountEmail: String? = nil
    var themeTime: Bool = false
    var startSun: Bool = false
    var autoDelete: Bool = false
}


class SettingManager {
    
    let storage = Storage.disk
    
    private init() {
        LoadSetting()
    }
    static let mngSetting = SettingManager()
    
    var data: SettingData = SettingData()
    
    func LoadSetting() {
        let fileName = "Settings.json"
        data = storage.Search(fileName, as: SettingData.self) ?? SettingData()
    }
    
    func SaveSetting() {
        let fileName = "Settings.json"
        storage.Save(data, fileName)
    }
}
