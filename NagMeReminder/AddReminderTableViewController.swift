//
//  AddReminderTableViewController.swift
//  NagMeReminder
//
//  Created by Krishna Alex on 8/17/23.
//

import UIKit
import UserNotifications


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
   
    var reminder: Reminder?
    var nagMe: NagMe?
    
    func nagMeTableViewController(_ controller: NagMeTableViewController, didSelect nagMe: NagMe) {
        self.nagMe = nagMe
        updateNagMe()
        updateAlarmLabel(date: alarmPicker.date)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let alarmDate: Date
        if let reminder = reminder {
            print("inside edit")
            print (reminder)
            navigationItem.title = "Reminder"
            titleTextField.text = reminder.title
            //isCompleteButton.isSelected = toDo.isComplete
            alarmDate = reminder.alarm
            print("reminder.nagMe.type \(reminder.nagMe.type)")
            nagMeLabel.text = reminder.nagMe.type
            notesTextField.text = reminder.notes
        } else {
            alarmDate = Date().addingTimeInterval(24*60*60)
        }
        alarmPicker.date = alarmDate
        //alarmLabel.text = alarmPicker.date.formatted(date: .abbreviated, time: .shortened)
        
       // updateNagMe()
        updateSaveButtonState()
        updateAlarmLabel(date: alarmDate)

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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "saveUnwind" else { return }
        
        let title = titleTextField.text!
        //let isComplete = isCompleteButton.isSelected
        let alarm = alarmPicker.date
        let nagMeReminder = nagMe ?? NagMe(id: 0, type: "Off")
        let notes = notesTextField.text ?? ""
        
        if reminder != nil {
            reminder?.title = title
           // reminder?.isComplete = isComplete
            reminder?.alarm = alarm
            reminder?.nagMe = nagMeReminder
            reminder?.notes = notes
        } else {
            reminder = Reminder(title: title, isComplete: false, alarm: alarm, nagMe: nagMeReminder, notes: notes)
            
        }
        
        setupReminderNotification(title: title, alarm: alarm)
    }
    
    func setupReminderNotification(title: String, alarm: Date) {
        
        print("inside notification")
        let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = title
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        //let dtestyle =
        content.body = "Reminder set for \(dateFormatter.string(from: alarm))"
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "yourIdentifier"
        content.userInfo = ["example": "information"] // You can retrieve this when displaying notification

        // Setup trigger time
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        let reminderNotificationDate = alarm // Set this to whatever date you need
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: reminderNotificationDate), repeats: false)

        // Create request
        let uniqueID = UUID().uuidString // Keep a record of this if necessary
        let request = UNNotificationRequest(identifier: uniqueID, content: content, trigger: trigger)
        // Add the notification request
        center.add(request) {(error) in
            if let error = error {
                print("Uh oh! Notification had an error: \(error)")
            }
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
    
 /*   @IBAction func saveBarButtonTapped(_ sender: UIBarButtonItem) {
        
        let title = titleTextField.text ?? ""
        let alarm = alarmPicker.date
        let nagMeOption = nagMe
        //guard let nagMeOption = nagMe else {return nil}
        let notes = notesTextField.text
    }*/
    
    
    
}   
