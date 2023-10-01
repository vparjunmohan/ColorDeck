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
    func configCell(text: String) {
        self.contentLabel.text = text
    }
    
    // MARK: - ACTION
    @IBAction func switchTapped(_ sender: UISwitch) {
        
    }
}
