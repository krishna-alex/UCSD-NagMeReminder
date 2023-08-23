//
//  AddReminderTableViewController.swift
//  NagMeReminder
//
//  Created by Krishna Alex on 8/17/23.
//

import UIKit



class AddReminderTableViewController: UITableViewController, NagMeTableViewControllerDelegate {
        
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var nagMeLabel: UILabel!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var alarmPicker: UIDatePicker!
    @IBOutlet weak var alarmLabel: UILabel!
    @IBOutlet weak var notesTextField: UITextView!
    
    var nagMe: NagMe?
    
    func nagMeTableViewController(_ controller: NagMeTableViewController, didSelect nagMe: NagMe) {
        self.nagMe = nagMe
        updateNagMe()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alarmLabel.text = alarmPicker.date.formatted(date: .abbreviated, time: .shortened)
        updateNagMe()
        updateSaveButtonState()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    
    func updateNagMe() {
        if let nagMe = nagMe {
            nagMeLabel.text = nagMe.type
        } else {
            nagMeLabel.text = "Off"
        }
    }
    
    func updateSaveButtonState() {
        let shouldEnableSaveButton = titleTextField.text?.isEmpty == false
        saveButton.isEnabled = shouldEnableSaveButton
    }
    
    @IBSegueAction func selectNagMe(_ coder: NSCoder) -> NagMeTableViewController? {
        let selectNagMeController = NagMeTableViewController(coder: coder)
        selectNagMeController?.delegate = self
        selectNagMeController?.nagMe = nagMe
        return selectNagMeController
    }
    
    @IBAction func titleTextEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    @IBAction func alarmDatePickerValueChanged(_ sender: Any) {
        alarmLabel.text = alarmPicker.date.formatted(date: .abbreviated, time: .shortened)
        
    }
    
    @IBAction func saveBarButtonTapped(_ sender: UIBarButtonItem) {
        
        let title = titleTextField.text ?? ""
        let alarm = alarmPicker.date
        let nagMeOption = nagMe?.type ?? "Off"
        let notes = notesTextField.text
    }
    
    
}   
