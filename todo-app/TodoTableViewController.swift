//
//  TodoTableViewController.swift
//  todo-app
//
//  Created by liusy182 on 27/3/16.
//  Copyright © 2016 liusy182. All rights reserved.
//

import UIKit
import MGSwipeTableCell

//@objc(TodoTableViewController)
class TodoTableViewController: UITableViewController {
    
    private var todosDatastore: TodosDatastore?
    private var todos: [Todo]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        title = "Todos"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return todos?.count ?? 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TodoCell", forIndexPath: indexPath) as! MGSwipeTableCell

        // Configure the cell...
        if let todo = todos?[indexPath.row] {
            renderCell(cell, todo: todo)
            setupButtonsForCell(cell, todo: todo)
        }
        
        return cell
    }
    

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: actions
    
    @IBAction func addTodoButtonPressed(sender: UIBarButtonItem) {
        print("addTodoButtonPressed")
        performSegueWithIdentifier("addTodo", sender: self)
    }
    
    // MARK: - Configure
    
    func configure(todosDatastore: TodosDatastore) {
        self.todosDatastore = todosDatastore
    }
    
    // MARK: - Internal Functions
    private func refresh() {
        guard let todosDatastore = todosDatastore else {
            return
        }
        
        todos = todosDatastore.todos().sort {
            $0.dueDate.compare($1.dueDate) == NSComparisonResult.OrderedAscending
            
        }
        tableView.reloadData()
    }
    
    private func renderCell(cell: UITableViewCell, todo: Todo){
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm dd-MM-YY"
        
        let dueDate = dateFormatter.stringFromDate(todo.dueDate)
        cell.detailTextLabel?.text = "\(dueDate) | \(todo.list.description)"
        cell.textLabel?.text = todo.description
        
        cell.accessoryType = todo.done ? .Checkmark : .None
    }
    
    private func setupButtonsForCell(cell: MGSwipeTableCell, todo: Todo){
        cell.rightButtons = [
            MGSwipeButton(title: "Edit",
                backgroundColor: UIColor.blueColor(),
                padding: 30,
                callback: {
                    [weak self] sender in
                    self?.editButtonPressed(todo)
                    return true
                }
            ),
            MGSwipeButton(title: "Delete",
                backgroundColor: UIColor.redColor(),
                padding: 30,
                callback: {
                    [weak self] sender in
                    self?.deleteButtonPressed(todo)
                    return true
                }
            )
        ]
        
        cell.rightExpansion.buttonIndex = 0
        cell.leftButtons = [
            MGSwipeButton(title: "Done",
                backgroundColor: UIColor.greenColor(),
                padding: 30) {
                    [weak self] sender in
                    self?.doneButtonPressed(todo)
                    return true
                }
        ]
        cell.leftExpansion.buttonIndex = 0
    }

}

// MARK: Actions
extension TodoTableViewController {
//    func addTodoButtonPressed(sender: UIButton!){
//        print("addTodoButtonPressed")
//    }
    
    func editButtonPressed(todo: Todo){
        print("editButtonPressed")
    }
    
    func deleteButtonPressed(todo: Todo){
        todosDatastore?.deleteTodo(todo)
        refresh()
    }
    
    func doneButtonPressed(todo: Todo){
        todosDatastore?.doneTodo(todo)
        refresh()
    }
}
