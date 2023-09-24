//
//  CommonWebViewViewController.swift
//  Color Deck
//
//  Created by Arjun Mohan on 24/09/23.
//

import UIKit
import WebKit
import KRProgressHUD

class CommonWebViewViewController: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var webView: WKWebView!
    
    // MARK: - PROPERTIES
    var webUrl: URL?
    var navbarTitle: String = ""
    
    // MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
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
        KRProgressHUD.set(activityIndicatorViewColors: [UIColor(resource: .appColorScheme)])
        KRProgressHUD.set(style: .custom(background: UIColor.clear, text: UIColor.clear, icon: nil))
        self.tabBarController?.tabBar.isHidden = true
    }
}

// MARK: - WKNavigationDelegate
extension CommonWebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        KRProgressHUD.show()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        KRProgressHUD.dismiss()
    }
}
