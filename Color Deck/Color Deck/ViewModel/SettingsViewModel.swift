//
//  SettingsViewModel.swift
//  Color Deck
//
//  Created by Arjun Mohan on 24/09/23.
//

import Foundation
import UIKit

protocol SettingsDelegate: AnyObject {
    func displayAlert(withMessage: String)
}

class SettingsViewModel {
    // MARK: - PROPERTIES
    private let favoritesRealm: FavoritesRealm
    weak var delegate: SettingsDelegate?
    
    // MARK: - LIFE CYCLE
    init(favoritesRealm: FavoritesRealm) {
        self.favoritesRealm = favoritesRealm
    }
    
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
        case "Share App":
            return UIImage(resource: .shareIcon)
        case "Delete Color Data":
            return UIImage(resource: .deleteIcon)
        case "Version":
            return UIImage(resource: .versionIcon)
        default:
            return UIImage(resource: .themeIcon)
        }
    }
    
    //MARK: - SETUP NAVIGATION FOR THE CELL
    /// Function to setup didSelectRowAt for Settings TableView cell
    /// - Parameters:
    ///   - forRow: row id
    ///   - navController: UINavigationController
    func setupCellNavigation(forRow: Int, navController: UINavigationController?, controller: UIViewController) {
        switch forRow {
        case 0:
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AppearanceViewController") as! AppearanceViewController
            navController?.pushViewController(vc, animated: true)
        case 1:
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FormatsViewController") as! FormatsViewController
            navController?.pushViewController(vc, animated: true)
        case 2:
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CopySoundsViewController") as! CopySoundsViewController
            navController?.pushViewController(vc, animated: true)
        case 3:
            let vc = self.setupViewController(title: "Website", url: "https://vparjunmohan.wixsite.com/colordeck")
            navController?.pushViewController(vc, animated: true)
        case 4:
            let vc = self.setupViewController(title: "Privacy Policy", url: "https://vparjunmohan.wixsite.com/colordeck/privacy-policy")
            navController?.pushViewController(vc, animated: true)
        case 5:
            let vc = self.setupViewController(title: "Contact Us", url: "https://vparjunmohan.wixsite.com/colordeck/contact")
            navController?.pushViewController(vc, animated: true)
        case 6:
            if let appLink = URL(string:"https://apps.apple.com/sa/app/color-deck/id6463396110") {
                UIApplication.shared.open(appLink, options: [:], completionHandler: nil)
            }
        case 7:
            self.shareApp(controller: controller)
        case 8:
            self.displayDeleteConfirmationAlert(controller: controller)
        default:
            break
        }
    }
    
    //MARK: - RETRIEVE VIEW CONTROLLER
    /// Function to retrieve CommonWebViewViewController
    /// - Parameters:
    ///   - title: navbar title
    ///   - url: url to be displayed
    /// - Returns: UIViewController
    private func setupViewController(title: String, url: String) -> UIViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CommonWebViewViewController") as! CommonWebViewViewController
        vc.navbarTitle = title
        vc.webUrl = URL(string: url)
        return vc
    }
    
    //MARK: - SHARE APP
    /// Function used to config share app
    /// - Parameter controller: UIViewController on which UIActivityViewController will be presented
    private func shareApp(controller: UIViewController) {
        let textToShare = "Check out this amazing app!"
        let appURL = URL(string: APPURL)
        var items: [Any] = [textToShare]
        if let appURL = appURL {
            items.append(appURL)
        }
        // Create a UIActivityViewController
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        // Customize the popover presentation controller on iPad
        if let popoverPresentationController = activityViewController.popoverPresentationController {
            popoverPresentationController.sourceView = controller.view // Change to your source view
            popoverPresentationController.sourceRect = CGRect(x: controller.view.bounds.midX, y: controller.view.bounds.midY, width: 0, height: 0)
            popoverPresentationController.permittedArrowDirections = []
        }
        controller.present(activityViewController, animated: true, completion: nil)
    }
    
    //MARK: - DELETE COLOR DATA
    /// Function is used to delete/clear whole color data from the database
    private func deleteMyColorData() {
        self.favoritesRealm.deleteMyColorData { message in
            delegate?.displayAlert(withMessage: message)
        }
    }
    
    /// Function is used to display confirmation alert controlelr to the user
    /// - Parameter controller: UIViewController on which UIActivityViewController will be presented
    private func displayDeleteConfirmationAlert(controller: UIViewController) {
        let alertController = UIAlertController(
            title: "",
            message: "Are you sure you want to delete your color data? This action cannot be undone.",
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .default,
            handler: nil
        )
        
        let deleteAction = UIAlertAction(
            title: "Delete",
            style: .destructive) { [weak self] _ in
                guard let self else { return }
                self.deleteMyColorData()
            }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        controller.present(alertController, animated: true, completion: nil)
    }
}
