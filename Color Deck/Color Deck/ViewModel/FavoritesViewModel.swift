//
//  FavoritesViewModel.swift
//  Color Deck
//
//  Created by Arjun Mohan on 30/08/23.
//

import Foundation

class FavoritesViewModel {
    // MARK: - PROPERTIES
    private let favoritesRealm: FavoritesRealm
    private var favoriteColors: [Favorites] = []
    
    // MARK: - LIFE CYCLE
    init(favoritesRealm: FavoritesRealm) {
        self.favoritesRealm = favoritesRealm
    }
    
    // MARK: - FETCH ALL FAVORITES
    func fetchAllFavorites() {
        self.favoriteColors.removeAll()
        let data = self.favoritesRealm.retrieveFavorites()
        let favorites = data.filter({ $0.isFavorite == true }).sorted { val1, val2 in
            val1.updatedAt > val2.updatedAt
        }
        self.favoriteColors = favorites
    }
    
    // MARK: - GET FAVORITE COLORS
    func getFavoriteColors() -> [Favorites] {
        return self.favoriteColors
    }
    
    // MARK: - DELETE A FAVORITE COLOR
    func deleteColorWith(uuid: String) {
        self.favoritesRealm.deleteColorFromRealm(deleteId: uuid) { success in
            if success {
                self.favoriteColors.removeAll()
                self.fetchAllFavorites()
            }
        }
    }
    
    // MARK: - RETRIEVE COLOR CODE
    func retrieveColorCode(uuid: String) -> String {
        var colorCode = ""
        self.favoritesRealm.getColorCode(forUUID: uuid) { favorite in
            colorCode = favorite.colorCode
        }
        return colorCode
    }
    
    // MARK: - RETRIEVE COLOR DATA
    func retrieveColorData(uuid: String) -> Favorites? {
        var data: Favorites?
        self.favoritesRealm.getColorCode(forUUID: uuid) { favourites in
            data = favourites
        }
        return data
    }
    
    // MARK: - PLAY SOUND FOR COPY
    func playCopySound() {
        if let savedSoundIndex = UserDefaults.standard.value(forKey: "selectedCopySound") as? Int {
            if savedSoundIndex != 0 {
                let audioIndex = savedSoundIndex - 1
                AUDIOPLAYERS[audioIndex].play()
            }
        }
    }
    
    // MARK: - FORMAT COPIED HEX
    func formatHexCode(copiedHex: String) -> String {
        var formattedHex = copiedHex
        var hasPrefix = false
        var isLowerCased = false
        if let prefixHexCodes = UserDefaults.standard.object(forKey: "prefixHexCodes") as? Bool {
            hasPrefix = prefixHexCodes
        }
        if let hexLower = UserDefaults.standard.object(forKey: "hexLowerCase") as? Bool {
            isLowerCased = hexLower
        }
        formattedHex = hasPrefix ? copiedHex : String(copiedHex.dropFirst())
        formattedHex = isLowerCased ? formattedHex.lowercased() : formattedHex.uppercased()
        return formattedHex
    }
}
