//
//  SettingsTableViewCell.swift
//  Color Deck
//
//  Created by Arjun Mohan on 24/09/23.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    // MARK: - OUTLETS
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var optionsImageView: UIImageView!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var titleImageView: UIImageView!
    
    // MARK: - PROPERTIES
    let optionsAvailableFor: [String] = ["Theme", "Formats", "Copy Sound"]
    
    // MARK: - LIFE CYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerView.addCornerRadius(radius: 8)
    }
    
    // MARK: - SETUP CELL
    func setupCell(title: String, image: UIImage) {
        self.versionLabel.isHidden = title == "Version" ? false : true
        self.versionLabel.text = title == "Version" ? APPVERSION : nil
        self.optionsImageView.isHidden = optionsAvailableFor.contains(title) ? false : true
        self.titleImageView.image = image
        self.titleImageView.tintColor = UIColor(resource: .appColorScheme)
        self.contentLabel.text = title
    }
}
