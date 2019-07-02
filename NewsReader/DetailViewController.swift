//
//  DetailViewController.swift
//  NewsReader
//
//  Created by Mahjeed Marrow on 5/7/19.
//  Copyright © 2019 Mahjeed Marrow. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController, WKUIDelegate {
    //MARK: - detail view outlets
    @IBOutlet weak var sourceLabelView: UIView!
    @IBOutlet weak var sourceLabel: UILabel!

    var webView: WKWebView!
    var article: News?
    var articleUrl: String?
    
    var spinner = UIActivityIndicatorView(style: .gray)
    
    //MARK: - web view handling
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
        
        self.spinner.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(spinner)
        self.spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func prepareUrlRequest(){
        let url = URL(string: self.articleUrl ?? "https://apple.com")
        let myRequest = URLRequest(url: url!)
        webView.load(myRequest)
        self.webView.navigationDelegate = self as? WKNavigationDelegate
        
        self.spinner.startAnimating()
        self.spinner.hidesWhenStopped = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUrlRequest()
    }
    
    //MARK: handle spinner animation
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        spinner.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        spinner.stopAnimating()
    }
}
