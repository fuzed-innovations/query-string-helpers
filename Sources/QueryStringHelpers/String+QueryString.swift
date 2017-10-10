//
//  String+QueryString.swift
//  QueryStringHelpers
//

import Foundation

extension String {
    
    public var queryParameters: [String: String] {
        
        guard let startOfQS = self.range(of: "?")?.upperBound else {
            return [:]
        }
        
        let queryString = self.substring(from: startOfQS)
        let queryComponents = queryString.components(separatedBy: "&")
        
        var answer: [String: String] = [:]
        queryComponents.forEach {
            
            if let rangeOfFirstEqual = $0.range(of: "=") {
                
                let key = $0.substring(to: rangeOfFirstEqual.lowerBound).removingPercentEncoding ?? ""
                let value = $0.substring(from: rangeOfFirstEqual.upperBound).removingPercentEncoding ?? ""
                
                answer[key] = value
                
            } else {
                let key = $0.removingPercentEncoding ?? ""
                answer[key] = ""
            }
        }
        
        return answer
    }
    
    public func adding(queryParameters: [String: String]) -> String {
        
        var result = self; // mutable copy
        
        var merged = self.queryParameters
        
        queryParameters.keys.forEach {
            merged[$0] = queryParameters[$0]
        }
        
        if let index = self.index(of: "?") {
            result = self.substring(to: index)
        }
        
        let qs = merged.queryString
        if !qs.characters.isEmpty {
            result += "?" + qs
        }
        
        return result
    }
}

