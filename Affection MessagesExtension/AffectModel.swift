//
//  AffectModel.swift
//  Affection MessagesExtension
//
//  Created by Roman Pshichenko on 1/17/21.
//

import Foundation
import Messages

struct Affect {
    var reason: String
    var date: Date
    
    init() {
        self.date = Date.init()
        self.reason = ""
    }
    
    init?(queryItems: [URLQueryItem]) {
        var decodedReason: String?
        var decodedDate: Date?
        for queryItem in queryItems {
            guard let value = queryItem.value else { return nil }
            if queryItem.name == "reason"{
                decodedReason = value
            }
            if queryItem.name == "date"{
                decodedDate = Date.init()
            }
        }
        
        self.reason = decodedReason ?? ""
        self.date = decodedDate ?? Date.init()
    }
    
    init?(message: MSMessage?){
        guard let url = message?.url else { return nil }
        guard let urlComponents = NSURLComponents(url: url, resolvingAgainstBaseURL: false), let queryItems = urlComponents.queryItems else { return nil }
        
        self.init(queryItems: queryItems)
    }
}
