//
//  MasterTableView.swift
//  FireflyApp
//
//  Created by Alexander Zeier on 08.06.15.
//  Copyright (c) 2015 Hochschule Darmstadt. All rights reserved.
//

import UIKit
import MapKit

//protocol waypointTableDelegate {
//    func registerMapViewDelegate(view: MasterTableView);
//}

class MasterTableView: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    var refreshControl:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshTable:", name:"refresh", object: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return waypointsForMission.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = self.tableView.dequeueReusableCellWithIdentifier("cell") as? UITableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
        }
        
        cell!.textLabel?.text = "Waypoint \(waypointsForMission[indexPath.row].waypointNumber)"
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func refreshTable(notification: NSNotification) {
        println("Refreshing Table")
        self.tableView.reloadData()
    }
}
