//
//  ViewController.swift
//  Todoey
//
//  Created by Алексей Ведмеденко on 03/09/2019.
//  Copyright © 2019 Алексей Ведмеденко. All rights reserved.
//

import UIKit
import CoreData

class UITodoTableViewController: UITableViewController {

    var itemsArray:[TodoItem] = []
    let defaults = UserDefaults.standard
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var searchBar: UISearchBar!
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let item = itemsArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
//        searchBar.delegate = self;
        // Do any additional setup after loading the view.
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        itemsArray[indexPath.row].done = !itemsArray[indexPath.row].done
        saveAllData()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
       
    }
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    
    func saveAllData(){
        do {
            try context.save()
        } catch {
            print(" Error while persisting tha data \(error)")
        }
    }
    
    func fetchData(with request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()){
        do {
            itemsArray = try context.fetch(request)
        } catch {
            print("Error while fetching \(error)")
        }
    }
    //MARK: - Add New Item
    
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default){
            (actoin) in
            if let title = textField.text {
                let item = TodoItem(context: self.context)
                item.title = title
                item.done = false
                self.itemsArray.append(item)
                self.tableView.reloadData()
                self.saveAllData()
            }
        }
        alert.addAction(action)
        alert.addTextField{ (alertTextField) in
            alertTextField.placeholder = "Create new item";
            textField = alertTextField;
        }
        present(alert, animated: true, completion: nil)
    }
    

    
}

extension UITodoTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        if let text = searchBar.text{
            if text.count > 0 {
                request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", text)
                request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
                fetchData(with: request)
                
            } else {
                fetchData()
            }
        } else {
            fetchData()
        }
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            fetchData()
            tableView.reloadData()
        }
    }
}
