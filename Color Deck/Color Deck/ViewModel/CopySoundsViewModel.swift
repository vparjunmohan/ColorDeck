//
//  CopySoundsViewModel.swift
//  Color Deck
//
//  Created by Arjun Mohan on 30/09/23.
//

import Foundation

class CopySoundsViewModel {
    
    // MARK: - RETRIEVE INDEX FOR SAVED SOUND
    /// Function is used to retrieve the index of the saved sound
    /// - Parameter completion: gives the selected index
    func getSavedCopySoundIndex(completion: (_ selectedIndex: Int) -> Void) {
        if let selectedSoundIndex = UserDefaults.standard.object(forKey: "selectedCopySound") as? Int {
            completion(selectedSoundIndex)
        }
    }
    
    // MARK: - PLAY SOUND FOR COPY
    func playCopySound(index: Int) {
        AUDIOPLAYERS[index-1].play()
    }
}
