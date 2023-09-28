//
//  AppearanceViewController.swift
//  Color Deck
//
//  Created by Arjun Mohan on 28/09/23.
//

import UIKit

class AppearanceViewController: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var appearanceTableView: UITableView!
    
    // MARK: - PROPERTIES
    let appearanceOptions = ["Light", "Dark", "System"]
    var selectedIndex: Int!
    
    // MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.showTabBar()
    }
    
    // MARK: - CONFIG
    private func configUI() {
        self.setupTheme()
        self.hideTabBar()
        self.appearanceTableView.register(UINib(nibName: "SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingsTableViewCell")
        self.setupBackButton(backButtonTitle: " Appearance")
        if let selectedAppearance = UserDefaults.standard.object(forKey: "selectedAppearance") as? Int {
            self.selectedIndex = selectedAppearance
            self.appearanceTableView.reloadData()
        }
    }
}

// MARK: - TABLEVIEW DELEGATE
extension AppearanceViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.appearanceOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as! SettingsTableViewCell
        if indexPath.row == selectedIndex {
            cell.configAppearance(title: self.appearanceOptions[indexPath.row], shouldHide: false)
        } else {
            cell.configAppearance(title: self.appearanceOptions[indexPath.row], shouldHide: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
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
            return
        }
        self.selectedIndex = indexPath.row
        UserDefaults.standard.set(self.selectedIndex, forKey: "selectedAppearance")
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
