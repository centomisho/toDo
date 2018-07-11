//
//  ViewController.swift
//  toDo
//
//  Created by Mac on 11.07.18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = ["work", "study", "house"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
  
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        let addItemAlert = UIAlertController(title: "add item", message: nil, preferredStyle: .alert)
        addItemAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        addItemAlert.addTextField { (textField) in
            textField.placeholder = "add list item"
        }
        addItemAlert.addAction(UIAlertAction(title: "add", style: .default, handler: { (action) in
            if let item = addItemAlert.textFields?.first?.text{
                self.itemArray.append(item)
                self.tableView.reloadData()
                print(self.itemArray)
            }
        }))
        self.present(addItemAlert, animated: true)
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    
    
    
    
    
    
    
    


}

