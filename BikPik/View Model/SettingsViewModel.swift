//
//  SettingsViewModel.swift
//  BikPik
//
//  Created by jihee moon on 2021/12/23.
//

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
