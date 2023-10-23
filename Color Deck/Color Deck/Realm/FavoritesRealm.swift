//
//  FavoritesRealm.swift
//  Color Deck
//
//  Created by Arjun Mohan on 30/08/23.
//

import Foundation
import RealmSwift

class FavoritesRealm: NSObject {
    // MARK: - PROPERTIES
    private let realm = try! Realm(configuration: Realm.Configuration(schemaVersion: REALMSCHEMEVERSION))
    
    // MARK: - SEND NEW DATA TO REALM
    func addColorToFavorites(info: NSDictionary) {
        let favoriteData = Favorites(data: info)
        self.saveFavoritesData(data: favoriteData)
    }
    
    // MARK: - SAVE FAVORITES
    func saveFavoritesData(data: Favorites) {
        do {
            try realm.write {
                realm.add(data, update: .all)
            }
        } catch let error {
            print("error saving color data to DB: ", error.localizedDescription)
        }
    }
    
    // MARK: - FETCH ALL FAVORITES
    func retrieveFavorites() -> [Favorites] {
        var favoritesData: [Favorites] = []
        let data = realm.objects(Favorites.self)
        if data.count > 0 {
            data.forEach { datum in
                favoritesData.append(datum)
            }
            return favoritesData
        }
        return favoritesData
    }
    
    // MARK: - REMOVE FAVORITE COLOR
    func deleteColorFromRealm(deleteId: String, completion: (_ success: Bool) -> Void) {
        let data = realm.objects(Favorites.self)
        data.forEach { datum in
            if datum.uuid == deleteId {
                do {
                    try realm.write {
                        realm.delete(datum)
                        completion(true)
                    }
                } catch let err {
                    print("error deleting favourite color:", err.localizedDescription)
                    completion(false)
                }
            }
        }
    }
    
    // MARK: - GET COLOR CODE FOR UUID
    func getColorCode(forUUID: String, completion: (Favorites) -> Void) {
        let data = realm.objects(Favorites.self)
        let filtered = data.filter({ $0.uuid == forUUID })
        if filtered.count > 0 {
            let selectedColor = filtered.first!
            completion(selectedColor)
        }
    }
    
    // MARK: - RETRIEVE HISTORY
    func fetchSwipeHistory(completion: (_ history: [Favorites]?) -> Void) {
        var colorHistory: [Favorites]? = []
        let data = realm.objects(Favorites.self)
        let filtered = data.filter({ $0.showInHistory == true })
        if filtered.count > 0 {
            colorHistory?.append(contentsOf: filtered)
            completion(colorHistory)
        } else {
            completion(nil)
        }
    }
    
    // MARK: - DELETE COLOR DATA
    func deleteMyColorData(completion: (String) -> Void) {
        let data = realm.objects(Favorites.self)
        if !data.isEmpty {
            data.forEach { favourite in
                do {
                    try realm.write {
                        realm.delete(favourite)
                    }
                } catch let err {
                    completion(err.localizedDescription)
                }
            }
            completion("Color Data Deleted")
        } else {
            completion("No Color Data Found")
        }
    }
}
