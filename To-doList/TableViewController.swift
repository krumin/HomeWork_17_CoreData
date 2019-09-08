//
//  TableViewController.swift
//  To-doList
//
//  Created by MAC OS  on 04.09.2019.
//  Copyright © 2019 MAC OS . All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
  
  var toDoItems: [Task] = []
  
  @IBAction func addTask(_ sender: Any) {
    let ac = UIAlertController(title: "Add Task", message: "add new task", preferredStyle: .alert)
    let ok = UIAlertAction(title: "OK", style: .default) { action in
      let textField = ac.textFields?[0]
      textField?.resignFirstResponder()
      self.saveTask(taskToDo: (textField?.text)!)
      self.tableView.reloadData()
    }
    
    let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
    ac.addTextField {
      textField in
    }
    
    ac.addAction(ok)
    ac.addAction(cancel)
    present(ac, animated: true, completion: nil)
  }
  
  func saveTask(taskToDo: String) {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    
    let entity = NSEntityDescription.entity(forEntityName: "Task", in: context)
    let taskObject = NSManagedObject(entity: entity!, insertInto: context) as! Task
    taskObject.taskTodo = taskToDo
    
    do {
      try context.save()
      toDoItems.append(taskObject)
      print("Saved!")
    } catch {
      print(error.localizedDescription)
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    //получаем контекст и создаем fetchRequest
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    
    let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
    
    do {
      toDoItems = try context.fetch(fetchRequest)
    } catch {
      print(error.localizedDescription)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return toDoItems.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    
    let task = toDoItems[indexPath.row]
    cell.textLabel?.text = task.taskTodo
    
    return cell
  }
  
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
    let toDos = toDoItems[indexPath.row]
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    context.delete(toDos)
    toDoItems.remove(at: indexPath.row)
    do {
      try context.save()
    } catch let error as NSError {
      print("Error: \(error), description \(error.userInfo)")
    }
    tableView.deleteRows(at: [indexPath], with: .fade)
    
  }
  
}
