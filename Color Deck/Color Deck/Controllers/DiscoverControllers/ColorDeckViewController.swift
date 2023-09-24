//
//  ColorDeckViewController.swift
//  Color Deck
//
//  Created by Arjun Mohan on 05/11/22.
//

import UIKit
import RealmSwift

class ColorDeckViewController: UIViewController {
    
    // MARK: - PROPERTIES
    var favoritesRealm: FavoritesRealm?
    
    // MARK: - LIFE CYCLE
    init(realm: FavoritesRealm) {
        self.favoritesRealm = realm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.favoritesRealm = FavoritesRealm()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
    }
    
    deinit{
        self.favoritesRealm = nil
    }
    
    // MARK: - CONFIG
    private func configUI() {
        self.setupNavigation(title: "Discover")
        let swipeViewWidth: CGFloat = 250
        let swipeViewHeight: CGFloat = 350
        let swipeViewX = (view.bounds.width - swipeViewWidth) / 2
        let swipeViewY = (view.bounds.height - swipeViewHeight) / 2
        let swipeViewFrame = CGRect(x: swipeViewX, y: swipeViewY, width: swipeViewWidth, height: swipeViewHeight)
        let initialSwipeView = SwipeView(frame: swipeViewFrame)
        initialSwipeView.delegate = self
        self.view.addSubview(initialSwipeView)
    }
}

// MARK: - SWIPE VIEW DELEGATE
extension ColorDeckViewController: SwipeViewDelegate {
    
    func updateFavorites(uuid: String, isFavorite: Bool, colorCode: String, createdAt: Int, updatedAt: Int) {
        guard let favoritesRealm else { return }
        let favData: [String:Any] = ["uuid": uuid, "isFavorite": isFavorite, "colorCode": colorCode, "showInHistory": true, "createdAt": createdAt, "updatedAt": updatedAt]
        favoritesRealm.addColorToFavorites(info: NSDictionary(dictionary: favData))
    }
    
    func newSwipeViewAdded(swipeView: SwipeView) {
        swipeView.delegate = self
    }
}
