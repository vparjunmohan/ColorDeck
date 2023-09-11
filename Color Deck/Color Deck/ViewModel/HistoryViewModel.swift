//
//  HistoryViewModel.swift
//  Color Deck
//
//  Created by Arjun Mohan on 09/09/23.
//

import Foundation

class HistoryViewModel {
    
    private let favoritesRealm: FavoritesRealm
    private var swipeHistory: [Favorites] = []
    
    init(favoritesRealm: FavoritesRealm) {
        self.favoritesRealm = favoritesRealm
    }
    
    // MARK: - FETCH ALL HISTORY
    func fetchHistory() {
        self.swipeHistory.removeAll()
        self.favoritesRealm.fetchSwipeHistory { history in
            if history != nil {
                guard let history else { return }
                self.swipeHistory = history.reversed()
            }
        }
    }
    
    // MARK: - GET HISTORY COLORS
    func getHistoryColors() -> [Favorites] {
        return Array(self.swipeHistory.prefix(20))
    }
    
    // MARK: - RETRIEVE COLOR DATA
    func retrieveColorData(uuid: String) -> Favorites? {
        var data: Favorites?
        self.favoritesRealm.getColorCode(forUUID: uuid) { favourites in
            data = favourites
        }
        return data
    }
}
