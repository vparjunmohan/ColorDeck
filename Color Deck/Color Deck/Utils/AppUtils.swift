//
//  AppUtils.swift
//  Color Deck
//
//  Created by Arjun Mohan on 08/11/22.
//

import UIKit

class AppUtils: NSObject {

    func getJSONFromDict(dict:[String:Any])->String{
        let jsonData = try! JSONSerialization.data(withJSONObject: dict)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
        return jsonString! as String
    }
    
    func getJSONFromArray(dict:[[String:Any]])->String{
        let jsonData = try! JSONSerialization.data(withJSONObject: dict)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
        return jsonString! as String
    }
    
}
