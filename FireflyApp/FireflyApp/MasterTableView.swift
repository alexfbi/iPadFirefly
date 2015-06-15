//
//  MasterTableView.swift
//  FireflyApp
//
//  Created by Alexander Zeier on 08.06.15.
//  Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import UIKit
import MapKit

class MasterTableView: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var changeOrderButton: UIButton!
    var refreshControl:UIRefreshControl!
    var waypoints:[Waypoint]?
    weak var waypointTableDelegate:WaypointTableDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshTable:", name:"refresh", object: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        waypoints = waypointTableDelegate?.getWaypoints()
        return waypoints!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = self.tableView.dequeueReusableCellWithIdentifier("cell") as? UITableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
        }
        
        cell!.textLabel?.text = "Waypoint \(self.waypoints![indexPath.row].waypointNumber)"
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func refreshTable(notification: NSNotification) {
        println("Refreshing Table")
        self.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        waypointTableDelegate!.waypointWasSelected(indexPath.row)
    }
    
    // Delete the waypoint item
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            waypointTableDelegate?.deleteWaypoint(indexPath.row)
        }
    }
    
    // Reorder the waypoint items
    @IBAction func changeOrderButtonPressed(sender: AnyObject) {
        if (changeOrderButton.titleLabel!.text == "Change Order") {
            self.tableView.setEditing(true, animated: true)
            changeOrderButton.setTitle("Done", forState: .Normal)
        } else {
            self.tableView.setEditing(false, animated: true)
            changeOrderButton.setTitle("Change Order", forState: .Normal)
        }
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        waypointTableDelegate?.waypointsWereReordered(sourceIndexPath.row, toPosition: destinationIndexPath.row)
        self.tableView.reloadData()
    }
    
    
}
