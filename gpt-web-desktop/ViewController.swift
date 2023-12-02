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
    
    static var supportsSecureCoding: Bool {
        return true
    }
}

class MyViewController: NSViewController, WKNavigationDelegate {
    
    @IBOutlet weak var myWebView: WKWebView!
    
    // var selectedWebsite: String?
    
    private let windowSizeKey = "ChatGPTWindowSize"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the WKWebView delegate to self
        myWebView.navigationDelegate = self

        // Load the ChatGPT webpage
        // if let website = selectedWebsite {
        if let website = targetWebsite{
            loadURL(website)
        } else {
            loadURL("https://www.chatgpt.com/")
            UserDefaults.standard.set("ChatGPT", forKey: "SelectedWebsite")
        }

        // Set the window size based on the stored size in UserDefaults
        do {
            try setWindowSize()
        } catch {
            print("Error setting window size: \(error)")
        }
        
        // Restore Window State
        restoreWindowState()
    }
    
    // Load URL
    func loadURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            myWebView.load(request)
        }
    }

    // Set Window Size
    private func setWindowSize() throws {
        let userDefaults = UserDefaults.standard

        // Check if the window size is stored in UserDefaults
        if let storedSizeData = userDefaults.data(forKey: windowSizeKey),
            let unarchivedSizeWrapper = try NSKeyedUnarchiver.unarchivedObject(ofClass: SizeWrapper.self, from: storedSizeData) {

            // Set the window size
            self.view.window?.setContentSize(unarchivedSizeWrapper.size)
        }
    }

    // Save Window Size
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
    
    // Save Window State
    private func saveWindowState() {
        let userDefaults = UserDefaults.standard

        // Save the window size and position to UserDefaults
        if let window = self.view.window {
            let windowFrame = window.frame
            let windowState = [
                "x": windowFrame.origin.x,
                "y": windowFrame.origin.y,
                "width": windowFrame.size.width,
                "height": windowFrame.size.height
            ]
            userDefaults.set(windowState, forKey: "WindowFrame")
        }
    }
    
    // Restore Window State
    private func restoreWindowState() {
        let userDefaults = UserDefaults.standard

        // Check if window state is stored in UserDefaults
        if let windowState = userDefaults.dictionary(forKey: "WindowFrame"),
            let x = windowState["x"] as? CGFloat,
            let y = windowState["y"] as? CGFloat,
            let width = windowState["width"] as? CGFloat,
            let height = windowState["height"] as? CGFloat {

            // Set the window size and position
            if let window = self.view.window {
                let newFrame = NSRect(x: x, y: y, width: width, height: height)
                window.setFrame(newFrame, display: true)
            }
        }
    }

    override func viewWillDisappear() {
        super.viewWillDisappear()
        saveWindowSize()
        saveWindowState()
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
