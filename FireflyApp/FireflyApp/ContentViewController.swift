//
//  ContentViewController.swift
//  test1
//
//  Created by ak on 20.05.15.
//  Copyright (c) 2015 ak. All rights reserved.
//

import UIKit

/**
This controller is used for the pageviewController, but the pageviewController is not used
*/

class ContentViewController: UIViewController {

   // MARK: - Variable
    
    var pageIndex: Int!
    var titelText: String!
    var log : Log!
   
     // MARK: - Outlet
     @IBOutlet weak var titelLabel: UILabel!
   
    
     // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
   //     self.titelLabel.text   = self.titelText
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
