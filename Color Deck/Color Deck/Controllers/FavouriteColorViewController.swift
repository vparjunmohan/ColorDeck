//
//  FavouriteColorViewController.swift
//  Color Deck
//
//  Created by Arjun Mohan on 08/11/22.
//

import UIKit

class FavouriteColorViewController: UIViewController {
    
    @IBOutlet weak var favouriteCollectionView: UICollectionView!
    
    let test: [String] = ["#FCFDF2", "#7743DB", "#7D8F69", "#393E46", "#FF9F9F", "#FCDDB0", "#8D9EFF"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

}

extension FavouriteColorViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return test.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavouriteColorCollectionViewCell", for: indexPath) as! FavouriteColorCollectionViewCell
        cell.colorView.layer.cornerRadius = 10
        cell.hexLabel.text = test[indexPath.row]
        cell.colorView.backgroundColor = hexStringToUIColor(hex: test[indexPath.row])
        cell.colorView.layer.shadowColor = hexStringToUIColor(hex: test[indexPath.row]).cgColor
        return cell
    }
    
}
