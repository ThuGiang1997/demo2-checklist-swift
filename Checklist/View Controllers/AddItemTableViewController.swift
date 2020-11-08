//
//  AddItemTableViewController.swift
//  Checklist
//
//  Created by Ha Giang on 10/5/20.
//

import UIKit

protocol AddItemViewControllerDelegate: class {
    
  func addItemViewControllerDidCancel(
                          _ controller: AddItemTableViewController)
  func addItemViewController(
                 _ controller: AddItemTableViewController,
         didFinishAdding item: ChecklistItem)
  func addItemViewController(
                    _ controller: AddItemTableViewController,
                    didFinishEditing item: ChecklistItem)
}

class AddItemTableViewController: UITableViewController, UITextFieldDelegate{
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var donebarbutton: UIBarButtonItem!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var datePickerCell: UITableViewCell!
    
    weak var delegate: AddItemViewControllerDelegate?
    var itemToEdit : ChecklistItem?
    var dueDate = Date()
    var datePickerVisible = false
    
    // MARK: - Action done and cancel
    @IBAction func done(_ sender: UIBarButtonItem) {
         if let item = itemToEdit {
            item.text = textField.text!
            item.shouldRemind = shouldRemindSwitch.isOn  // add this
            item.dueDate = dueDate
            item.scheduleNotification()
            delegate?.addItemViewController(self,
                          didFinishEditing: item)
          } else {
            let item = ChecklistItem()
            item.text = textField.text!
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = dueDate
            item.scheduleNotification()
            delegate?.addItemViewController(self, didFinishAdding: item)
          }
    }
    
    @IBAction func dateChange(_ sender: UIDatePicker) {
        dueDate = datePicker.date
        updateDueDateLabel()
    }
    @IBAction func shouldRemindToggled(_ switchControl: UISwitch) {
        textField.resignFirstResponder()
          if switchControl.isOn {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]) {
              granted, error in
            }
          }
    }
    @IBAction func mytextfield(_ sender: UITextField) {
        print("Contents of the text field: \(textField.text!)")
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        delegate?.addItemViewControllerDidCancel(self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        navigationItem.largeTitleDisplayMode = .never
        
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            donebarbutton.isEnabled = true
            shouldRemindSwitch.isOn = item.shouldRemind
            dueDate = item.dueDate
          }
        updateDueDateLabel()
    }

    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      textField.becomeFirstResponder()
    }
    
    // MARK: - Table view data source
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 2
//    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 && datePickerVisible {
          return 3
        } else {
          return super.tableView(tableView,
            numberOfRowsInSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView,
               heightForRowAt indexPath: IndexPath) -> CGFloat {
      if indexPath.section == 1 && indexPath.row == 2 {
        return 217
      } else {
        return super.tableView(tableView, heightForRowAt: indexPath)
      }
    }
    
    override func tableView(_ tableView: UITableView,
               didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
      textField.resignFirstResponder()
      if indexPath.section == 1 && indexPath.row == 1 {
        if !datePickerVisible {
              showDatePicker()
            } else {
              hideDatePicker()
            }
      }
    }
    
    override func tableView(_ tableView: UITableView,
              willSelectRowAt indexPath: IndexPath)
              -> IndexPath? {
        if indexPath.section == 1 && indexPath.row == 1 {
            return indexPath
          } else {
            return nil
          }
    }

    override func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath)
                 -> UITableViewCell {
      if indexPath.section == 1 && indexPath.row == 2 {
        return datePickerCell
      } else {
        return super.tableView(tableView, cellForRowAt: indexPath)
      }
    }
    
    override func tableView(_ tableView: UITableView,
      indentationLevelForRowAt indexPath: IndexPath) -> Int {
      var newIndexPath = indexPath
      if indexPath.section == 1 && indexPath.row == 2 {
        newIndexPath = IndexPath(row: 0, section: indexPath.section)
      }
      return super.tableView(tableView,
              indentationLevelForRowAt: newIndexPath)
    }
    
    // MARK:- Text Field Delegates
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

      let oldText = textField.text!
      let stringRange = Range(range, in:oldText)!
      let newText = oldText.replacingCharacters(in: stringRange,
                                              with: string)
        if newText.isEmpty {
        donebarbutton.isEnabled = false
      } else {
        donebarbutton.isEnabled = true
      }
      return true
    }
    
   
    // MARK:- Helper Methods
    func updateDueDateLabel() {
      let formatter = DateFormatter()
      formatter.dateStyle = .medium
      formatter.timeStyle = .short
      dueDateLabel.text = formatter.string(from: dueDate)
    }
    
    func showDatePicker() {
      datePickerVisible = true
      let indexPathDatePicker = IndexPath(row: 2, section: 1)
      tableView.insertRows(at: [indexPathDatePicker], with: .fade)
      datePicker.setDate(dueDate, animated: false)
      dueDateLabel.textColor = dueDateLabel.tintColor
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
      donebarbutton.isEnabled = false
      return true
    }
    
    func hideDatePicker() {
      if datePickerVisible {
        datePickerVisible = false
        let indexPathDatePicker = IndexPath(row: 2, section: 1)
        tableView.deleteRows(at: [indexPathDatePicker], with: .fade)
        dueDateLabel.textColor = UIColor.black
      }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
      hideDatePicker()
    }
}
