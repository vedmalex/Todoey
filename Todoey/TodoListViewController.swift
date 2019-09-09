//
//  ViewController.swift
//  Todoey
//
//  Created by Алексей Ведмеденко on 03/09/2019.
//  Copyright © 2019 Алексей Ведмеденко. All rights reserved.
//

import UIKit

class UITodoTableViewController: UITableViewController {

    var itemsArray:[TodoItem] = []
    let defaults = UserDefaults.standard
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
        
        deserializeData()
        // Do any additional setup after loading the view.
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        itemsArray[indexPath.row].done = !itemsArray[indexPath.row].done
        serializeData()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
       
    }
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    
    func serializeData(){
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemsArray)
            try data.write(to: dataFilePath!)
        } catch{
            print("Encoding item Array \(error)")
        }
        
    }
    func deserializeData(){
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                self.itemsArray = try decoder.decode([TodoItem].self, from: data)
            } catch {
                print("Error while decoding \(error)")
            }
        }
    }
    //MARK: - Add New Item
    
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default){
            (actoin) in
            if let title = textField.text {
                self.itemsArray.append(TodoItem(title))
                self.tableView.reloadData()
                self.serializeData()
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

