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
                self.swipeHistory = history.sorted(by: { val1, val2 in
                    val1.updatedAt > val2.updatedAt
                })
            }
        }
    }
    
    // MARK: - GET HISTORY COLORS
    func getHistoryColors() -> [Favorites] {
        return Array(self.swipeHistory.prefix(20))
    }
}
