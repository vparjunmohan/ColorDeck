//
//  FormatsViewController.swift
//  Color Deck
//
//  Created by Arjun Mohan on 01/10/23.
//

import UIKit

class FormatsViewController: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var formatsTableView: UITableView!
    
    // MARK: - PROPERTIES
    let contentTexts = ["Use # prefix for hex codes", "Hex lowercase"]
    
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
        self.formatsTableView.register(UINib(nibName: "ToggleTableViewCell", bundle: nil), forCellReuseIdentifier: "ToggleTableViewCell")
        self.setupBackButton(backButtonTitle: " Formats")
    }
}

// MARK: - TABLEVIEW DELEGATE
extension FormatsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contentTexts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToggleTableViewCell", for: indexPath) as! ToggleTableViewCell
        cell.configCell(text: self.contentTexts[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
