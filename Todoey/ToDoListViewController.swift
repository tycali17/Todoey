//
//  ViewController.swift
//  Todoey
//
//  Created by Ty Cali on 5/22/18.
//  Copyright © 2018 Ty Cali. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demegorgon"]
    
    //data stored inside container with user defaults. new object:
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //updates array to match saved plist on loadup; if let keeps app from crashing if plist doesn't exist. change force unwrap as! to optional as?
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            itemArray = items
        }
       
    }

    //MARK - Tableview Datasource Methods
    
    //numberofrows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //tableview method
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //cell created
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        //set text label to equal items in item array, current row
        cell.textLabel?.text = itemArray[indexPath.row]
        
        //displays cell
        return cell
        
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print(itemArray[indexPath.row])
        
        //grabbing reference to cell at particular index path (obviously one currently selected)
        //sets checkmark when clicked, removes when clicked again
        if  tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
             tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
             tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        //flashes gray instead of staying gray
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
//    //Set the tapGesture
//    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
//    tableView.addGestureRecognizer(tapGesture)
    
//MARK  - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
       
        //has scope of entire method
        var textField = UITextField()
        
        
        //needs POPUP or, UIAlertController with text field to append to end of itemArray
        let alert = UIAlertController(title: "Add New Action:", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Action", style: .default) { (action) in
            //what will happen once the user clicks the Add Item button on our UIAlert
            //add to end of array & force unwrap optional
            self.itemArray.append(textField.text!)
            
            //saves updated item array to user defaults (in plist), still needs to load up table view
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            //the magic method. reloads rows & sections of array, taking into account newly added items
            self.tableView.reloadData()
        }
        
        //placeholder shows in gray
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new action..."
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        //shows our alert
        present(alert, animated: true, completion: nil)
        
    }
}

