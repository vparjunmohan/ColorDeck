//
//  Favorites.swift
//  Color Deck
//
//  Created by Arjun Mohan on 30/08/23.
//

import Foundation
import RealmSwift

class Favorites: Object {
    @objc dynamic var uuid: String = ""
    @objc dynamic var isFavorite: Bool = false
    @objc dynamic var colorCode: String = ""
    
    override class func primaryKey() -> String? {
        return "uuid"
    }
    
    required convenience init(data: NSDictionary) {
        self.init()
        self.uuid = data["uuid"] as? String ?? ""
        self.isFavorite = data["isFavorite"] as? Bool ?? false
        self.colorCode = data["colorCode"] as? String ?? ""
    }
    
    convenience init(uuid: String, isFavorite: Bool, colorCode: String) {
        self.init()
        self.uuid = uuid
        self.isFavorite = isFavorite
        self.colorCode = colorCode
    }
}
