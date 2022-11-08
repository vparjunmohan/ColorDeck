//
//  AppExtensions.swift
//  Color Deck
//
//  Created by Arjun Mohan on 05/11/22.
//

import Foundation
import UIKit
import DOFavoriteButton

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
            red:   .random(),
            green: .random(),
            blue:  .random(),
            alpha: 1.0
        )
    }
}

extension UIView {
    func applyCommonDropShadow(radius:CGFloat, opacity: Float) {
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.borderColor = UIColor.black.cgColor
        clipsToBounds = false
    }
}

func hexStringFromColor(color: UIColor) -> String {
    let components = color.cgColor.components
    let r: CGFloat = components?[0] ?? 0.0
    let g: CGFloat = components?[1] ?? 0.0
    let b: CGFloat = components?[2] ?? 0.0
    
    let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
    
    return hexString
}

extension ColorDeckViewController {
    
    func setupUI() {
        favouriteView.backgroundColor = UIColor.white
        favouriteView.layer.cornerRadius = 30
    }
    
    func createHexLabel() {
        let hexLabel = UILabel()
        hexLabel.tag = 400
        hexLabel.font = UIFont(name: "Chalkboard SE Regular", size: 14.0)
        hexLabel.textAlignment = .center
        view.addSubview(hexLabel)
    }
    
    func createFavButton() {
        let defaults = UserDefaults.standard
        
        let favButton = DOFavoriteButton(frame: CGRect(x: 0, y: 0, width: 70, height: 70), image: UIImage(named: "favorite"))
        favButton.imageColorOff = .white
        favButton.tag = 100935485
        favButton.center = view.center
        view.addSubview(favButton)
        view.bringSubviewToFront(favButton)
        favButton.addTarget(self, action: #selector(clicked), for: .touchUpInside)
    }
    
    @objc func clicked(_ sender: DOFavoriteButton) {
        if sender.isSelected {
            // deselect
            sender.deselect()
            sender.imageColorOff = UIColor.white
        } else {
            // select with animation
            sender.select()
            sender.imageColorOn = UIColor.red
            sender.circleColor = UIColor.green
            sender.lineColor = UIColor.blue
            sender.duration = 3.0 // default: 1.0
        }
    }
}
