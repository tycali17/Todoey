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
    
    //creates path to document folder. object that provides an interface to the file system
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Actions.plist")
    
    //too complex for user defaults
//    //data stored inside container with user defaults. new object:
//    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath!)
        
        //no need for hard coding appending actions:
        loadActions()
        
        //updates array to match saved plist on loadup; if let keeps app from crashing if plist doesn't exist. change force unwrap as! to optional as?
//        if let items = defaults.array(forKey: "TodoListArray") as? [Action] {
//            itemArray = items
//        }
       
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
        
        //shortens code; can't be global because of local function with IndexPath
        let item = itemArray[indexPath.row]
        
        //set text label to equal items in item array, current row; .title for class object
        cell.textLabel?.text = item.title
       
        //fixes tableview problem of multiple checks from reusable cells.
        //Ternary operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done == true ? .checkmark : .none
        //ternary operator replaces bulky if then statement
        
        return cell
        
    }
    
    //MARK - TableView Delegate Methods
    
    //indexPath is a local variable set for the selected row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //instead of long-ended if/else, just say it's the opposite of itself.
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        self.saveActions()
        
        //tap flashes gray instead of staying gray
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
//    //Set the tapGesture
//    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
//    tableView.addGestureRecognizer(tapGesture)
    
//MARK  - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
       
        //local scope
        var textField = UITextField()
        
        
        //needs POPUP aka UIAlertController with text field to append to end of itemArray
        let alert = UIAlertController(title: "Add New Action:", message: "", preferredStyle: .alert)
       
        //how you add items to list! -an action taken when user presses button in an alert
        let action = UIAlertAction(title: "Add Action", style: .default) { (action) in
            //what will happen once the user clicks the Add Action button on our UIAlert. Must be done like this for class object
            let newAction = Action()
            newAction.title = textField.text!
            
            //add to end of array Action object. needs self because it's a closure.
            self.itemArray.append(newAction)
            
            //from below method. can tell by no description from xcode when highlighted.
            self.saveActions()
        }
        
        //placeholder shows in gray
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new action..."
            textField = alertTextField
        }
        
        //given method from xcode. has description when highlighted.
        alert.addAction(action)
        
        //shows our alert
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK - Model Manupulation Methods:
    
    //encode method
    func saveActions() {
        //saves updated item array to user defaults (in plist), still needs to load up table view
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
        //the magic method. reloads rows & sections of array, taking into account newly added items
        self.tableView.reloadData()
    }
    
    //decode method
    func loadActions() {
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do {
            itemArray = try decoder.decode([Action].self, from: data)
            } catch {
                print("Error decoding item array, \(error)")
            }
        }
    }
    
    
}

