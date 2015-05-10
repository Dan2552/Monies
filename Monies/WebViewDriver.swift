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
        println("visiting \(location)")
        self.webview.loadRequest(NSURLRequest(URL: NSURL(string: location)!))
    }
    
    func labelFor(element:String, completion: ((String) -> Void)) {
        let js = "var answer; var mem = document.getElementById('\(element)'); if (mem) { answer = mem.parentElement.children[0].textContent }; mem && answer || 'null'"
        
        run(js) { result in
            if result != "null" {
                println("read label \(result)")
                completion(result)
            }
        }
    }

    func fillIn(field:String, with:String, completion: ((String) -> Void)) {
        var printValue = with
        if (field as NSString).containsString("pwd") { printValue = "[redacted]" }
        println("fill in value \(printValue)")
        
        run("document.getElementById('\(field)').value = \"\(with)\";") { result in
            completion(result)
        }
    }

    func click(field:String, completion: ((String) -> Void)) {
        println("click \(field)")
        run("document.getElementById('\(field)').click();") { (result) in
            completion(result)
            
            // for some reason, clicking sometimes doesn't work without this
            self.run("$('body').text()") { result in }
        }
    }
    
    func run(string:String, completion: ((String) -> Void)) {
        self.webview.evaluateJavaScript(string, completionHandler: { result, error in
            if (error != nil) {
                println("there was an error running javascript:")
                println(string)
            }
            
            if let result : AnyObject = result {
                completion("\(result)")
            } else {
                completion("")
            }
        })
    }
    
    func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation!) {
        println("didCommitNavigation")
        delegate?.webViewDriverProgress(true)
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        println("didFinishNavigation")
        var url = webView.URL!.absoluteString! as NSString
        delegate?.webViewDriverProgress(false)
        pageLoaded(url as! String)
    }
    
    func pageLoaded(url : String) {
        
    }

}