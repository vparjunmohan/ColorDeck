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
    @IBOutlet weak var noHistoryLabel: UILabel!
    
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
    
    private func configEmptyStates() {
        if #available(iOS 17.0, *) {
            self.noHistoryLabel.isHidden = true
            var config = UIContentUnavailableConfiguration.empty()
            config.image = UIImage(systemName: "list.bullet.rectangle.portrait")
            config.imageProperties.tintColor = UIColor(resource: .appColorScheme)
            config.text = "No History found"
            config.secondaryText = "Your color history will appear here"
            self.contentUnavailableConfiguration = config
        } else {
            self.noHistoryLabel.isHidden = false
        }
    }
    
    // MARK: - HELPERS
    private func setData() {
        guard let historyViewModel else { return }
        self.historyColors.removeAll()
        let swipeHistory = historyViewModel.getHistoryColors()
        if swipeHistory.count > 0 {
            if #available(iOS 17.0, *) {
                self.contentUnavailableConfiguration = nil
            }
            self.noHistoryLabel.isHidden = true
            self.historyColors = swipeHistory
        } else {
            self.configEmptyStates()
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
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

// MARK: - HISTORY CELL DELEGATE
extension HistoryViewController: HistoryCellDelegate {
    
    func heartTapped(uuid: String) {
        guard let historyViewModel, let colorData = historyViewModel.retrieveColorData(uuid: uuid) else { return }
        var updatedData: Favorites?
        if colorData.isFavorite {
            updatedData = Favorites(uuid: colorData.uuid, isFavorite: false, colorCode: colorData.colorCode, showInHistory: colorData.showInHistory, createdAt: colorData.createdAt, updatedAt: Int(Date().timeIntervalSince1970))
        } else {
            updatedData = Favorites(uuid: colorData.uuid, isFavorite: true, colorCode: colorData.colorCode, showInHistory: colorData.showInHistory, createdAt: colorData.createdAt, updatedAt: Int(Date().timeIntervalSince1970))
        }
        let identifier = ["uuid": colorData.uuid]
        NotificationCenter.default.post(name: .UpdateHeartButton, object: nil, userInfo: identifier)
        guard let updatedData else { return }
        favoritesRealm.saveFavoritesData(data: updatedData)
        historyViewModel.fetchHistory()
        self.setData()
    }
}
