//
//  FavoritesViewModel.swift
//  Color Deck
//
//  Created by Arjun Mohan on 30/08/23.
//

import Foundation

class FavoritesViewModel {
    
    private let favoritesRealm: FavoritesRealm
    private var favoriteColors: [Favorites] = []
    
    init(favoritesRealm: FavoritesRealm) {
        self.favoritesRealm = favoritesRealm
    }
    
    // MARK: - FETCH ALL FAVORITES
    func fetchAllFavorites() {
        self.favoriteColors.removeAll()
        let data = self.favoritesRealm.retrieveFavorites()
        let favorites = data.filter({ $0.isFavorite == true })
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
    func retrieveColorCode(uuid: String) -> String{
        var colorCode = ""
        self.favoritesRealm.getColorCode(forUUID: uuid) { favorite in
            colorCode = favorite.colorCode
        }
        return colorCode
    }
}
