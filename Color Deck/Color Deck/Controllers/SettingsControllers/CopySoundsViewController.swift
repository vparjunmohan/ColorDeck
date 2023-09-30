//
//  CopySoundsViewController.swift
//  Color Deck
//
//  Created by Arjun Mohan on 29/09/23.
//

import UIKit
import AVFoundation

class CopySoundsViewController: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var soundsTableView: UITableView!
    
    // MARK: - PROPERTIES
    let audioFileNames = ["None", "Bell", "Cool", "Message", "Pop", "Soft"]
    var audioPlayers: [AVAudioPlayer] = []
    var selectedIndex: Int!
    var copySoundViewModel: CopySoundsViewModel?
    
    // MARK: - LIFE CYCLE
    init(vm: CopySoundsViewModel) {
        self.copySoundViewModel = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.copySoundViewModel = CopySoundsViewModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            // Initialize AVAudioPlayer instances for each audio file except "None"
            for fileName in self.audioFileNames.dropFirst() {
                if let audioPath = Bundle.main.path(forResource: fileName, ofType: ".mp3") {
                    if let audioPlayer = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath)) {
                        self.audioPlayers.append(audioPlayer)
                    }
                }
            }
        }
        self.configUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.showTabBar()
    }
    
    deinit{
        self.copySoundViewModel = nil
    }
    
    // MARK: - CONFIG
    private func configUI() {
        self.setupTheme()
        self.hideTabBar()
        self.soundsTableView.register(UINib(nibName: "SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingsTableViewCell")
        self.setupBackButton(backButtonTitle: " Copy Sound")
        guard let copySoundViewModel else { return }
        copySoundViewModel.getSavedCopySoundIndex { selectedIndex in
            self.selectedIndex = selectedIndex
            self.soundsTableView.reloadData()
        }
    }
}

// MARK: - TABLEVIEW DELEGATE
extension CopySoundsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.audioFileNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as! SettingsTableViewCell
        if indexPath.row == selectedIndex {
            cell.configCopySound(title: self.audioFileNames[indexPath.row], shouldHide: false)
        } else {
            cell.configCopySound(title: self.audioFileNames[indexPath.row], shouldHide: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: // If "None" is selected, do nothing (play no audio)
            break
        default:
            let audioIndex = indexPath.row - 1
            if audioIndex < audioPlayers.count {
                audioPlayers[audioIndex].play()
            }
        }
        self.selectedIndex = indexPath.row
        UserDefaults.standard.set(self.selectedIndex, forKey: "selectedCopySound")
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
