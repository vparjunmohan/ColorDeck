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
    var appearanceViewModel: AppearanceViewModel?
    
    // MARK: - LIFE CYCLE
    init(vm: AppearanceViewModel) {
        self.appearanceViewModel = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.appearanceViewModel = AppearanceViewModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.showTabBar()
    }
    
    deinit {
        self.appearanceViewModel = nil
    }
    
    // MARK: - CONFIG
    private func configUI() {
        self.setupTheme()
        self.hideTabBar()
        self.appearanceTableView.register(UINib(nibName: "SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingsTableViewCell")
        self.setupBackButton(backButtonTitle: " Appearance")
        guard let appearanceViewModel else { return }
        appearanceViewModel.getSavedAppearance { selectedIndex in
            self.selectedIndex = selectedIndex
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
        guard let appearanceViewModel else { return }
        appearanceViewModel.configAppearance(forRow: indexPath.row)
        self.selectedIndex = indexPath.row
        UserDefaults.standard.set(self.selectedIndex, forKey: "selectedAppearance")
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
