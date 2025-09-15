//
//  ConfigService.swift
//  GraphQL-LLM
//
//  Created by Saud Waqar on 15/09/2025.
//

import Foundation

class ConfigService {
    static let shared = ConfigService()
    
    private let config: [String: Any]
    
    private init() {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist") else {
            fatalError("❌ Config.plist file not found. Make sure Config.plist exists in your bundle.")
        }
        
        guard let plist = NSDictionary(contentsOfFile: path) as? [String: Any] else {
            fatalError("❌ Config.plist is not a valid property list file.")
        }
        
        self.config = plist
        print("✅ Config.plist loaded successfully")
    }
    
    private func getValue<T>(for key: String, type: T.Type) -> T {
        guard let value = config[key] as? T else {
            fatalError("❌ Key '\(key)' not found in Config.plist or is not of type \(type)")
        }
        return value
    }
    
    func getString(for key: String) -> String {
        return getValue(for: key, type: String.self)
    }
    
    func getOptionalString(for key: String) -> String? {
        return config[key] as? String
    }
    
    func getURL(for key: String) -> URL {
        let urlString = getString(for: key)
        guard let url = URL(string: urlString) else {
            fatalError("❌ Invalid URL for key '\(key)': \(urlString)")
        }
        return url
    }
}

extension ConfigService {
    
    var apiKey: String {
        getString(for: "API_KEY")
    }
    
    var baseURL: URL {
        getURL(for: "BASE_URL")
    }
    
    var apiBaseURL: URL {
        getURL(for: "API_BASE_URL")
    }
}
