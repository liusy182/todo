//
//  ListTableViewController.swift
//  todo-app
//
//  Created by liusy182 on 3/4/16.
//  Copyright © 2016 liusy182. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {
    
    var onListSelected: ((list: List) -> Void)?
    var todosDatastore: TodosDatastore?
    var selectedList: List?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Lists"
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

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return todosDatastore?.lists().count ?? 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        guard let list = todosDatastore?.lists()[indexPath.row] else {
            return cell
        }
        
        cell.textLabel?.text = list.description
        cell.selectionStyle = .None
        cell.accessoryType = (list == selectedList) ? .Checkmark : .None
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
    
    // MARK: - Table view delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let list = todosDatastore?.lists()[indexPath.row]
        selectList(list)
    }

    // MARK: Actions
    @IBAction func addListButtonTapped(sender: AnyObject) {
        let alert = UIAlertController(
            title: "Enter list name",
            message: "To create a new list, please enter the name of the list",
            preferredStyle: .Alert)
        let okAction = UIAlertAction(
            title: "OK",
            style: .Default) { (
                action: UIAlertAction!) -> Void in
                    let textField = alert.textFields?.first
                    self.addList(textField?.text ?? "")
            }
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .Default, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        alert.addTextFieldWithConfigurationHandler(nil)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func addList(description: NSString) {
        todosDatastore?.addListDescription(description as String)
        
        selectList(List(description: description as String));
        
        tableView.reloadData()
    }
    
    func selectList(list: List?) {
        
        selectedList = list ?? selectedList
        if let list = list, onListSelected = onListSelected {
            onListSelected(list: list)
        }
        navigationController?.popViewControllerAnimated(true)
    }

}


