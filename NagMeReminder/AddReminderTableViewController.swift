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
    
    var isAlarmPickerHidden = true
    let alarmLabelIndexPath = IndexPath(row: 0, section: 1)
    let alarmPickerIndexPath = IndexPath(row: 1, section: 1)
    //let nagMeIndexPath = IndexPath(row: 0, section: 2)
    let notesIndexPath = IndexPath(row: 0, section: 3)
   
    var nagMe: NagMe?
    
    func nagMeTableViewController(_ controller: NagMeTableViewController, didSelect nagMe: NagMe) {
        self.nagMe = nagMe
        updateNagMe()
        updateAlarmLabel(date: alarmPicker.date)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alarmLabel.text = alarmPicker.date.formatted(date: .abbreviated, time: .shortened)
        updateNagMe()
        updateSaveButtonState()
        updateAlarmLabel(date: alarmPicker.date)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView,
       heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case alarmPickerIndexPath where isAlarmPickerHidden == true:
            return 0
        case notesIndexPath:
            return 200
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case alarmPickerIndexPath:
            return 216
        case notesIndexPath:
            return 200
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath == alarmLabelIndexPath {
            isAlarmPickerHidden.toggle()
            updateAlarmLabel(date: alarmPicker.date)
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    func updateNagMe() {
        if let nagMe = nagMe {
            nagMeLabel.text = nagMe.type
        } else {
            nagMeLabel.text = "Off"
        }
    }
    
    //Update save button state depending on text field.
    func updateSaveButtonState() {
        let shouldEnableSaveButton = titleTextField.text?.isEmpty == false
        saveButton.isEnabled = shouldEnableSaveButton
    }
    
    
    func updateAlarmLabel(date: Date) {
        alarmLabel.text = date.formatted(date: .abbreviated, time: .shortened)
    }
    
    @IBSegueAction func selectNagMe(_ coder: NSCoder) -> NagMeTableViewController? {
        let selectNagMeController = NagMeTableViewController(coder: coder)
        selectNagMeController?.delegate = self
        selectNagMeController?.nagMe = nagMe
        return selectNagMeController
    }
    
    //Enable save button when title changed.
    @IBAction func titleTextEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    // Dismiss keyboard on return.
    @IBAction func returnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    
    @IBAction func alarmDatePickerValueChanged(_ sender: UIDatePicker) {
        updateAlarmLabel(date: sender.date)
        
    }
    
    @IBAction func saveBarButtonTapped(_ sender: UIBarButtonItem) {
        
        let title = titleTextField.text ?? ""
        let alarm = alarmPicker.date
        let nagMeOption = nagMe?.type ?? "Off"
        let notes = notesTextField.text
    }
    
    
    
}   
