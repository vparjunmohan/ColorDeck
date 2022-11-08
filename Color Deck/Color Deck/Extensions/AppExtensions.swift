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

func hexStringToUIColor(hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }

    if ((cString.count) != 6) {
        return UIColor.gray
    }

    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)

    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

extension ColorDeckViewController {
    
    func setupUI() {
        navigationItem.title = "Color Deck"
        favouriteView.backgroundColor = UIColor.white
        favouriteView.layer.cornerRadius = 30
    }
    
    func createHexLabel() {
        let hexLabel = UILabel()
        hexLabel.tag = 400
        hexLabel.textColor = UIColor.black
        hexLabel.font = UIFont(name: "Chalkboard SE Regular", size: 14.0)
        hexLabel.textAlignment = .center
        view.addSubview(hexLabel)
    }
    
    func createFavButton() {
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
            DbOperations().deleteTable(deleteKey: "uuid", deleteValue: uuid!, tableName: ColorDeckEntity.favouritesTable)
        } else {
            // select with animation
            ColorDeckEntity.favourite.updateValue(uuid!, forKey: "uuid")
            ColorDeckEntity.favourite.updateValue(currentColorCode!, forKey: "color_code")
            DbOperations().insertTable(insertvalues: ColorDeckEntity.favourite, tableName: ColorDeckEntity.favouritesTable, uniquekey: "uuid")
            sender.select()
            sender.imageColorOn = UIColor.red
            sender.circleColor = UIColor.green
            sender.lineColor = UIColor.blue
            sender.duration = 3.0 // default: 1.0
        }
    }
}

extension FavouriteColorViewController {
    func setupUI(){
        let screenSize = view.bounds
        let screenWidth = screenSize.width
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: screenWidth/3, height: screenWidth/3 + 40)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 5
        favouriteCollectionView.collectionViewLayout = layout
        favouriteCollectionView.register(UINib(nibName: "FavouriteColorCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FavouriteColorCollectionViewCell")
    }
}
