//
//  JSONLoader.swift
//  Parking
//
//  Created by Kseniia Piskun on 20.08.2024.
//

import Foundation

class JSONLoader {
    func loadJSONData(from fileName: String) -> Data? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
            print("JSON file not found")
            return nil
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            return data
        } catch {
            print("Error loading JSON data: \(error)")
            return nil
        }
    }
    
    func parseJSON(jsonData: Data) -> RootData? {
        let decoder = JSONDecoder()
        do {
            let rootData = try decoder.decode(RootData.self, from: jsonData)
            return rootData
        } catch {
            if let decodingError = error as? DecodingError {
                switch decodingError {
                case .typeMismatch(let key, let context):
                    print("Type mismatch error for key \(key) in context \(context.debugDescription)")
                case .valueNotFound(let type, let context):
                    print("Value not found for type \(type) in context \(context.debugDescription)")
                case .keyNotFound(let key, let context):
                    print("Key '\(key.stringValue)' not found in context: \(context.debugDescription)")
                case .dataCorrupted(let context):
                    print("Data corrupted in context: \(context.debugDescription)")
                default:
                    print("Decoding error: \(decodingError.localizedDescription)")
                }
            } else {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
            return nil
        }
    }

}

