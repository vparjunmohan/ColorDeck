//
//  FavouriteColorViewController.swift
//  Color Deck
//
//  Created by Arjun Mohan on 08/11/22.
//

import UIKit

class FavouriteColorViewController: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var favouriteCollectionView: UICollectionView!
    @IBOutlet weak var noColorLabel: UILabel!
    
    // MARK: - PROPERTIES
    var favouriteColors: [Favorites] = []
    var favoriteViewModel: FavoritesViewModel?
    let favoritesRealm = FavoritesRealm()
    
    // MARK: - LIFE CYCLE
    init(viewModel: FavoritesViewModel) {
        self.favoriteViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.favoriteViewModel = FavoritesViewModel(favoritesRealm: self.favoritesRealm)
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupData()
    }
    
    deinit {
        self.favoriteViewModel = nil
    }
    
    // MARK: - CONFIG
    private func configUI(){
        self.setupTitle(title: "Favourite")
        let screenSize = view.bounds
        let screenWidth = screenSize.width
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: screenWidth/3, height: screenWidth/3 + 40)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 5
        favouriteCollectionView.collectionViewLayout = layout
        favouriteCollectionView.register(UINib(nibName: "FavouriteColorCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FavouriteColorCollectionViewCell")
    }
    
    // MARK: - HELPERS
    private func setupData() {
        guard let favoriteViewModel else { return }
        favoriteViewModel.fetchAllFavorites()
        self.setData()
    }
    
    private func setData() {
        guard let favoriteViewModel else { return }
        self.favouriteColors.removeAll()
        let colors = favoriteViewModel.getFavoriteColors()
        if colors.count > 0 {
            self.noColorLabel.isHidden = true
            self.favouriteColors = colors
        } else {
            self.noColorLabel.isHidden = false
        }
        self.favouriteCollectionView.reloadData()
    }
}

// MARK: - COLLECTION VIEW DELEGATE
extension FavouriteColorViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favouriteColors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavouriteColorCollectionViewCell", for: indexPath) as! FavouriteColorCollectionViewCell
        let currentColor = favouriteColors[indexPath.row]
        cell.setupCell(data: currentColor)
        cell.delegate = self
        return cell
    }
}

// MARK: - FAVORITE COLLECTION VIEW CELL DELEGATE
extension FavouriteColorViewController: FavouriteCollectionViewCellDelegate {
    
    func copyTapped(uuid: String) {
        guard let favoriteViewModel else { return }
        let colorCode = favoriteViewModel.retrieveColorCode(uuid: uuid)
        UIPasteboard.general.string = colorCode
        self.showAlert(message: "Copied color code \(colorCode)")
    }
    
    func removeTapped(uuid: String) {
        guard let favoriteViewModel else { return }
        favoriteViewModel.deleteColorWith(uuid: uuid)
        self.setData()
        let identifier = ["uuid": uuid]
        NotificationCenter.default.post(name: .UpdateHeartButton, object: nil, userInfo: identifier)
    }
}
