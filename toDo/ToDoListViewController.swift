//
//  ViewController.swift
//  toDo
//
//  Created by Mac on 11.07.18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = [ToDoItem]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(dataFilePath)
        
        // Do any additional setup after loading the view, typically from a nib.
        

        loadData()
        
    }
  
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let addItemAlert = UIAlertController(title: "add item", message: nil, preferredStyle: .alert)
        addItemAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        addItemAlert.addTextField { (alertTextField) in
            alertTextField.placeholder = "add list item"
            textField = alertTextField
        }
        addItemAlert.addAction(UIAlertAction(title: "add", style: .default, handler: { (action) in
            let newItem = ToDoItem()
            if textField.text != nil{
                newItem.name = textField.text!
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
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch{
            print("error encoding file \(error)")
        }
        tableView.reloadData()
    }
    
    func loadData(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([ToDoItem].self, from: data)
            }catch{
                print(error)
            }
            
        }
    }
    
    
    
    
    
    
    


}

