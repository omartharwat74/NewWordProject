//
//  ViewController.swift
//  NewWordProject
//
//  Created by Omar Tharwat on 5/11/22.
//  Copyright © 2022 Omar Tharwat. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController{
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var listItemArray = [ListItem]()
    // MARK : OUTLETS
    @IBOutlet weak var viewGround: UIView!
    @IBOutlet weak var addButtonOutlet: UIButton! {
        didSet {
            addButtonOutlet.layer.cornerRadius = addButtonOutlet.frame.width / 515
        }
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newWordLabel: UILabel!
    


    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    // MARK : ACTIONS
    
    @IBAction func addWordButton(_ sender: Any) {
        var textfield = UITextField()
        let alert = UIAlertController(title: "create new word ", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Save", style: .default) { (action) in
            let newWord = ListItem(context:self.context)
            newWord.name = textfield.text
            self.listItemArray.append(newWord)
            self.saveData()
        }
        let action2 = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(action2)
        alert.addAction(action)
        alert.addTextField { (UITextField) in
            UITextField.placeholder = "Add a new word"
            textfield = UITextField
        }
        present(alert, animated: true, completion: nil)
    }
    
}
extension ViewController : UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        cell.textLabel?.text = listItemArray[indexPath.row].name

        return cell
    }
    
    func loadData() {
     let request : NSFetchRequest<ListItem> = ListItem.fetchRequest()
        do {
            listItemArray = try context.fetch(request)
    }
      catch {
    print("Error loading data \(error)")
}
        tableView.reloadData()
    }
       func saveData() {
            do {
                try context.save()
        }
          catch {
        print("Error saving context \(error)")
    }
            tableView.reloadData()
        }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Change word", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Edit", style: .default) { (action) in
            self.listItemArray[indexPath.row].setValue(textField.text, forKey: "name")
            self.saveData()
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter new word"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           if (editingStyle == .delete) {
                 context.delete(listItemArray[indexPath.row])
                 listItemArray.remove(at: indexPath.row)
                 saveData()
             }
    }
}
