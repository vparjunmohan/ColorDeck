//
//  ToggleTableViewCell.swift
//  Color Deck
//
//  Created by Arjun Mohan on 01/10/23.
//

import UIKit

class ToggleTableViewCell: UITableViewCell {
    
    // MARK: - OUTLETS
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var toggleSwitch: UISwitch!
    
    // MARK: - LIFE CYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerView.addCornerRadius(radius: 8)
    }
    
    // MARK: - SETUP FORMATS CELL
    func configCell(index: Int, text: String, switchState: (Bool, Bool)) {
        self.contentLabel.text = text
        self.toggleSwitch.onTintColor = UIColor(resource: .appColorScheme)
        if text == "Use # prefix for hex codes" {
            self.toggleSwitch.isOn = switchState.0
        } else {
            self.toggleSwitch.isOn = switchState.1
        }
        self.toggleSwitch.tag = index
    }
    
    // MARK: - ACTION
    @IBAction func switchTapped(_ sender: UISwitch) {
        if sender.tag == 0 {
            UserDefaults.standard.set(sender.isOn, forKey: "prefixHexCodes")
        } else {
            UserDefaults.standard.set(sender.isOn, forKey: "hexLowerCase")
        }
    }
}
