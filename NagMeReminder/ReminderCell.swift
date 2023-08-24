//
//  ReminderCell.swift
//  NagMeReminder
//
//  Created by Krishna Alex on 8/23/23.
//

import UIKit

protocol ReminderCellDelegate: AnyObject {
    func checkmarkTapped(sender: ReminderCell)
}

class ReminderCell: UITableViewCell {

    @IBOutlet weak var alarmLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var isDoneButton: UIButton!
    
    weak var delegate: ReminderCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func doneButtonTapped(_ sender: UIButton) {
        delegate?.checkmarkTapped(sender: self)
        
    }
    
}
