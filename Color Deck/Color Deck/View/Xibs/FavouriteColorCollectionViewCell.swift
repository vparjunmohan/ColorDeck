//
//  FavouriteColorCollectionViewCell.swift
//  Color Deck
//
//  Created by Arjun Mohan on 08/11/22.
//

import UIKit

protocol FavouriteCollectionViewCellDelegate: AnyObject {
    func copyTapped(uuid: String)
    func removeTapped(uuid: String)
}

class FavouriteColorCollectionViewCell: UICollectionViewCell {
    
    // MARK: - OUTLET
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var hexLabel: UILabel!
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    
    // MARK: - PROPERTIES
    weak var delegate: FavouriteCollectionViewCellDelegate?
    
    // MARK: - LIFE CYLE
    override func awakeFromNib() {
        super.awakeFromNib()
        colorView.addCornerRadius(radius: 8)
        colorView.applyCommonDropShadow(radius: 4, opacity: 1)
    }
    
    // MARK: - CONFIG
    func setupCell(data: Favorites) {
        if data.isFavorite {
            self.hexLabel.text = data.colorCode
            self.colorView.backgroundColor = UIColor(hexString: data.colorCode)
            self.removeButton.accessibilityIdentifier = data.uuid
            self.copyButton.accessibilityIdentifier = data.uuid
        }
    }
    
    
    @IBAction func copyTapped(_ sender: UIButton) {
        guard let uuid = sender.accessibilityIdentifier else { return }
        delegate?.copyTapped(uuid: uuid)
    }
    
    
    @IBAction func deleteTapped(_ sender: UIButton) {
        guard let uuid = sender.accessibilityIdentifier else { return }
        delegate?.removeTapped(uuid: uuid)
    }
}
