//
//  SettingsViewModel.swift
//  Color Deck
//
//  Created by Arjun Mohan on 24/09/23.
//

import Foundation
import UIKit

class SettingsViewModel {
    
    //MARK: - GET IMAGES FOR THE CELL
    /// Function used to retrieve the image for Settings TableView cell
    /// - Parameter title: title of the cell label
    /// - Returns: image for
    func retrieveImageForCell(title: String) -> UIImage {
        switch title {
        case "Theme":
            return UIImage(resource: .themeIcon)
        case "Formats":
            return  UIImage(resource: .formatIcon)
        case "Copy Sound":
            return  UIImage(resource: .soundIcon)
        case "Website":
            return UIImage(resource: .websiteIcon)
        case "Privacy Policy":
            return UIImage(resource: .privacyPolicyIcon)
        case "Contact Us":
            return UIImage(resource: .contactUsIcon)
        case "Rate App":
            return UIImage(resource: .rateIcon)
        case "Version":
            return UIImage(resource: .versionIcon)
        default:
            return UIImage(resource: .themeIcon)
        }
    }
}
