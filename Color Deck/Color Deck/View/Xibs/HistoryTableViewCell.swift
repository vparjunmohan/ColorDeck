//
//  HistoryTableViewCell.swift
//  Color Deck
//
//  Created by Arjun Mohan on 03/09/23.
//

import UIKit

protocol HistoryCellDelegate: AnyObject {
    func heartTapped(uuid: String)
}

class HistoryTableViewCell: UITableViewCell {
    
    // MARK: - OUTLET
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var heartButton: UIButton!
    
    // MARK: - PROPERTIES
    weak var delegate: HistoryCellDelegate?
    
    // MARK: - LIFE CYLE
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    
    // MARK: - CONFIG
    private func configUI() {
        colorView.addCornerRadius(radius: 8)
        colorView.applyCommonDropShadow(radius: 1, opacity: 0.5)
        heartButton.applyCommonDropShadow(radius: 1, opacity: 0.5)
    }
    
    // MARK: - HELPERS
    func setupCell(data: Favorites) {
        self.colorView.backgroundColor = UIColor(hexString: data.colorCode)
        if data.isFavorite {
            self.heartButton.isSelected = true
        } else {
            self.heartButton.isSelected = false
        }
        self.heartButton.accessibilityIdentifier = data.uuid
    }
    
    // MARK: - ACTIONS
    @IBAction func heartTapped(_ sender: UIButton) {
        guard let uuid = sender.accessibilityIdentifier else { return }
        sender.isSelected = !sender.isSelected
        delegate?.heartTapped(uuid: uuid)
    }
}
