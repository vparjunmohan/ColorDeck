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
    var historyColors: [Favorites] = []
    var historyViewModel: HistoryViewModel?
    let favoritesRealm = FavoritesRealm()
    
    // MARK: - LIFE CYCLE
    init(viewModel: HistoryViewModel) {
        self.historyViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.historyViewModel = HistoryViewModel(favoritesRealm: self.favoritesRealm)
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configTableView()
    }
    
    deinit {
        self.historyViewModel = nil
    }
    
    // MARK: - CONFIG
    private func configUI() {
        self.setupNavigation(title: "History")
        self.historyTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    private func configTableView() {
        self.historyTableView.flashScrollIndicators()
        guard let historyViewModel else { return }
        historyViewModel.fetchHistory()
        self.setData()
    }
    
    // MARK: - HELPERS
    private func setData() {
        guard let historyViewModel else { return }
        self.historyColors.removeAll()
        let swipeHistory = historyViewModel.getHistoryColors()
        if swipeHistory.count > 0 {
            // add a no history label
            self.historyColors = swipeHistory
        } else {
            
        }
        self.historyTableView.reloadData()
    }
}

// MARK: - UITABLEVIEW DELEGATE
extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyColors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! HistoryTableViewCell
        cell.setupCell(data: historyColors[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
