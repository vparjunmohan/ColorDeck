//
//  AppExtensions.swift
//  Color Deck
//
//  Created by Arjun Mohan on 05/11/22.
//

import Foundation
import UIKit

// MARK: - CGFloat
extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

// MARK: - UIColor
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    static func random() -> UIColor {
        return UIColor(
            red:   .random(),
            green: .random(),
            blue:  .random(),
            alpha: 1.0
        )
    }
    
    func toHex() -> String {
        guard let components = cgColor.components, components.count >= 3 else {
            return "#000000"
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        return String(format: "#%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
    }
}

// MARK: - UIView
extension UIView {
    var parentViewController: UIViewController? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            responder = nextResponder
        }
        return nil
    }
    
    /// Function to apply drop shadow for the view
    /// - Parameters:
    ///   - radius: shadow radius in CGFloat
    ///   - opacity: shadow opacity in Float
    func applyCommonDropShadow(radius:CGFloat, opacity: Float) {
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.borderColor = UIColor.black.cgColor
        clipsToBounds = false
    }
    
    func addCornerRadius(radius : CGFloat){
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
}

// MARK: - UIViewController
extension UIViewController {
    
    /// Sets the title for navigation bar
    /// - Parameter title: Title in String
    func setupNavigation(title: String) {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = UIColor.init(named: "AppFontColor")
        label.text = "\(title)"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: label)
    }
    
    ///  Config for navigation back button
    /// - Parameter backButtonTitle: Title in String
    func setupBackButton(backButtonTitle: String) {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.setImage(UIImage(named: "backButtonImage"), for: .normal)
        button.setTitleColor(UIColor.init(named: "AppFontColor"), for: .normal)
        button.setTitle(backButtonTitle, for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    func setupTheme() {
        if let selectedAppearance = UserDefaults.standard.object(forKey: "selectedAppearance") as? Int {
            switch selectedAppearance {
            case 0:
                UIApplication.shared.connectedScenes
                    .compactMap { $0 as? UIWindowScene }
                    .flatMap { $0.windows }
                    .forEach { $0.overrideUserInterfaceStyle = .light }
            case 1:
                UIApplication.shared.connectedScenes
                    .compactMap { $0 as? UIWindowScene }
                    .flatMap { $0.windows }
                    .forEach { $0.overrideUserInterfaceStyle = .dark }
            case 2:
                UIApplication.shared.connectedScenes
                    .compactMap { $0 as? UIWindowScene }
                    .flatMap { $0.windows }
                    .forEach { $0.overrideUserInterfaceStyle = .unspecified }
            default:
                break
            }
        }
    }
    
    func hideTabBar() {
        if let tabBarController = self.tabBarController {
            tabBarController.tabBar.isHidden = true
        }
    }
    
    func showTabBar() {
        if let tabBarController = self.tabBarController {
            tabBarController.tabBar.isHidden = false
        }
    }
    
    /// Function to setup naviagtion bar title with app logo
    /// - Parameter title: Title in String
    func setupTitle(title: String) {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 180, height: 40)
        view.translatesAutoresizingMaskIntoConstraints = false
        let imageView = UIImageView()
        imageView.image = UIImage(named: "color deck")
        imageView.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        imageView.addCornerRadius(radius: 10)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        let label = UILabel()
        label.text = title
        label.textColor = UIColor.init(named: "AppFontColor")
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.frame = CGRect(x: imageView.frame.maxY + 10, y: 0, width: 150, height: 30)
        view.addSubview(label)
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 3).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10).isActive = true
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        label.widthAnchor.constraint(equalToConstant: 150).isActive = true
        self.navigationItem.leftBarButtonItem?.customView?.translatesAutoresizingMaskIntoConstraints = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: view)
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    /// Function to create an alert controller
    /// - Parameter message: Message to be displayed in String
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Notification.Name
extension Notification.Name {
    static let UpdateHeartButton = Notification.Name("UpdateHeartButton")
}
