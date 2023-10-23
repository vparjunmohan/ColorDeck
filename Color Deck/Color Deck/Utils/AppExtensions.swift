//
//  AppExtensions.swift
//  Color Deck
//
//  Created by Arjun Mohan on 05/11/22.
//

import Foundation
import UIKit
import AVFoundation

// MARK: - CGFloat
extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

// MARK: - UIColor
extension UIColor {
    convenience init(hexString: String) {
        var hexSanitized = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
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
        label.font = UIFont(name: "Montserrat-Black", size: 30)
        label.textColor = UIColor.init(named: "AppFontColor")
        label.text = "\(title)"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: label)
    }
    
    ///  Config for navigation back button
    /// - Parameter backButtonTitle: Title in String
    func setupBackButton(backButtonTitle: String) {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = UIFont(name: "Montserrat-Black", size: 30)
        button.setImage(UIImage(named: "backButtonIcon"), for: .normal)
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
        let label = UILabel()
        label.text = title
        label.textColor = UIColor.init(named: "AppFontColor")
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.frame = CGRect(x: 0, y: 0, width: 150, height: 30)
        view.addSubview(label)
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
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
        let okAction = UIAlertAction(title: "Done", style: .default) { (_) in
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Notification.Name
extension Notification.Name {
    static let UpdateHeartButton = Notification.Name("UpdateHeartButton")
    static let ClearHeartButton = Notification.Name("ClearHeartButton")
}

// MARK: - APP DELEGATE
extension AppDelegate {
    func setupAppTheme() {
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
        } else {
            UserDefaults.standard.set(2, forKey: "selectedAppearance")
            UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .forEach { $0.overrideUserInterfaceStyle = .unspecified }
        }
    }
    
    func configSelectedCopySound() {
        DispatchQueue.global().async {
            AUDIOPLAYERS.removeAll()
            for fileName in AUDIOFILENAMES {
                if let audioPath = Bundle.main.path(forResource: fileName, ofType: ".mp3") {
                    if let audioPlayer = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath)) {
                        AUDIOPLAYERS.append(audioPlayer)
                    }
                }
            }
        }
        
        guard let _ = UserDefaults.standard.object(forKey: "selectedCopySound") as? Int else {
            UserDefaults.standard.set(0, forKey: "selectedCopySound")
            return
        }
    }
}
