//
//  PreferencesViewController.swift
//  gpt-web-desktop
//
//  Created by Kuang Jiang on 12/1/23.
//

import Cocoa

class PreferencesViewController: NSViewController {
    
    @IBOutlet weak var tabView: NSTabView!
    @IBOutlet weak var websitesTableView: NSTableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up tab view delegate
        tabView.delegate = self
    }

    // Implement NSTabViewDelegate methods if needed

    @IBAction func closePreferences(_ sender: Any) {
        // Close the preferences window
        view.window?.close()
    }
}
