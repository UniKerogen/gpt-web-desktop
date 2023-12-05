//
//  HelpViewController.swift
//  gpt-web-desktop
//
//  Created by Kuang Jiang on 12/4/23.
//

import Cocoa

class HelpViewController: NSViewController {
    
    var helpWindowController: NSWindowController?
    
    @IBOutlet weak var tableView: NSScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Additional setup code if needed
        print("Tips Loaded")
    }
}

extension HelpViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        // Return the number of rows you want in the table view
        return 3 // Replace with the actual number of rows
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        // Provide the view for each cell in the table view
        if let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("MyCell"), owner: self) as? NSTableCellView {
            // Customize the cell view here
            cellView.textField?.stringValue = "Row \(row + 1)"
            return cellView
        }
        return nil
    }
}
