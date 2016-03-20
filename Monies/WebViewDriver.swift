import Foundation
import WebKit

protocol WebViewDriverProgressDelegate {
    func webViewDriverProgress(progress: Bool)
}

class WebViewDriver : NSObject, WKNavigationDelegate {
    var webView : WKWebView
    var delegate : WebViewDriverProgressDelegate?

    var activeFlows = [WebDriverFlow]()

    init(webView: WKWebView? = nil) {
        self.webView = webView ?? WKWebView()
        super.init()
        self.webView.navigationDelegate = self
    }

    func executeFlows() {
        for flow in activeFlows {
            if flow.startFlow() { return }
        }
    }
    
    func visit(location: String) {
        print("visiting \(location)")
        self.webView.loadRequest(NSURLRequest(URL: NSURL(string: location)!))
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

    func fillIn(field:String, with:String, redactPrint: Bool = false, completion: ((String) -> Void)) {
        var printValue = with
        if redactPrint { printValue = "[redacted]" }
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
            if self.webView.superview == nil {
                print("WEBVIEW ADDED TO VIEW HIERARCHY")
                window?.addSubview(self.webView)
                window?.sendSubviewToBack(self.webView)
                Async.main(after: 2) {
                    print("WEBVIEW REMOVED FROM VIEW HIERARCHY")
                    self.webView.removeFromSuperview()
                }
            }

        }
    }
    
    func run(string:String, completion: ((String) -> Void)) {
        self.webView.evaluateJavaScript(string, completionHandler: { result, error in
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
        print("pageLoaded: \(url)")
        for flow in activeFlows {
            if flow.startActionForPage(url) {
                print("action started by \(flow)")
                return
            }
        }
    }

}