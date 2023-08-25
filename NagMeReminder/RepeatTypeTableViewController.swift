//
//  RepeatTypeTableViewController.swift
//  NagMeReminder
//
//  Created by Krishna Alex on 8/25/23.
//

import UIKit

protocol RepeatTypeTableViewControllerDelegate: AnyObject {
    func repeatTypeTableViewController(_ controller: RepeatTypeTableViewController, didSelect repeatType: RepeatType)
}

class RepeatTypeTableViewController: UITableViewController {
    
    weak var delegate: RepeatTypeTableViewControllerDelegate?

    var repeatType : RepeatType?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return RepeatType.all.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepeatTypeCell", for: indexPath)

        let repeatType = RepeatType.all[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = repeatType.type
        cell.contentConfiguration = content
        
        if repeatType == self.repeatType {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let repeatType = RepeatType.all[indexPath.row]
        self.repeatType = repeatType
        delegate?.repeatTypeTableViewController(self, didSelect: repeatType)
        tableView.reloadData()
    }

}
