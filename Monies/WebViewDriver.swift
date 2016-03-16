//
//  driver.swift
//  MoniesMac
//
//  Created by Daniel Green on 05/11/2014.
//  Copyright (c) 2014 Daniel Green. All rights reserved.
//

import Foundation
import WebKit

protocol WebViewDriverProgressDelegate {
    func webViewDriverProgress(progress: Bool)
}

class WebViewDriver : NSObject, WKNavigationDelegate {
    var webview : WKWebView
    var delegate : WebViewDriverProgressDelegate?
    
    init(webView: WKWebView) {
        self.webview = webView
        super.init()
        self.webview.navigationDelegate = self
    }
    
    func oneAtATime(closure: () -> ()) {
        objc_sync_enter(self)
        closure()
        objc_sync_exit(self)
    }
    
    func visit(location: String) {
        print("visiting \(location)")
        self.webview.loadRequest(NSURLRequest(URL: NSURL(string: location)!))
    }
    
    func labelFor(element:String, completion: ((String) -> Void)) {
        let js = "var answer; var mem = document.getElementById('\(element)'); if (mem) { answer = mem.parentElement.children[0].textContent }; mem && answer || 'null'"
        
        run(js) { result in
            if result != "null" {
                print("read label \(result)")
                completion(result)
            }
        }
    }

    func fillIn(field:String, with:String, completion: ((String) -> Void)) {
        var printValue = with
        if (field as NSString).containsString("pwd") { printValue = "[redacted]" }
        print("fill in value \(printValue)")
        
        run("document.getElementById('\(field)').value = \"\(with)\";") { result in
            completion(result)
        }
    }

    func click(field:String, completion: ((String) -> Void)) {
        print("click \(field)")
        run("document.getElementById('\(field)').click();") { (result) in
            completion(result)
            
            // for some reason, clicking sometimes doesn't work without this
            self.run("$('body').text()") { result in }

            // temporarily show the webview onscreen because annoyingly without 
            // doing this also sometimes hangs
            let window = UIApplication.sharedApplication().delegate!.window!
            if self.webview.superview == nil {
                print("WEBVIEW ADDED TO VIEW HIERARCHY")
                window?.addSubview(self.webview)
                Async.main(after: 2) {
                    print("WEBVIEW REMOVED FROM VIEW HIERARCHY")
                    self.webview.removeFromSuperview()
                }
            }

        }
    }
    
    func run(string:String, completion: ((String) -> Void)) {
        self.webview.evaluateJavaScript(string, completionHandler: { result, error in
            if (error != nil) {
                print("there was an error running javascript:")
                print(string)
            }
            
            if let result : AnyObject = result {
                completion("\(result)")
            } else {
                completion("")
            }
        })
    }
    
    func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation!) {
        print("didCommitNavigation")
        delegate?.webViewDriverProgress(true)
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        print("didFinishNavigation")
        let url = webView.URL!.absoluteString
        delegate?.webViewDriverProgress(false)
        pageLoaded(url)
    }
    
    func pageLoaded(url : String) {
        
    }

}