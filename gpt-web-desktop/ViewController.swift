//
//  ViewController.swift
//  gpt-web-desktop
//
//  Created by Kuang Jiang on 11/30/23.
//

import Cocoa
import WebKit

class SizeWrapper: NSObject, NSCoding, NSSecureCoding {
    var size: NSSize

    init(size: NSSize) {
        self.size = size
    }

    required init?(coder aDecoder: NSCoder) {
        size = aDecoder.decodeSize(forKey: "size")
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(size, forKey: "size")
    }
    
    // MARK: - NSSecureCoding
    
    static var supportsSecureCoding: Bool {
        return true
    }
}

class MyViewController: NSViewController, WKNavigationDelegate {

    @IBOutlet weak var myWebView: WKWebView!

    private let windowSizeKey = "ChatGPTWindowSize"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the WKWebView delegate to self
        myWebView.navigationDelegate = self

        // Load the ChatGPT webpage
        if let url = URL(string: "https://www.chatgpt.com/") {
            let request = URLRequest(url: url)
            myWebView.load(request)
        }

        // Set the window size based on the stored size in UserDefaults
        do {
            try setWindowSize()
        } catch {
            print("Error setting window size: \(error)")
        }
    }

    private func setWindowSize() throws {
        let userDefaults = UserDefaults.standard

        // Check if the window size is stored in UserDefaults
        if let storedSizeData = userDefaults.data(forKey: windowSizeKey),
            let unarchivedSizeWrapper = try NSKeyedUnarchiver.unarchivedObject(ofClass: SizeWrapper.self, from: storedSizeData) {

            // Set the window size
            self.view.window?.setContentSize(unarchivedSizeWrapper.size)
        }
    }

    private func saveWindowSize() {
        let userDefaults = UserDefaults.standard

        // Save the window size to UserDefaults
        if let windowSize = self.view.window?.contentView?.frame.size {
            let sizeWrapper = SizeWrapper(size: windowSize)

            do {
                let archivedSizeData = try NSKeyedArchiver.archivedData(withRootObject: sizeWrapper, requiringSecureCoding: false)
                userDefaults.set(archivedSizeData, forKey: windowSizeKey)
            } catch {
                print("Error saving window size: \(error)")
            }
        }
    }

    override func viewWillDisappear() {
        super.viewWillDisappear()
        saveWindowSize()
    }

    // MARK: - WKNavigationDelegate

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Set the window title to the title of the loaded webpage
        webView.evaluateJavaScript("document.title") { [weak self] (result, error) in
            if let title = result as? String {
                self?.view.window?.title = title
            }
        }
    }
}
