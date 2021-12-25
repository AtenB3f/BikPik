//
//  Settings.swift
//  BikPik
//
//  Created by jihee moon on 2021/11/24.
//

struct SettingData: Codable, Equatable{
    var accountName: String? = nil
    var accountEmail: String? = nil
    var themeTime: Bool = false
    var startSun: Bool = false
    var autoDelete: Bool = false
}
