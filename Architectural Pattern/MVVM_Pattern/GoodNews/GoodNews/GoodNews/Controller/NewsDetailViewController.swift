//
//  NewsDetailViewController.swift
//  GoodNews
//
//  Created by μμΉν on 2022/09/01.
//

import UIKit
import WebKit
class NewsDetailViewController : UIViewController{
    var webView : WKWebView!
    var url     : String! = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let myURL = URL(string: url) else {return}
        let myRequest = URLRequest(url: myURL)
        webView.load(myRequest)
        
    }
}
extension NewsDetailViewController : WKUIDelegate {
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration:  webConfiguration)
        webView.uiDelegate = self
        self.view = webView
    }
}
