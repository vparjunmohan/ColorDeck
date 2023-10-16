//
//  FormatsViewModel.swift
//  Color Deck
//
//  Created by Arjun Mohan on 02/10/23.
//

import Foundation

class FormatsViewModel {
    
    // MARK: - RETRIEVE USER SAVED FORMATS
    /// Function is used to retrieve the copy formats saved
    /// - Returns: `shouldPrefix` indicating if the hex code should have # as prefix, `shouldHexLower` indicating if the hex code should be lower cased
    func fetchFormats() -> (shouldPrefix: Bool, shouldHexLower: Bool){
        var prefixHex = false
        var hexLowerCase = false
        if let prefixHexCodes = UserDefaults.standard.object(forKey: "prefixHexCodes") as? Bool {
            prefixHex = prefixHexCodes
        } else {
            UserDefaults.standard.set(false, forKey: "prefixHexCodes")
            prefixHex = false
        }
        if let hexLower = UserDefaults.standard.object(forKey: "hexLowerCase") as? Bool {
            hexLowerCase = hexLower
        } else {
            UserDefaults.standard.set(false, forKey: "hexLowerCase")
            hexLowerCase = false
        }
        return (prefixHex, hexLowerCase)
    }
}
