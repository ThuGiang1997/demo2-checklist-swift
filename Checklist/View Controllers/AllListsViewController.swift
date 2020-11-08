//
//  AllListsViewController.swift
//  Checklist
//
//  Created by Ha Giang on 10/6/20.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var myCellList: UITableView!
    let cellIdentifier = "ChecklistCell"
    var dataModel: DataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var list = Checklist(name: "Birthdays")
//        dataModel.lists.append(list)
//        
//        list = Checklist(name: "Groceries")
//        dataModel.lists.append(list)
//        
//        list = Checklist(name: "Cool Apps")
//        dataModel.lists.append(list)
//        
//        list = Checklist(name: "To Do")
//        dataModel.lists.append(list)
        
        // Add placeholder item data
        var item = ChecklistItem()
        item.text = "Item for Birthdays"
        dataModel.lists[0].items.append(item)
        
        item = ChecklistItem()
        item.text = "Item for Groceries"
        dataModel.lists[1].items.append(item)
        
        item = ChecklistItem()
        item.text = "Item for Cool Apps"
        dataModel.lists[2].items.append(item)
        
        item = ChecklistItem()
        item.text = "Item for To Do"
        dataModel.lists[3].items.append(item)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Get cell
        let cell: UITableViewCell!
        if let c = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            cell = c
        } else {
            cell = UITableViewCell(style: .subtitle,
                                   reuseIdentifier: cellIdentifier)
        }
        let checklist = dataModel.lists[indexPath.row]
        cell.textLabel?.text = checklist.name
        cell.accessoryType = .detailDisclosureButton
        let count = checklist.countUncheckedItems()
        if checklist.items.count == 0 {
            cell.detailTextLabel!.text = "(No Items)"
        } else {
            cell.detailTextLabel!.text = count == 0 ? "All Done" : "\(count) Remaining"
        }
        cell.imageView!.image = UIImage(named: checklist.iconName)
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        let checklist = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist",
                     sender: checklist)
        dataModel.indexOfSelectedChecklist = indexPath.row
        UserDefaults.standard.set(indexPath.row,
                                  forKey: "ChecklistIndex")
        
    }
    
    // MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue,
                          sender: Any?) {
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destination
                as! ViewController
            controller.checklist = sender as? Checklist
        }else if segue.identifier == "AddChecklist" {
            let controller = segue.destination
                as! ListDetailViewController
            controller.delegate = self
        }
    }
    
    // MARK:- List Detail View Controller Delegates
    func listDetailViewControllerDidCancel(
        _ controller: ListDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(
        _ controller: ListDetailViewController,
        didFinishAdding checklist: Checklist) {
        dataModel.lists.append(checklist)
        dataModel.sortChecklists()
        myCellList.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(
        _ controller: ListDetailViewController,
        didFinishEditing checklist: Checklist) {
        dataModel.sortChecklists()
        myCellList.reloadData()
        navigationController?.popViewController(animated: true)
        
    }
    
    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView,
                            accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let controller = storyboard!.instantiateViewController(
            withIdentifier: "ListDetailViewController")
            as! ListDetailViewController
        controller.delegate = self
        let checklist = dataModel.lists[indexPath.row]
        controller.checklistToEdit = checklist
        navigationController?.pushViewController(controller,
                                                 animated: true)
    }
    
    // MARK:- Navigation Controller Delegates
    func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool) {
        // Was the back button tapped
        if viewController === self {
            if viewController === self {
                UserDefaults.standard.set(-1, forKey: "ChecklistIndex")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = self
        let index = UserDefaults.standard.integer(
            forKey: "ChecklistIndex")
        if index >= 0 && index < dataModel.lists.count {
            let checklist = dataModel.lists[index]
            performSegue(withIdentifier: "ShowChecklist",
                         sender: checklist)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myCellList.reloadData()
    }
    
}
