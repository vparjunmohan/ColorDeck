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
    @objc dynamic var showInHistory: Bool = true
    @objc dynamic var createdAt: Int = 0
    @objc dynamic var updatedAt: Int = 0
    
    override class func primaryKey() -> String? {
        return "uuid"
    }
    
    required convenience init(data: NSDictionary) {
        self.init()
        self.uuid = data["uuid"] as? String ?? ""
        self.isFavorite = data["isFavorite"] as? Bool ?? false
        self.colorCode = data["colorCode"] as? String ?? ""
        self.showInHistory = data["showInHistory"] as? Bool ?? true
        self.createdAt = data["createdAt"] as? Int ?? 0
        self.updatedAt = data["updatedAt"] as? Int ?? 0
    }
    
    convenience init(uuid: String, isFavorite: Bool, colorCode: String, showInHistory: Bool, createdAt: Int, updatedAt: Int) {
        self.init()
        self.uuid = uuid
        self.isFavorite = isFavorite
        self.colorCode = colorCode
        self.showInHistory = showInHistory
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
