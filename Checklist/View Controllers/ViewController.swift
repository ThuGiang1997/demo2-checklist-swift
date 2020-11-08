//
//  ViewController.swift
//  Checklist
//
//  Created by Ha Giang on 10/4/20.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddItemViewControllerDelegate {
    
    @IBOutlet weak var myTable: UITableView!
    
   // var items = [ChecklistItem]()
    var checklist : Checklist!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.delegate = self
        myTable.dataSource = self
//        // Enable large titles
//        navigationController?.navigationBar.prefersLargeTitles = true
        // Disable large titles for this view controller
        navigationItem.largeTitleDisplayMode = .never
        
//        let item0 = ChecklistItem()
//          item0.text = "Walk the dog"
//        checklist.items.append(item0)
//
//        let item1 = ChecklistItem()
//        item1.text = "Brush my teeth"
//        checklist.items.append(item1)
//
//        let item2 = ChecklistItem()
//        item2.text = "Learn IOS development"
//        checklist.items.append(item2)
//
//        let item3 = ChecklistItem()
//        item3.text = "Soccer practice"
//        checklist.items.append(item3)
        
        title = checklist.name
   
    }
    
    @IBAction func addItem() {
        let newRowIndex = checklist.items.count

          let item = ChecklistItem()
          item.text = "I am a new row"
        checklist.items.append(item)

          let indexPath = IndexPath(row: newRowIndex, section: 0)
          let indexPaths = [indexPath]
          myTable.insertRows(at: indexPaths, with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTable.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        let item = checklist.items[indexPath.row]
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView,
               didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = checklist.items[indexPath.row]
            item.toggleChecked()
            configureCheckmark(for: cell, with: item)
          }
      tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func configureText(for cell: UITableViewCell,
                      with item: ChecklistItem) {
        
          let label = cell.viewWithTag(1000) as! UILabel
          label.text = "\(item.itemID): \(item.text)"
    }
    
    func configureCheckmark(for cell: UITableViewCell,
                            with item: ChecklistItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        if item.checked {
            label.text = "√"
        } else {
            label.text = ""
      }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //Remove the item from the data model.
        checklist.items.remove(at: indexPath.row)
        //Delete the corresponding row from the table view.
        let indexPaths = [indexPath]
        myTable.deleteRows(at: indexPaths, with: .automatic)
    }
    
    func addItemViewControllerDidCancel(
                           _ controller: AddItemTableViewController) {
      navigationController?.popViewController(animated:true)
    }

    func addItemViewController(
                   _ controller: AddItemTableViewController,
           didFinishAdding item: ChecklistItem) {
        
        let newRowIndex = checklist.items.count
        checklist.items.append(item)
          let indexPath = IndexPath(row: newRowIndex, section: 0)
          let indexPaths = [indexPath]
          myTable.insertRows(at: indexPaths, with: .automatic)
          navigationController?.popViewController(animated:true)
       
    }
    

    func addItemViewController(
                  _ controller: AddItemTableViewController,
         didFinishEditing item: ChecklistItem) {
        
        if let index = checklist.items.firstIndex(of: item) {
        let indexPath = IndexPath(row: index, section: 0)
        if let cell = myTable.cellForRow(at: indexPath) {
          configureText(for: cell, with: item)
        }
      }
      navigationController?.popViewController(animated:true)
      
    }
    
    override func prepare(for segue: UIStoryboardSegue,
                             sender: Any?) {
        
        if segue.identifier == "AddItem" {
        let controller = segue.destination as! AddItemTableViewController
        controller.delegate = self
      }else if segue.identifier == "EditItem" {
        let controller = segue.destination as! AddItemTableViewController
        controller.delegate = self
        if let indexPath = myTable.indexPath(for: sender as! UITableViewCell) {
            controller.itemToEdit = checklist.items[indexPath.row]
        }
      }
    }
    

}

