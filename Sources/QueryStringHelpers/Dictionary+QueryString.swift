//
//  Dictionary+QueryString.swift
//  QueryStringHelpers
//

import Foundation

extension Dictionary where Key == String, Value == String {
    
    public var queryString: String {
        
        return self.keys.reduce("") { existingQs, key -> String in
            
            var reducing = existingQs
            
            if !existingQs.characters.isEmpty {
                reducing += "&"
            }
            
            reducing += key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "INVALIDKEY"
            
            if let val = self[key] {
                reducing += "=" + (val.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            }
            
            return reducing
        }
    }
}
