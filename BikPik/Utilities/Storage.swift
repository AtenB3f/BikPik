//
//  Storage.swift
//  BikPik
//
//  Created by jihee moon on 2021/06/14.
//

import UIKit

public class Storage {
    static let disk: Storage = Storage()
    private init () {
        
    }
    
    var path = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: .userDomainMask).first!
    func Save <T:Encodable> (_ obj: T, _ fileName: String){
        let url = path.appendingPathComponent(fileName, isDirectory: false)
        print("[File URL] : \(url)")
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let encodingData = try encoder.encode(obj)
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
	            FileManager.default.createFile(atPath: url.path, contents: encodingData, attributes: nil)
        } catch let error {
            print("Failed to save data \(error.localizedDescription)")
        }
    }
    
    func Search <T: Decodable> (_ fileName: String, as type: T.Type) -> T? {
        let url = path.appendingPathComponent(fileName, isDirectory: false)
        guard FileManager.default.fileExists(atPath: url.path) else {return nil}
        guard let data = FileManager.default.contents(atPath: url.path) else {return nil}
        let decoder = JSONDecoder()
        
        do {
            let model = try decoder.decode(type, from: data)
            return model
        } catch let error {
            print("Failed to search data \(error.localizedDescription)")
            return nil
        }
    }
    
    func remove (_ fileName: String) {
        let url = path.appendingPathComponent(fileName, isDirectory: false)
        guard FileManager.default.fileExists(atPath: url.path, isDirectory: nil) else { return }
        
        do {
            try FileManager.default.removeItem(at: url)
        } catch let error{
            print("Failed to remove data \(error.localizedDescription)")
        }
    }
}
