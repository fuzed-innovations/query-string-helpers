//
//  Dictionary+QueryString.swift
//  QueryStringHelpers
//

import Foundation

extension Dictionary where Key == String, Value == String {
    
    public var queryString: String {
        
        guard self.keys.count > 0 else { return "" }
        
        let urlQueryValueAllowed = (CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[] ").inverted)
        
        return "?" + self.keys.sorted().reduce("") { existingQs, key -> String in
            
            var reducing = existingQs
            
            if !existingQs.characters.isEmpty {
                reducing += "&"
            }
            
            reducing += key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "INVALIDKEY"
            
            if let val = self[key] {
                reducing += "=" + (val.addingPercentEncoding(withAllowedCharacters: urlQueryValueAllowed) ?? "")
            }
            
            return reducing
        }
    }
}
