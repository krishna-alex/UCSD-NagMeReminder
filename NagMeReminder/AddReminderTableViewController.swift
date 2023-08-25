//
//  AddReminderTableViewController.swift
//  NagMeReminder
//
//  Created by Krishna Alex on 8/17/23.
//

import UIKit
import UserNotifications


class AddReminderTableViewController: UITableViewController, NagMeTableViewControllerDelegate, RepeatTypeTableViewControllerDelegate {
    
    
        
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var nagMeLabel: UILabel!
    
    @IBOutlet weak var repeatTypeLabel: UILabel!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var alarmPicker: UIDatePicker!
    @IBOutlet weak var alarmLabel: UILabel!
    @IBOutlet weak var notesTextField: UITextView!
    
    @IBOutlet weak var nagMeTableViewCell: UITableViewCell!
    @IBOutlet weak var repeatTypeTableViewCell: UITableViewCell!
    
    var isAlarmPickerHidden = true
    let alarmLabelIndexPath = IndexPath(row: 0, section: 1)
    let alarmPickerIndexPath = IndexPath(row: 1, section: 1)
    //let nagMeIndexPath = IndexPath(row: 0, section: 2)
    let notesIndexPath = IndexPath(row: 0, section: 3)
   
    var reminder: Reminder?
    var nagMe: NagMe?
    var repeatType: RepeatType?
    
    func nagMeTableViewController(_ controller: NagMeTableViewController, didSelect nagMe: NagMe) {
        self.nagMe = nagMe
        updateNagMe()
        updateAlarmLabel(date: alarmPicker.date)
    }
    
    func repeatTypeTableViewController(_ controller: RepeatTypeTableViewController, didSelect repeatType: RepeatType) {
        self.repeatType = repeatType
        updateRepeatType()
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
            repeatTypeLabel.text = reminder.repeatType.type
            notesTextField.text = reminder.notes
            repeatTypeTableViewCell.isUserInteractionEnabled = false
        } else {
            alarmDate = Date().addingTimeInterval(24*60*60)
        }
        alarmPicker.date = alarmDate
        
        updateSaveButtonState()
        updateAlarmLabel(date: alarmDate)

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
        let repeatTypeReminder = repeatType ?? RepeatType(id: 0, type: "Never")
        let notes = notesTextField.text ?? ""
        
        if reminder != nil {
            reminder?.title = title
            // reminder?.isComplete = isComplete
            reminder?.alarm = alarm
            reminder?.nagMe = nagMeReminder
            reminder?.repeatType = repeatTypeReminder
            reminder?.notes = notes
        } else {
            reminder = Reminder(title: title, isComplete: false, alarm: alarm, nagMe: nagMeReminder, repeatType: repeatTypeReminder, notes: notes)
            
        }
        
        //Setup Notification for the reminder
        
       // let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = title
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        //let dtestyle =
        content.body = "Reminder set for \(dateFormatter.string(from: alarm))"
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "yourIdentifier"
        // content.userInfo = ["example": "information"] // You can retrieve this when displaying notification
        
        
        var triggerComponents1 = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date(timeInterval: 10, since: alarm))
        triggerComponents1.calendar = Calendar.current
        
        //Schedule first alarm
        reminderAlarm(content: content, fromDate: triggerComponents1)
        
        //Find frequencey for nag me reminders
        let frequency: Int
        let timeUnit: Calendar.Component
        switch nagMeReminder.id {
        case 1:
            frequency = 5
            timeUnit = .minute
        case 2:
            frequency = 15
            timeUnit = .minute
        case 3:
            frequency = 30
            timeUnit = .minute
        case 4:
            frequency = 60
            timeUnit = .minute
        case 5:
            frequency = 1
            timeUnit = .day
        default:
            return
        }
        
        print("nagMeReminder.id \(nagMeReminder.id)")
        if(nagMeReminder.id > 0 && nagMeReminder.id <= 5) {
            scheduleReminders(content: content, fromDate: triggerComponents1, repeatCount: 10, every: frequency, unit: timeUnit)
        }
        
    }
    
    func reminderAlarm(content: UNNotificationContent, fromDate dateComponents: DateComponents) {
        let calendar = Calendar.current
        guard let triggerDate = dateComponents.date else { fatalError() }
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false) // Create request
        let uniqueID = (reminder?.id.uuidString)!
        let request = UNNotificationRequest(identifier: uniqueID, content: content, trigger: trigger)
        print("Inside reminderAlarm \(request)")
        UNUserNotificationCenter.current().add(request) // Add the notification request
        
    }
        
        func scheduleReminders(content: UNNotificationContent, fromDate dateComponents: DateComponents, repeatCount: Int, every: Int = 1, unit: Calendar.Component = .minute) {
            
            let calendar = Calendar.current
           
            guard let triggerDate = dateComponents.date else { fatalError() }
            for count in 1 ..< repeatCount {
                // Add the reminder interval and unit to the original notification
                guard let date = calendar.date(byAdding: unit, value: every * count, to: triggerDate)  else { fatalError() }
                
                let reminderDateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
                print (reminderDateComponents)
                    let reminderTrigger = UNCalendarNotificationTrigger(dateMatching: reminderDateComponents, repeats: false)
                addNotification(content: content, trigger: reminderTrigger , identifier: "\(count),\(reminder!.id.uuidString)")
                    
                }
            }

    func addNotification(content: UNNotificationContent, trigger: UNNotificationTrigger, identifier: String) {
        //print("Scheduling notification at \(trigger)")
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        // Add the notification request
        print("Scheduling notification at \(request)")
        UNUserNotificationCenter.current().add(request) {(error) in
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
    
    func updateRepeatType() {
        if let repeatType = repeatType {
            repeatTypeLabel.text = repeatType.type
        } else {
            repeatTypeLabel.text = "Never"
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
    
    @IBSegueAction func selectRepeatType(_ coder: NSCoder, sender: Any?) -> RepeatTypeTableViewController? {
        let selectRepeatTypeController = RepeatTypeTableViewController(coder: coder)
        selectRepeatTypeController?.delegate = self
        selectRepeatTypeController?.repeatType = repeatType
        return selectRepeatTypeController
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
