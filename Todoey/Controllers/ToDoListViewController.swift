//
//  ViewController.swift
//  Todoey
//
//  Created by Ty Cali on 5/22/18.
//  Copyright © 2018 Ty Cali. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    //turned item array into an array of (class->) Action objects.
    var itemArray = [Action]()
    
    var selectedCategory : Category? {
        didSet{
            loadActions()
        }
    }
    
    var searchBar = UISearchBar()
    
    //calls context from app delegate class with singleton
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //too complex for user defaults
//    //data stored inside container with user defaults. new object:
//    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //views path to document folder. object that provides an interface to the file system
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        //deleted
        //loadActions()
        
        //updates array to match saved plist on loadup; if let keeps app from crashing if plist doesn't exist. change force unwrap as! to optional as?
//        if let items = defaults.array(forKey: "TodoListArray") as? [Action] {
//            itemArray = items
//        }
       
    }

    //MARK: - Tableview Datasource Methods
    
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
    
    //MARK: - TableView Delegate Methods
    
    //indexPath is a local variable set for the selected row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        //instead of long-ended if/else, just say it's the opposite of itself.
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveActions()
        
        //tap flashes gray instead of staying gray
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
//    //Set the tapGesture
//    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
//    tableView.addGestureRecognizer(tapGesture)
    
    //MARK:  - Add New Actions
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
       
        //local scope
        var textField = UITextField()
        
        
        //needs POPUP aka UIAlertController with text field to append to end of itemArray
        let alert = UIAlertController(title: "Add New Action:", message: "", preferredStyle: .alert)
       
        //how you add items to list! -an action taken when user presses button in an alert
        let action = UIAlertAction(title: "Add Action", style: .default) { (action) in
            //what will happen once the user clicks the Add Action button on our UIAlert. Must be done like this for class object
            
            
            //class (Action) automatically gets generated with entity title Action inside data model. That class already has access to properties specified, i.e., title/done
            let newAction = Action(context: self.context)
            newAction.title = textField.text!
            newAction.done = false
            newAction.parentCategory = self.selectedCategory
            self.itemArray.append(newAction)
            
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
    
    //MARK: - Data Model Manupulation Methods:
    
    //encode method
    func saveActions() {

        //sets up code to use Core Data for saving new items that have been added using the UIAlert.
        do {
            try context.save() //try saving
        } catch {
            print("Error saving context \(error)")
        }
        //the magic method. reloads rows & sections of array, taking into account newly added items
        self.tableView.reloadData()
    }
    
    //decode method. with is external usage; request: is internal usage
    func loadActions(with request: NSFetchRequest<Action> = Action.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        //replaced below lines of code with optional binding.
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        //        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
//
//        request.predicate = compoundPredicate
        
        do {
            itemArray = try context.fetch(request) //try fetching data
        } catch {
            print("Error fetching data from context \(error)")
            
        }
        tableView.reloadData()
    }
    
}


//MARK: searchbar methods
extension ToDoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       
        //Dismiss keyboard
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print("Error fetching data from context \(error)")
//        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            //don't need parameters since they have a set default value.
            loadActions()
        
            //Run on the main thread so that searchbar loses focus and keyboard is dimissed, even if background threads are running. Otherwise, app might assign this code to another thread...
            DispatchQueue.main.async {
            searchBar.resignFirstResponder()
            }
        }
        else if searchBar.text!.count > 0 {
            let request : NSFetchRequest<Action> = Action.fetchRequest()
            
            //what is going to be our filter/query? used to say request.predicate =...
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            loadActions(with: request, predicate: predicate)
        }
        
    }
}
