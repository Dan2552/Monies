import Foundation
import WebKit
import Async
import then

protocol WebViewDriverProgressDelegate {
    func webViewDriverProgress(_ progress: Bool)
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

    func visit(_ location: String) {
        print("visiting \(location)")
        self.webView.load(URLRequest(url: URL(string: location)!))
    }

    func labelFor(_ element:String) -> Promise<String> {
        let js = "var answer; var mem = document.getElementById('\(element)'); if (mem) { answer = mem.parentElement.children[0].textContent }; mem && answer || 'null'"

        return run(js).then({ result in
            return Promise { resolve, reject in
                
                if result == "null" {
                    resolve("")
                } else {
                    print("read label \(result)")
                    resolve(result)
                }
            }
        })
    }

    func fillIn(_ field: String, with: String, redactPrint: Bool = false) -> Promise<String> {
        var printValue = with
        if redactPrint { printValue = "[redacted]" }
        print("fill in value \(printValue)")

        return run("document.getElementById('\(field)').value = \"\(with)\";")
    }

    func click(_ field:String) -> Promise<String> {
        print("click \(field)")
        return Promise { resolve, reject in
            async {
                self.webViewHack()
                _ = try! await(self.run("$('body').text()"))
                _ = try! await(self.run("document.getElementById('\(field)').click();"))
            }
            resolve("")
        }
    }

    func run(_ string:String) -> Promise<String> {
        webViewHack()
        return Promise { resolve, reject in
            Async.main {
                self.webView.evaluateJavaScript(string) { result, error in
                    if (error != nil) {
                        print("there was an error running javascript:")
                        print(string)
                    }

                    if let result = result {
                        resolve("\(result)")
                    } else {
                        resolve("")
                    }
                }
            }
        }
    }

    // temporarily show the webview onscreen because annoyingly without
    // doing this also sometimes hangs
    func webViewHack() {
        Async.main {
            let window = UIApplication.shared.delegate!.window!
            if self.webView.superview == nil {
                print("WEBVIEW ADDED TO VIEW HIERARCHY")
                window?.addSubview(self.webView)
                window?.sendSubview(toBack: self.webView)
                Async.main(after: 2) {
                    print("WEBVIEW REMOVED FROM VIEW HIERARCHY")
                    self.webView.removeFromSuperview()
                }
            }
        }
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("didCommitNavigation")
        delegate?.webViewDriverProgress(true)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("didFinishNavigation")
        let url = webView.url!.absoluteString
        delegate?.webViewDriverProgress(false)
        pageLoaded(url)
    }

    func pageLoaded(_ url : String) {
        print("pageLoaded: \(url)")
        for flow in activeFlows {
            if flow.startActionForPage(url) {
                print("action started by \(flow)")
                return
            }
        }
    }

}
