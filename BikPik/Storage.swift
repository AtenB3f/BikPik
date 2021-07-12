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

/*
public class Storages {
    
    //static let disk: Storage = Storage()
    private init() { }
    
    enum Directory {
        case documents
        case caches
        
        var url: URL {
            let path: FileManager.SearchPathDirectory
            switch self {
            case .documents:
                path = .documentDirectory
            case .caches:
                path = .cachesDirectory
            }
            return FileManager.default.urls(for: path, in: .userDomainMask).first!
        }
    }
    
    static func save<T: Encodable>(_ obj: T, to directory: Directory, as fileName: String) {
        let url = directory.url.appendingPathComponent(fileName, isDirectory: false)
        print("[URL]:  \(url)")
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let data = try encoder.encode(obj)
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        } catch let error {
            print("Failed to store msg: \(error.localizedDescription)")
        }
    }
        
    static func search <T: Decodable>(_ fileName: String, from directory: Directory, as type: T.Type) -> T? {
        let url = directory.url.appendingPathComponent(fileName, isDirectory: false)
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        guard let data = FileManager.default.contents(atPath: url.path) else { return nil }
        
        let decoder = JSONDecoder()
        
        do {
            let model = try decoder.decode(type, from: data)
            return model
        } catch let error {
            print("Failed to decode msg: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func remove(_ fileName: String, from directory: Directory) {
        let url = directory.url.appendingPathComponent(fileName, isDirectory: false)
        guard FileManager.default.fileExists(atPath: url.path) else { return }
        
        do {
            try FileManager.default.removeItem(at: url)
        } catch let error {
            print("Failed to remove msg: \(error.localizedDescription)")
        }
    }
    
    static func clear(_ directory: Directory) {
        let url = directory.url
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
            for content in contents {
                try FileManager.default.removeItem(at: content)
            }
        } catch {
            print("---> Failed to clear directory ms: \(error.localizedDescription)")
        }
    }
}
 
*/
