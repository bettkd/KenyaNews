//
//  MenuTableViewController.swift
//  KE1
//
//  Created by Dominic Bett on 12/20/15.
//  Copyright © 2015 Dominic Bett. All rights reserved.
//

import UIKit

class MenuTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var channels = [String]()
    
    @IBOutlet var menuTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuTableView.delegate = self
        menuTableView.dataSource = self
        
        channels = ["NTV Kenya", "KTN News", "K24 TV", "Citizen TV", "KBC News", "Capital News", "QTV Kenya", "Kass International", "Ebru Africa TV", "East Africa TV", "Family TV Kenya", "Pwani TV"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.revealViewController().frontViewController.view.userInteractionEnabled = false
        
        /* //Not Working...
        self.revealViewController().frontViewController.navigationController?.navigationController?.navigationBar.userInteractionEnabled = true
    self.revealViewController().frontViewController.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        */
        
        self.revealViewController().view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.revealViewController().frontViewController.view.userInteractionEnabled = true
    }
    /*
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    */

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return channels.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        cell.textLabel?.text = channels[indexPath.row]
        cell.textLabel?.font = UIFont(name: "Gill Sans", size: 18.0)
        
        return cell
    }

    // MARK: Navigation - Pass Values By Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let navVC = segue.destinationViewController as? UINavigationController {
            if let destVC = navVC.viewControllers.first as? NewsFeedViewController {
                if let indexPath = menuTableView.indexPathForSelectedRow {
                    destVC.currentChannel = channels[indexPath.row]
                    destVC.tableViewAnimation = "Right"
                }
            }
        }
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

}
