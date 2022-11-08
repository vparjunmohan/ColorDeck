//
//  FavouriteColorViewController.swift
//  Color Deck
//
//  Created by Arjun Mohan on 08/11/22.
//

import UIKit

protocol FavouriteColorDelegate {
    func updateButtonUI()
}

class FavouriteColorViewController: UIViewController {
    
    @IBOutlet weak var favouriteCollectionView: UICollectionView!
    
    var favouriteColors: [[String:Any]] = []
    var favouriteDelegate: FavouriteColorDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            if favouriteDelegate != nil {
                favouriteDelegate.updateButtonUI()
            }
        }
    }
}

extension FavouriteColorViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favouriteColors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavouriteColorCollectionViewCell", for: indexPath) as! FavouriteColorCollectionViewCell
        let currentColor = favouriteColors[indexPath.row]
        cell.colorView.layer.cornerRadius = 10
        cell.hexLabel.text = currentColor["color_code"] as? String
        cell.colorView.backgroundColor = hexStringToUIColor(hex: currentColor["color_code"] as! String)
        cell.colorView.layer.shadowColor = hexStringToUIColor(hex: currentColor["color_code"] as! String).cgColor
        cell.copyButton.accessibilityIdentifier = currentColor["uuid"] as? String
        cell.removeButton.accessibilityIdentifier = currentColor["uuid"] as? String
        cell.copyButton.addTarget(self, action: #selector(colorCopied(_:)), for: .touchUpInside)
        cell.removeButton.addTarget(self, action: #selector(colorRemoved(_:)), for: .touchUpInside)
        return cell
    }
    
}
