//
//  ViewController.swift
//  ToDoList
//
//  Created by Nasim on 7/27/17.
//  Copyright © 2017 Nasim. All rights reserved.
//

import UIKit
import CoreData

private let cellId = "cellId"

class ToDoListController: UITableViewController{
    
    var people: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.white
        
        self.navigationItem.title = "To Do List"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
    }
    
    func addTapped(sender: UIBarButtonItem){
        
        let alert = UIAlertController(title: "New Name", message:"Add a new name", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title:"Save", style: .default){
            [unowned self]  action in
            guard let textField = alert.textFields?.first,
                let nameToSave = textField.text else {
               return
            }
            
            self.save(name: nameToSave)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated:true)
    }
    
    func save(name: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
        
        let person = NSManagedObject(entity:entity, insertInto:managedContext)
        
        person.setValue(name, forKeyPath:"name")
        
        do{
            
            try managedContext.save()
            people.append(person)
        
        
        }catch _ as NSError{
           print("Could not save")
        }
    }
    
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell{
    
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as UITableViewCell
        
        let person = people[indexPath.row]
    
        cell.textLabel?.text = person.value(forKeyPath: "name") as? String
    
       return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int{
        return people.count
    
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
       
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
       
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        do{
            people = try managedContext.fetch(fetchRequest)
        
        }catch let _ as NSError{
            print("Could not fetch")
        
        }
    }
}
