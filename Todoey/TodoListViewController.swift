//
//  ViewController.swift
//  Todoey
//
//  Created by Алексей Ведмеденко on 03/09/2019.
//  Copyright © 2019 Алексей Ведмеденко. All rights reserved.
//

import UIKit

class UITodoTableViewController: UITableViewController {

    var itemsArray = ["Item1","item2","item3","item4"]
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemsArray[indexPath.row]
        return cell;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)!
        if cell.accessoryType == .checkmark {
            cell.accessoryType = .none
        } else {
            cell.accessoryType = .checkmark
        }
    }
    //MARK: - Add New Item
    
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default){
            (actoin) in
            
            self.itemsArray.append(textField.text!)
            self.tableView.reloadData()
            
        }
        alert.addAction(action)
        alert.addTextField{ (alertTextField) in
            alertTextField.placeholder = "Create new item";
            textField = alertTextField;
        }
        present(alert, animated: true, completion: nil)
    }
    

}

