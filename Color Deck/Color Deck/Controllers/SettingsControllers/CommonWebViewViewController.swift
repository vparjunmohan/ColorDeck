//
//  CommonWebViewViewController.swift
//  Color Deck
//
//  Created by Arjun Mohan on 24/09/23.
//

import UIKit
import WebKit

class CommonWebViewViewController: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var webView: WKWebView!
    
    // MARK: - PROPERTIES
    var webUrl: URL?
    var navbarTitle: String = ""
    
    // MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    deinit {
        self.webUrl = nil
    }

    // MARK: - CONFIG
    private func configUI() {
        guard let webUrl else { return }
        self.webView.navigationDelegate = self
        self.setupBackButton(backButtonTitle: " \(navbarTitle)")
        self.webView.load(URLRequest(url: webUrl))
        self.tabBarController?.tabBar.isHidden = true
    }
}

extension CommonWebViewViewController: WKNavigationDelegate {
    
}
