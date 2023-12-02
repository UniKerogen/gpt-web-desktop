//
//  PreferencesViewController.swift
//  gpt-web-desktop
//
//  Created by Kuang Jiang on 12/2/23.
//

import Cocoa

var targetWebsite: String?

class PreferencesViewController: NSViewController {

    @IBOutlet weak var websiteComboBox: NSComboBox!
    
    var preferencesWindowController: NSWindowController?
    
    // @IBOutlet var myViewController: MyViewController?

    // Add your website options here
    let websiteOptions = ["https://www.chatgpt.com/", "https://yiyan.baidu.com", "https://www.google.com"]

    override func viewDidLoad() {
        super.viewDidLoad()
        websiteComboBox.addItems(withObjectValues: websiteOptions)

        // Load saved preference or set a default value
        if let selectedWebsite = UserDefaults.standard.string(forKey: "SelectedWebsite") {
            websiteComboBox.stringValue = selectedWebsite
        } else {
            // Set a default website
            websiteComboBox.stringValue = websiteOptions.first ?? ""
        }
    }

    @IBAction func savePreferences(_ sender: Any) {
        // Save the selected website to UserDefaults
        UserDefaults.standard.set(websiteComboBox.stringValue, forKey: "SelectedWebsite")
        
        // Update the selected website in the existing window controller
        // myViewController?.selectedWebsite = websiteComboBox.stringValue
        targetWebsite = websiteComboBox.stringValue
    }
    
    @IBAction func showPreferencesWindow(_ sender: Any) {
        if preferencesWindowController == nil {
            let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
            preferencesWindowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("PreferencesWindowController")) as? NSWindowController
        }

        preferencesWindowController?.showWindow(sender)
    }
}
