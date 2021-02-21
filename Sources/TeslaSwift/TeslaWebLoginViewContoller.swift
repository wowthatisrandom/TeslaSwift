//
//  TeslaWebLoginViewContoller.swift
//  TeslaSwift
//
//  Created by João Nunes on 22/11/2020.
//  Copyright © 2020 Joao Nunes. All rights reserved.
//

#if canImport(WebKit)
import WebKit

public class TeslaWebLoginViewContoller: NSViewController {
    var webView = WKWebView()
    var result: ((Result<URL, Error>) -> ())?

    required init?(coder: NSCoder) {
        fatalError("not supported")
    }

    init(url: URL) {
        super.init(nibName: nil, bundle: nil)
        webView.navigationDelegate = self
        webView.load(URLRequest(url: url))
    }

    override public func loadView() {
        view = webView
    }
}

extension TeslaWebLoginViewContoller: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let magic = "var interval = setInterval(Timer, 1000); var foundMFA = 0; function Timer() { try { var availableFactors = document.querySelector('#available-factors'); if (document.body.contains(availableFactors)) { if (foundMFA === 0) { foundMFA = 1; var mfaDiv = document.querySelector('#container > div'); if (document.body.contains(mfaDiv)) { mfaDiv.style.setProperty('position', 'fixed', 'important'); } } } } catch (err) { console.log(err.message); } try { var inputIdentity = document.querySelector('#form-input-identity'); if (document.body.contains(inputIdentity)) { inputIdentity.style.setProperty('position', 'fixed', 'important'); inputIdentity.style.maxWidth = '280px'; inputIdentity.style.margin = '0 auto 0 auto'; } } catch (err) { console.log(err.message); } try { var inputCredential = document.querySelector('#form-input-credential'); if (document.body.contains(inputCredential)) { inputCredential.style.setProperty('position', 'fixed', 'important'); inputCredential.style.maxWidth = '280px'; inputCredential.style.margin = '0 auto 0 auto'; } } catch (err) { console.log(err.message); } try { var inputPasscode = document.querySelector('#form-input-passcode'); if (document.body.contains(inputPasscode)) { if (foundMFA === 1) { foundMFA = 2; var mfaDivRev = document.querySelector('#container > div'); if (document.body.contains(mfaDivRev)) { mfaDivRev.style.removeProperty(position); } } inputPasscode.focus(); inputPasscode.style.setProperty('position', 'fixed', 'important'); inputPasscode.style.maxWidth = '280px'; inputPasscode.style.margin = '0 auto 0 auto'; } } catch (err) { console.log(err.message); }}"
        
            webView .evaluateJavaScript(magic, completionHandler: nil)
    }

    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        if let url = navigationAction.request.url, url.absoluteString.starts(with: "https://auth.tesla.com/void/callback")  {
            decisionHandler(.cancel)
            
            let window:NSWindow = self.view.window!
            window.close()
            
            self.result?(Result.success(url))
        } else {
            decisionHandler(.allow)
        }
    }

    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.result?(Result.failure(TeslaError.authenticationFailed))
        
        let window:NSWindow = self.view.window!
        window.close()
    }

}
#endif
