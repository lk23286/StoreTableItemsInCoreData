//
//  ViewController.swift
//  StoreTableItemsInCoreData
//
//  Created by Laszlo Kovacs on 2023. 06. 23..
//

import UIKit
import CoreData


class TodoViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var testItem = Item(context: context)
        testItem.title = "LGL"
        testItem.done = false
        itemArray.append(testItem)
        
        // Do any additional setup after loading the view.
    }

    //MARK: - Table View
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell")
        var item = itemArray[indexPath.row]
        cell?.textLabel?.text = itemArray[indexPath.row].title
        
        cell?.accessoryType = item.done ? .checkmark: .none
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       var item = itemArray[indexPath.row]
        
        item.done = !item.done
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
 
    
    
    
    //MARK: - Add Button Pressed
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Title", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { action in
            
            let item = Item(context: self.context)
            
            item.title = textField.text
            
            item.done = false
            
            self.itemArray.append(item)
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { newTextField in
           textField = newTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true)
    }
}

