//
//  PrivacyPolicyViewController.swift
//  Blaze
//
//  Created by Tanya Koldunova on 04.11.2022.
//

import UIKit
import WebKit

class PrivacyPolicyViewController: UIViewController {
    
    private var url: URL
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let webView = WKWebView(frame: self.view.bounds)
        webView.load(URLRequest(url: url))
        self.view.addSubview(webView)
        // Do any additional setup after loading the view.
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

}
