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
    @IBOutlet weak var titleImageViewWidth: NSLayoutConstraint!
    @IBOutlet weak var contentLabelLeading: NSLayoutConstraint!
    @IBOutlet weak var optionImageViewTrailing: NSLayoutConstraint!
    
    // MARK: - PROPERTIES
    let optionsAvailableFor: [String] = ["Appearance", "Formats", "Copy Sound"]
    
    // MARK: - LIFE CYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerView.addCornerRadius(radius: 8)
    }
    
    // MARK: - SETUP SETTINGS CELL
    func setupCell(title: String, image: UIImage) {
        self.versionLabel.isHidden = title == "Version" ? false : true
        self.versionLabel.text = title == "Version" ? APPVERSION : nil
        self.optionsImageView.isHidden = optionsAvailableFor.contains(title) ? false : true
        self.titleImageView.image = image
        self.titleImageView.tintColor = UIColor(resource: .appColorScheme)
        self.contentLabel.text = title
    }
    
    // MARK: - SETUP APPEARANCE CELL
    func configAppearance(title: String, shouldHide: Bool) {
        self.optionsImageView.image = UIImage(systemName: "checkmark.circle.fill")
        self.optionsImageView.isHidden = shouldHide
        self.contentLabel.text = title
        self.versionLabel.isHidden = true
        self.titleImageView.isHidden = true
        self.titleImageViewWidth.constant = 0
        self.contentLabelLeading.constant = 12
        self.optionImageViewTrailing.constant = 15
    }
}
