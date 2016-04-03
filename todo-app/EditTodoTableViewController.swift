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


class EditTodoTableViewController: UITableViewController {

    @IBOutlet var descriptionTextField: UITextField!
    @IBOutlet var listLabel: UILabel!
    @IBOutlet var dueDateLabel: UILabel!
    @IBOutlet var dueDatePicker: UIDatePicker!
    
    var todoToEdit: Todo?
    var todosDatastore: TodosDatastore?
    private var list: List?
    private var dueDate: NSDate?
    
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
        if let todo = todoToEdit {
            descriptionTextField.text = todo.description
            list = todo.list
            dueDate = todo.dueDate
        } else if let todosDatastore = todosDatastore {
            list = todosDatastore.defaultList()
            dueDate = todosDatastore.defaultDueDate()
        }
        datePickerSetup()
    }
    
    private func refresh() {
        listLabel.text = "List: \(list!.description)"
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
    
    func doneSelected() {
        guard let todo = todoToEdit else {
            return
        }
        todosDatastore?.doneTodo(todo)
        navigationController!.popViewControllerAnimated(true)
    }
    
    func showAddList() {
        performSegueWithIdentifier("addList", sender: self)
    }

}
