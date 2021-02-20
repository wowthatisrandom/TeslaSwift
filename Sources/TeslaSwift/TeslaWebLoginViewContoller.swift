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
    
    let viewHeight:CGFloat = 720
    let viewWidth:CGFloat = 600

    let everythingView = NSView()
    var webView = WKWebView()
    let bullshitView = NSBox()

    let whyLabel = NSTextField()
    let usernameLabel = NSTextField()
    let username = NSTextField()
    let passwordLabel = NSTextField()
    let password = NSSecureTextField()
    
    let mfaLabel = NSTextField()
    let mfaKey = NSTextField()

    let cpLogin = NSButton()
    let mfaBtn = NSButton()

    var result: ((Result<URL, Error>) -> ())?

    required init?(coder: NSCoder) {
        fatalError("not supported")
    }

    init(url: URL) {
        super.init(nibName: nil, bundle: nil)
        webView.navigationDelegate = self
        
        let request = NSMutableURLRequest(url: url)
//        request.setValue("auth.tesla.com", forHTTPHeaderField: "Host")
        request.setValue("deflate, gzip, br", forHTTPHeaderField:"Accept-Encoding")
        request.setValue("text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", forHTTPHeaderField:"Accept")
        request.setValue("Mozilla/5.0 (Windows NT 6.2; Win64; x64) AppleWebKit/605.1.15 (KHTML, like Gecko)", forHTTPHeaderField:"User-Agent")
        request.setValue("en-US", forHTTPHeaderField:"Accept-Language")

        webView.load(request as URLRequest)
        
        bullshitView .frame = NSMakeRect(0, viewHeight * 0.8, viewWidth, viewHeight * 0.2)
        bullshitView .titlePosition = .noTitle
        bullshitView .boxType = .custom
//        bullshitView .fillColor = .red
        bullshitView .borderType = .noBorder
        
        whyLabel .frame = NSMakeRect(20, 70, viewWidth * 0.9, 60)
        whyLabel .stringValue = "Due to a bug in the tesla auth page, we are offering a way for you to see what you are typing. If you are not comfortable typing your information here you can enter in the website below. NOTE* the site will NOT show you typing. once complete click submit."
        whyLabel .isEditable = false
        whyLabel .isSelectable = false
        whyLabel .drawsBackground = false
        whyLabel .isBezeled = false
        whyLabel .isBordered = false
        whyLabel .textColor = .black
        whyLabel .alignment = .center
        

        usernameLabel .frame = NSMakeRect(0, 60, 100, 14)
        usernameLabel .stringValue = "Email Address:"
        usernameLabel .isEditable = false
        usernameLabel .isSelectable = false
        usernameLabel .drawsBackground = false
        usernameLabel .isBezeled = false
        usernameLabel .isBordered = false
        usernameLabel .textColor = .black
        usernameLabel .alignment = .right
        
        username .frame = NSMakeRect(115, 58, 200, 20)
        username .isBezeled = false
        username .isBordered = false
        username .usesSingleLineMode = true
        
        passwordLabel .frame = NSMakeRect(0, 32, 100, 14)
        passwordLabel .stringValue = "Password:"
        passwordLabel .isEditable = false
        passwordLabel .isSelectable = false
        passwordLabel .drawsBackground = false
        passwordLabel .isBezeled = false
        passwordLabel .isBordered = false
        passwordLabel .textColor = .black
        passwordLabel .alignment = .right
        
        password .frame = NSMakeRect(115, 30, 200, 20)
        password .isBezeled = false
        password .isBordered = false
        password .usesSingleLineMode = true

        cpLogin .frame = NSMakeRect(115, -5, 200, 32)
        cpLogin .title = "Insert Username and Password"
        cpLogin .isBordered = true
        cpLogin .setButtonType(.momentaryPushIn)
        cpLogin .bezelStyle = .rounded
        cpLogin .action = #selector(self.copyClicked)
        
        mfaLabel .frame = NSMakeRect(360, 50, 200, 14)
        mfaLabel .stringValue = "Multi Factor Key:"
        mfaLabel .isEditable = false
        mfaLabel .isSelectable = false
        mfaLabel .drawsBackground = false
        mfaLabel .isBezeled = false
        mfaLabel .isBordered = false
        mfaLabel .textColor = .black
        mfaLabel .alignment = .center
        
        mfaKey .frame = NSMakeRect(360, 28, 200, 20)
        mfaKey .isBezeled = false
        mfaKey .isBordered = false

        mfaBtn .frame = NSMakeRect(360, -5, 200, 32)
        mfaBtn .title = "Copy MFA Key"
        mfaBtn .isBordered = true
        mfaBtn .setButtonType(.momentaryPushIn)
        mfaBtn .bezelStyle = .rounded
        mfaBtn .action = #selector(self.mfaClicked)
        
        
        webView .frame = NSMakeRect(0, 0, viewWidth, viewHeight * 0.8)

        bullshitView .addSubview(whyLabel)
        bullshitView .addSubview(usernameLabel)
        bullshitView .addSubview(username)
        bullshitView .addSubview(passwordLabel)
        bullshitView .addSubview(password)
        bullshitView.addSubview(cpLogin)
        
        bullshitView .addSubview(mfaLabel)
        bullshitView .addSubview(mfaKey)
        bullshitView.addSubview(mfaBtn)

        everythingView .addSubview(bullshitView)
        everythingView .addSubview(webView)
    }

    override public func loadView() {
        view = everythingView
    }
    
    @objc func copyClicked() -> Void {
        let magic = "try { document.querySelector('#form-input-identity').value = '\(username.stringValue)'; } catch (err) { } try { document.querySelector('#form-input-credential').value = '\(password.stringValue)'; } catch (err) {} try { var plButton = document.querySelector(\"button[type*='submit']\");  if (plButton == null) {    plButton = document.querySelector(\"*[id*='form-submit-continue']\");  }} catch (err) { }plButton.click();"
        
        webView .evaluateJavaScript(magic, completionHandler: nil)
      }
    
    @objc func mfaClicked() -> Void {
        let magic = "try { document.querySelector('#form-input-passcode').value = '\(mfaKey.stringValue)'; } catch (err) { } try { var plButton = document.querySelector(\"button[type*='submit']\");  if (plButton == null) {    plButton = document.querySelector(\"*[id*='form-submit']\");  }} catch (err) { }plButton.click();"
        
        webView .evaluateJavaScript(magic, completionHandler: nil)
      }
}



extension TeslaWebLoginViewContoller: WKNavigationDelegate {

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
