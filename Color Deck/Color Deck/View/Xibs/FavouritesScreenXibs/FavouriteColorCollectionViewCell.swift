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
        self.configUI()
    }
    
    // MARK: - CONFIG
    private func configUI() {
        colorView.addCornerRadius(radius: 8)
        colorView.applyCommonDropShadow(radius: 3, opacity: 0.6)
    }
    
    // MARK: - HELPERS
    func setupCell(data: Favorites) {
        if data.isFavorite {
            self.hexLabel.text = String(data.colorCode.dropFirst())
            self.colorView.backgroundColor = UIColor(hexString: data.colorCode)
            self.removeButton.accessibilityIdentifier = data.uuid
            self.copyButton.accessibilityIdentifier = data.uuid
        }
    }
    
    // MARK: - ACTIONS
    @IBAction func copyTapped(_ sender: UIButton) {
        guard let uuid = sender.accessibilityIdentifier else { return }
        delegate?.copyTapped(uuid: uuid)
    }
    
    
    @IBAction func deleteTapped(_ sender: UIButton) {
        guard let uuid = sender.accessibilityIdentifier else { return }
        delegate?.removeTapped(uuid: uuid)
    }
}
