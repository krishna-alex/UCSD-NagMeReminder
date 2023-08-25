//
//  ReminderTableViewController.swift
//  NagMeReminder
//
//  Created by Krishna Alex on 8/15/23.
//

import UIKit
import UserNotifications

class ReminderTableViewController: UITableViewController, ReminderCellDelegate {
    
    var reminders = [Reminder]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        
        if let savedReminders = Reminder.loadReminders() {
                reminders = savedReminders
            } else {
                reminders = Reminder.loadSampleReminders()
            }
        
       /* if activeTabBar.isEnabled {
            reminders = Reminder.loadReminders()!
        } else {
            reminders = Reminder.loadSampleReminders()
        }*/
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return reminders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCellIdentifier", for: indexPath) as! ReminderCell

        let reminder = reminders[indexPath.row]
        cell.alarmLabel.text = reminder.alarm.formatted(date: .abbreviated, time: .shortened)
        cell.titleLabel.text = reminder.title
        cell.isDoneButton.isSelected = reminder.isComplete
        if reminder.alarm < Date() {
            cell.alarmLabel.textColor = .red
            cell.titleLabel.textColor = .red
        }
        //var content = cell.defaultContentConfiguration()
       // content.text = reminder.title
      //  cell.contentConfiguration = content
        cell.delegate = self
        return cell
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let reminder = reminders[indexPath.row]
            let notificationId = reminder.id.uuidString
            reminders.remove(at: indexPath.row)
            //let reminder = reminders[indexPath.row]
            tableView.deleteRows(at: [indexPath], with: .fade)
            Reminder.saveReminders(reminders)
            
            // Delete corresponding notification for deleted reminder
             let center = UNUserNotificationCenter.current()
             center.getPendingNotificationRequests { (notificationRequests) in
                    var identifiers: [String] = []
                    print("inside notification delete")
                    for notification:UNNotificationRequest in notificationRequests {
                        if notification.identifier == notificationId {
                           identifiers.append(notification.identifier)
                        }
                    }
                 center.removePendingNotificationRequests(withIdentifiers: identifiers)
                 }
            
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //
    @IBAction func unwindToReminderList(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind" else { return }
        let sourceViewController = segue.source as! AddReminderTableViewController
        
        if let reminder = sourceViewController.reminder {
            
            if let indexOfExistinReminder = reminders.firstIndex(of: reminder) {
                reminders[indexOfExistinReminder] = reminder
                tableView.reloadRows(at: [IndexPath(row: indexOfExistinReminder, section: 0)], with: .automatic)
            } else {
                //let newIndexPath = IndexPath(row: reminders.count, section: 0)
                
                //Adding new Reminder.
                print(reminder)
                reminders.append(reminder)
                tableView.reloadData()
                
                // If new reminder has repeatType. (Daily, monthly, yearly)
                let repeatFrequency = reminder.repeatType.id
                if repeatFrequency > 0 && repeatFrequency < 4 {
                    let frequencyUnit = checkRepeatType(repeatFrequency: repeatFrequency)
                    let reminderDate = reminder.alarm
                    let calendar = Calendar.current
                    for count in 1 ..< 12 {
                        guard let repeatDate = calendar.date(byAdding: frequencyUnit, value: 1 * count, to: reminderDate)  else { fatalError() }
                        let recurringReminder = Reminder(title: reminder.title, isComplete: false, alarm: repeatDate, nagMe: reminder.nagMe, repeatType: reminder.repeatType, notes: reminder.notes)
                        print(recurringReminder)
                        reminders.append(recurringReminder)
                        
                        //Set reminder notiifcation for repeated reminders.
                        let content = UNMutableNotificationContent()
                        content.title = reminder.title
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateStyle = .medium
                        dateFormatter.timeStyle = .medium
                        //let dtestyle =
                        content.body = "Reminder set for \(dateFormatter.string(from: reminder.alarm))"
                        content.sound = UNNotificationSound.default
                        content.categoryIdentifier = "yourIdentifier"
                        // content.userInfo = ["example": "information"] // You can retrieve this when displaying notification
                        
                        
                        var repeatDateComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date(timeInterval: 10, since: reminder.alarm))
                        repeatDateComponent.calendar = Calendar.current
                        scheduleNotification(content: content, fromDate: repeatDateComponent, identifier: reminder.id.uuidString)
                        tableView.reloadData()
                    }
                }
            }
            
            
            Reminder.saveReminders(reminders)
        }
    }
    
    func scheduleNotification(content: UNNotificationContent, fromDate dateComponents: DateComponents, identifier: String){
        
            let calendar = Calendar.current
            guard let triggerDate = dateComponents.date else { fatalError() }
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false) // Create request
          //  let uniqueID = (reminder.id.uuidString)
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            print("Inside reminderAlarm for repeattype \(request)")
            UNUserNotificationCenter.current().add(request) // Add the notification request
    }
    
    @IBSegueAction func editReminder(_ coder: NSCoder, sender: Any?) -> AddReminderTableViewController? {
        let detailController = AddReminderTableViewController(coder: coder)
        guard let cell = sender as? UITableViewCell,
                let indexPath = tableView.indexPath(for: cell) else {
                return detailController
        }
        tableView.deselectRow(at: indexPath, animated: true)
        detailController?.reminder = reminders[indexPath.row]
        
        return detailController
    }
    
    func checkRepeatType(repeatFrequency: Int) -> Calendar.Component {
        var frequencyUnit: Calendar.Component = .day
        switch repeatFrequency {
                case 1 :
                    frequencyUnit = .day
                case 2:
                    frequencyUnit = .month
                case 3:
                    frequencyUnit = .year
                default:
                       return frequencyUnit
        }
        return frequencyUnit
            
    }
    
    func checkmarkTapped(sender: ReminderCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            var reminder = reminders[indexPath.row]
            reminder.isComplete.toggle()
            reminders[indexPath.row] = reminder
            tableView.reloadRows(at: [indexPath], with: .automatic)
            print("inside checkmark tapped \(reminder)")
            print(reminder.isComplete.toggle())
            reminders.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            Reminder.saveReminders(reminders)
            
            
           // Delete corresponding notification for deleted reminder
            let center = UNUserNotificationCenter.current()
            center.getPendingNotificationRequests { (notificationRequests) in
                   var identifiers: [String] = []
                   print("inside notification delete")
                   for notification:UNNotificationRequest in notificationRequests {
                      // print("inside notification delete loop1 \(notificationRequests)")
                      // print("reminder.id.uuidString \(reminder.id.uuidString)")
                    //   print("notification.identifier \(notification.identifier)")
                       
                       if notification.identifier.contains(reminder.id.uuidString) {
                         //  print("inside notification delete loop \(notification.identifier)")
                          identifiers.append(notification.identifier)
                           print("identifiers \(identifiers)")
                       }
                   }
                center.removePendingNotificationRequests(withIdentifiers: identifiers)
                }
            
        }
    }
    
    
}
