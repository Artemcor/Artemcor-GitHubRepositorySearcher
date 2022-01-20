//
//  WebPageRepoController.swift
//  RepositorySearcher(Headway)
//
//  Created by Стожок Артём on 19.01.2022.
//

import UIKit
import WebKit

class WebPageRepoController: UIViewController {
    
    @IBOutlet private weak var repoWebPage: WKWebView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var url: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        repoWebPage.navigationDelegate = self
        guard let url = url else { return }
        repoWebPage.load(URLRequest(url: url))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        spinner.startAnimating()
    }
}

extension WebPageRepoController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        spinner.stopAnimating()
    }
}
