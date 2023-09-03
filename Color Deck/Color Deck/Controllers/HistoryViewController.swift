//
//  HistoryViewController.swift
//  Color Deck
//
//  Created by Arjun Mohan on 03/09/23.
//

import UIKit

class HistoryViewController: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var historyTableView: UITableView!
    
    // MARK: - PROPERTIES
    private let cellIdentifier = "HistoryTableViewCell"
    let test = [1,1,1,1,1,1,1,1]
    
    // MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
    }
    
    // MARK: - CONFIG
    private func configUI() {
        self.setupNavigation(title: "History")
        self.historyTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
}

// MARK: - UITABLEVIEW DELEGATE
extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return test.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! HistoryTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
