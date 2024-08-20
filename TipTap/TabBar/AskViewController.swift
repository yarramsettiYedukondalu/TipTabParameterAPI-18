//
//  AskViewController.swift
//  TipTap
//
//  Created by sriram on 09/11/23.
//

import UIKit
import WebKit

class AskViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var webview: WKWebView!
    @IBOutlet weak var backView: UIView!
    var internetCheckTimer : Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        internetCheckTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(checkInternet), userInfo: nil, repeats: true)
        internetCheckTimer?.tolerance = 2.0
        titleLabel.applyLabelStyle(for: .headingBlack)
        backView.layer.cornerRadius = 10
        
        let urlString = "https://webchat.botframework.com/embed/TipTabLang-bot/gemini?b=TipTabLang-bot&s=Lvdch6XZXZU.08_dGzmvQoizOAEzYqM1J4pU5rXd9ibwbgnpGP-N1Go&username=You"
        let url = URL(string: urlString)
        let urlRequest = URLRequest(url: url!)
        webview.load(urlRequest)
    }
    @objc func checkInternet() {
        if !Reachability.isConnectedToNetwork() {
            internetCheckTimer?.invalidate()
            redirectToResponsePage()
        }
    }
    func redirectToResponsePage() {
        // Implement the logic to navigate to the response page
        let controller = self.storyboard?.instantiateViewController(identifier: "InternetViewController") as! InternetViewController
        controller.message = "No Internet Connection"
        self.present(controller, animated: true)
    }
    @IBAction func backButtonAction(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(identifier: "TabBarController") as! TabBarController
        controller.modalPresentationStyle = .fullScreen
        //controller.modalTransitionStyle = .coverVertical
        self.present(controller, animated: false, completion: nil)
    }
}
