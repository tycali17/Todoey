//
//  ViewController.swift
//  Todoey
//
//  Created by Ty Cali on 5/22/18.
//  Copyright © 2018 Ty Cali. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    //turned item array into an array of (class->) Action objects.
    var itemArray = [Action]()
    
    //data stored inside container with user defaults. new object:
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //adding new actions to list. .title = first part of pair
        let newAction = Action()
        newAction.title = "Find Mike"
        itemArray.append(newAction)
        
        let newAction2 = Action()
        newAction2.title = "Buy Eggos"
        itemArray.append(newAction2)
        
        let newAction3 = Action()
        newAction3.title = "Kill Demegorgon"
        itemArray.append(newAction3)
        
        //updates array to match saved plist on loadup; if let keeps app from crashing if plist doesn't exist. change force unwrap as! to optional as?
        if let items = defaults.array(forKey: "TodoListArray") as? [Action] {
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
        
        let item = itemArray[indexPath.row]
        
        //set text label to equal items in item array, current row; .title for class object
        cell.textLabel?.text = item.title
       
        //fixes tableview problem of multiple checks.
        //Ternary operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        //ternary operator replaces bulky if then statement.
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
        
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //instead of long-ended if/else, just say it's the opposite of itself.
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //data gets reloaded at proper time.
        tableView.reloadData()
        
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
            //what will happen once the user clicks the Add Action button on our UIAlert. Must be done like this for class object
            let newAction = Action()
            newAction.title = textField.text!
            
            //add to end of array Action object
            self.itemArray.append(newAction)
            
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

