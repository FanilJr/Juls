//
//  WebViewController.swift
//  Juls
//
//  Created by Fanil_Jr on 04.01.2023.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    lazy var web: WKWebView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let configuration = WKWebViewConfiguration()
        let web = WKWebView(frame: .zero, configuration: configuration)
        return web
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(web)
        web.frame = view.bounds
    }
    
    private func configurationButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDone))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(didTapRefresh))
    }
    @objc func didTapRefresh() {
        web.reload()
    }
    
    @objc func didTapDone() {
        dismiss(animated: true)
    }
}
