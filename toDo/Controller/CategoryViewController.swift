//
//  CategoryViewController.swift
//  toDo
//
//  Created by Mac on 24.07.18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categoryItems = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
        
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let addItemAlert = UIAlertController(title: "add category", message: nil, preferredStyle: .alert)
        addItemAlert.addTextField{(alertText) in
        
            alertText.placeholder = "add category"
            textField = alertText
        }
        addItemAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        addItemAlert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
            
            let category = Category(context: self.context)
            category.name = textField.text!
            
            self.categoryItems.append(category)
            
            self.saveData()
            
        }))
        
        self.present(addItemAlert, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryItems[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryItems.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryItems[indexPath.row]
        }
    }
    
    
    
    func saveData(){
        do{
            try context.save()
        }catch{
            print(error)
        }
        tableView.reloadData()
    }
    
    func loadData(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        do{
            categoryItems = try context.fetch(request)
        }catch{
            print(error)
        }
        
        tableView.reloadData()
        
    }
    
}
