//
//  TMDBAuthViewController.swift
//  MovieManager
//
//  Created by Bernadett Kiss on 5/30/18.
//  Copyright © 2018 Bernadett Kiss. All rights reserved.
//

import UIKit
import WebKit

class TMDBAuthViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var wkWebView: WKWebView!
    
    var urlRequest: URLRequest?
    var requestToken: String?
    var completionHandlerForView: ((_ success: Bool, _ errorString: String?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wkWebView.navigationDelegate = self
        navigationItem.title = "TheMovieDB Auth"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelAuth))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let urlRequest = urlRequest {
            wkWebView.load(urlRequest)
        }
    }
    
    @objc func cancelAuth() {
        dismiss(animated: true, completion: nil)
    }
    
    func  webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        let url = webView.url
        if url!.absoluteString.contains(TMDBClient.Constants.AccountURL) {
            if let urlRequest = urlRequest {
                webView.load(urlRequest)
            }
        }
        
        if url!.absoluteString == "\(TMDBClient.Constants.AuthorizationURL)\(requestToken!)/allow" {
            dismiss(animated: true) {
                self.completionHandlerForView!(true, nil)
            }
        }
    }
}
