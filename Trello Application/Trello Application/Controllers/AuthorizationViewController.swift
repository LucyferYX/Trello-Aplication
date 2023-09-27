//
//  AuthorizationViewController.swift
//  Trello Application
//
//  Created by liene.krista.neimane on 27/09/2023.
//

import UIKit
import WebKit

class AuthorizationViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var APIToken = ""
    let APIKey = "72e332ebe806f2444aaefc232b79699a"
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

//        let url = URL(string: "https://trello.com/1/authorize?expiration=1day&name=MyPersonalToken&scope=read&response_type=token&key=\(APIKey)")!
        // Using my own login
        let url = URL(string: "https://trello.com/1/authorize?expiration=never&scope=read,write,account&response_type=token&key=\(APIKey)")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let url = webView.url else {
            return
        }
        // Fetching token from html
        if url.absoluteString.starts(with: "https://trello.com/1/token/approve") {
            webView.evaluateJavaScript("document.querySelector('pre').innerText", completionHandler: { (result, error) in
                if let token = result as? String {
                    self.APIToken = token
                    print("Token fetched: \(token)")
                }
            })
            navigationController?.popViewController(animated: true)
        }
    }


}

