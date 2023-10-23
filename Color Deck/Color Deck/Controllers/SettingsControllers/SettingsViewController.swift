//
//  SettingsViewController.swift
//  Color Deck
//
//  Created by Arjun Mohan on 18/09/23.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var settingsTableView: UITableView!
    
    // MARK: - PROPERTIES
    let contents: [String] = ["Appearance", "Formats", "Copy Sound", "Website", "Privacy Policy", "Contact Us", "Rate App", "Share App", "Delete Color Data", "Version"]
    var viewModel: SettingsViewModel?
    private let favoritesRealm = FavoritesRealm()
    
    // MARK: - LIFE CYCLE
    init(vm: SettingsViewModel) {
        self.viewModel = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = SettingsViewModel(favoritesRealm: self.favoritesRealm)
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
        self.configTableView()
    }
    
    deinit {
        viewModel = nil
    }
    
    // MARK: - CONFIG
    private func configUI() {
        guard let viewModel else { return }
        viewModel.delegate = self
        self.setupTheme()
        self.setupNavigation(title: "Settings")
    }
    
    private func configTableView() {
        self.settingsTableView.delegate = self
        self.settingsTableView.dataSource = self
        self.settingsTableView.register(UINib(nibName: "SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingsTableViewCell")
    }
}

// MARK: - UITABLEVIEW DELEGATE
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as! SettingsTableViewCell
        guard let viewModel else { return cell }
        cell.setupCell(title: contents[indexPath.row], image: viewModel.retrieveImageForCell(title: contents[indexPath.row]))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel else { return }
        viewModel.setupCellNavigation(forRow: indexPath.row, navController: self.navigationController, controller: self)
    }
}

// MARK: - UITABLEVIEW DELEGATE
extension SettingsViewController: SettingsDelegate {
    
    func displayAlert(withMessage: String) {
        self.showAlert(message: withMessage)
        NotificationCenter.default.post(name: .ClearHeartButton, object: nil, userInfo: nil)
    }
}
