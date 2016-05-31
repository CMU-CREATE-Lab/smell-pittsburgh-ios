//
//  SecondViewController.swift
//  SmellPittsburgh Prototype
//
//  Created by Mike Tasota on 4/28/16.
//  Copyright © 2016 Mike Tasota. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        webView.delegate = self
    }
    
    
    override func viewWillAppear(animated: Bool) {
        let request = HttpHelper.generateRequest(Constants.MAP_URL, httpMethod: "GET")
        webView.loadRequest(request)
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        webView.hidden = true
    }
    
    
    func webViewDidFinishLoad(webView: UIWebView) {
        webView.hidden = false
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

