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
    
    var selectedCateory: Category? {
        didSet {
            loadFile()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Table View
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell")
        
        let item = itemArray[indexPath.row]
        
        cell?.textLabel?.text = itemArray[indexPath.row].title
        
        cell?.accessoryType = item.done ? .checkmark: .none
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = itemArray[indexPath.row]
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        item.done = !item.done
        
        saveFile()
    }
    
    //MARK: - Add Button Pressed
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Title", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { action in
            
            let item = Item(context: self.context)
            
            item.title = textField.text
            
            item.done = false
            
            item.parentCategory = self.selectedCateory
            
            self.itemArray.append(item)
            
            self.saveFile()
        }
        
        alert.addTextField { newTextField in
            textField = newTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    //MARK: - Core Data Manipulation
    
    func saveFile() {
        do {
            try context.save()
        } catch {
            print("Error during saving the data into CoreData. error: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadFile(with predicate: NSPredicate? = nil) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCateory!.name!)
        
        if let searchPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, searchPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error during loading the data from CoreData. error: \(error)")
        }
        
        tableView.reloadData()
    }
    
}

extension TodoViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
            
            loadFile(with: predicate)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            loadFile()
        }
    }
}

