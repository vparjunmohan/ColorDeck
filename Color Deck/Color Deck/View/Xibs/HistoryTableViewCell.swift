//
//  HistoryTableViewCell.swift
//  Color Deck
//
//  Created by Arjun Mohan on 03/09/23.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    // MARK: - OUTLET
    @IBOutlet weak var colorView: UIView!
    
    // MARK: - PROPERTIES
    
    // MARK: - LIFE CYLE
    override func awakeFromNib() {
        super.awakeFromNib()
        colorView.addCornerRadius(radius: 8)
        colorView.applyCommonDropShadow(radius: 1, opacity: 0.5)
    }

    // MARK: - CONFIG
    func setupCell(data: Favorites) {
        self.colorView.backgroundColor = UIColor(hexString: data.colorCode)
    }
}
