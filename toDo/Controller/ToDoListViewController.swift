//
//  ViewController.swift
//  toDo
//
//  Created by Mac on 11.07.18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var itemArray = [ToDoItem]()
    var selectedCategory : Category?{
        didSet{
            loadData()
        }
    }
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //print(dataFilePath)
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }
  
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let addItemAlert = UIAlertController(title: "add item", message: nil, preferredStyle: .alert)
        addItemAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        addItemAlert.addTextField { (alertTextField) in
            alertTextField.placeholder = "add list item"
            textField = alertTextField
        }
        addItemAlert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
            
            
            
            let newItem = ToDoItem(context: self.context)
            
            
            if textField.text != nil{
                newItem.name = textField.text!
                newItem.checked = false
                newItem.parentCategory = self.selectedCategory
                self.itemArray.append(newItem)
                
                self.saveData()
                
                
                //print(self.itemArray)
            }
            
            
        }))
        self.present(addItemAlert, animated: true)
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].name
        let item = itemArray[indexPath.row]
        
        cell.accessoryType = item.checked ? .checkmark : .none
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = itemArray[indexPath.row]
        
        item.checked = !item.checked
        
        saveData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    
        
    }
    
    func saveData(){
        do{
            try context.save()
        }catch{
            print(error)
        }
        tableView.reloadData()
    }
    
    func loadData(with request: NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest(), predicate: NSPredicate? = nil){
        
        let corePredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if predicate != nil {
            let nextPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [corePredicate, predicate!])
            request.predicate = nextPredicate
        }else{
            request.predicate = corePredicate
        }
        
        
        do{
            itemArray = try context.fetch(request)
        }catch{
            print(error)
        }
        
        tableView.reloadData()
        
    }
    
    
    
    
    
}


//MARK: search bar

extension ToDoListViewController: UISearchBarDelegate{
    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//    let request : NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
//    request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
//    request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
//
//    loadData(with: request)
//    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //print(searchText)
        
        let request : NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
        //request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchText)
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchText)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

        loadData(with: request, predicate: predicate)
        
        if searchBar.text?.count == 0 {
            loadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
            
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
}

