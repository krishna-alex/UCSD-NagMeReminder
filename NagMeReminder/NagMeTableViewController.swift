//
//  NagMeTableViewController.swift
//  NagMeReminder
//
//  Created by Krishna Alex on 8/17/23.
//

import UIKit

protocol NagMeTableViewControllerDelegate: AnyObject {
    func nagMeTableViewController(_ controller: NagMeTableViewController, didSelect nagMe: NagMe)
}


class NagMeTableViewController: UITableViewController {
    
    weak var delegate: NagMeTableViewControllerDelegate?

    var nagMe : NagMe?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return NagMe.all.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NagMeCell", for: indexPath)

        let nagMe = NagMe.all[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = nagMe.type
        cell.contentConfiguration = content
        
        if nagMe == self.nagMe {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let nagMe = NagMe.all[indexPath.row]
        self.nagMe = nagMe
        delegate?.nagMeTableViewController(self, didSelect: nagMe)
        tableView.reloadData()
    }


}
