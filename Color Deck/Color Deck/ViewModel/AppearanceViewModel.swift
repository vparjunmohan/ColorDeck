//
//  AppearanceViewModel.swift
//  Color Deck
//
//  Created by Arjun Mohan on 29/09/23.
//

import Foundation
import UIKit

class AppearanceViewModel {
    
    // MARK: - SETUP SELECTED APPEARANCE
    /// Function is used to setup the appearance of the app for the selected row in the table view
    /// - Parameter forRow: selected table view row
    func configAppearance(forRow: Int) {
        switch forRow {
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
    
    // MARK: - RETRIEVE SAVED APPEARANCE
    /// Function is used to retrieve the index of the saved appearance
    /// - Parameter completion: gives the selected index
    func getSavedAppearance(completion: (_ selectedIndex: Int) -> Void) {
        if let selectedAppearanceIndex = UserDefaults.standard.object(forKey: "selectedAppearance") as? Int {
            completion(selectedAppearanceIndex)
        }
    }
}
