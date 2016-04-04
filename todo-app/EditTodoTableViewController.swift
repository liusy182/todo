//
//  EditTodoTableViewController.swift
//  todo-app
//
//  Created by liusy182 on 3/4/16.
//  Copyright © 2016 liusy182. All rights reserved.
//

import UIKit

enum EditTableViewRow : Int {
    case Description
    case List
    case DueDate
    case Done
    case DatePicker
}


class EditTodoTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet var descriptionTextField: UITextField!
    @IBOutlet var listLabel: UILabel!
    @IBOutlet var dueDateLabel: UILabel!
    @IBOutlet var dueDatePicker: UIDatePicker!
    
    var onSaveTodo: ((todo: Todo) -> Void)?
    var todoToEdit: Todo?
    var todosDatastore: TodosDatastore?
    private var todoDescription: String?
    private var list: List?
    private var dueDate: NSDate?
    private var done: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        refresh()
        descriptionTextField.becomeFirstResponder()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    /*
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    */

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    // MARK: actions
    
    @IBAction func saveTodo(sender: UIBarButtonItem) {
        guard let onSaveTodo = onSaveTodo else {
            return
        }
        updateTodo()
        onSaveTodo(todo: todoToEdit!)
        navigationController!.popViewControllerAnimated(true)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch EditTableViewRow(rawValue: indexPath.row)! {
        case .List:
            showAddList()
        case .DueDate:
            descriptionTextField.resignFirstResponder()
        case .Done:
            doneSelected()
        default:
            break
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        guard let identifier = segue.identifier,
            destinationViewController = segue.destinationViewController as? ListTableViewController else {
            return
        }
        
        if identifier == "addList" {
            destinationViewController.title = "Lists"
            destinationViewController.todosDatastore = todosDatastore
            destinationViewController.selectedList = list;
            destinationViewController.onListSelected = { list in
                self.list = list
                self.refresh()
            }
        }
    }
    
    
    // MARK: private functions
    private func setup() {
        descriptionTextField.delegate = self;
        descriptionTextField.addTarget(
            self,
            action: #selector(EditTodoTableViewController.descriptionChanged(_:)),
            forControlEvents: .EditingChanged)
        
        if let todo = todoToEdit {
            descriptionTextField.text = todo.description
            todoDescription = todo.description
            list = todo.list
            dueDate = todo.dueDate
            done = todo.done
        } else if let todosDatastore = todosDatastore {
            todoDescription = ""
            list = todosDatastore.defaultList()
            dueDate = todosDatastore.defaultDueDate()
            done = false
        }
        datePickerSetup()
    }
    
    private func refresh() {
        listLabel.text = "\(list!.description)"
        let dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm dd-MM-YY"
        if let dueDate = dueDate {
            let formattedDueDate = dateFormatter.stringFromDate(dueDate)
            dueDateLabel.text = "Due date: \(formattedDueDate)"
        }
    }
    
    private func datePickerSetup() {
        dueDatePicker.datePickerMode = .DateAndTime
        dueDatePicker.minimumDate = NSDate()
        dueDatePicker.date = dueDate!
        dueDatePicker.addTarget(
            self,
            action: #selector(EditTodoTableViewController.dueDateChanged(_:)),
            forControlEvents: .ValueChanged)
    }
    
    func dueDateChanged(sender: UIButton!) {
        dueDate = dueDatePicker.date
        refresh()
    }
    
    func descriptionChanged(sender: UITextField!) {
        todoDescription = sender.text
        refresh()
    }
    
    func doneSelected() {
        done = !done!
        updateTodo()
    }
    
    func showAddList() {
        performSegueWithIdentifier("addList", sender: self)
    }
    
    func updateTodo() {
        todoToEdit = Todo(
            description: todoDescription!,
            list: List(description: listLabel.text! as String),
            dueDate: dueDatePicker.date,
            done: done ?? false,
            doneDate: nil
        )
    }
    
    // MARK: UITextFieldDelegate
    func textFieldDidEndEditing(textField: UITextField) {
        todoDescription = textField.text!
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
