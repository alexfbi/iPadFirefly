//
//  ViewController.swift
//  test1
//
//  Created by ak on 20.05.15.
//  Copyright (c) 2015 ak. All rights reserved.
//

import UIKit
import CoreData


class PageViewController: UIViewController, UIPageViewControllerDataSource {
    
    var pageViewController: UIPageViewController!
    var pageTitel: NSArray!
  //  var log: Log  = Log()
    
    var logs = [Log]()
    
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    
    @IBOutlet weak var restartLabel: UILabel!
    
    
    func loadDataFromDB(){
        let fetchRequest = NSFetchRequest(entityName: "Log")
        logs = context?.executeFetchRequest(fetchRequest, error: nil) as! [Log]
        NSLog("%@", "Count logs: \(logs.count)")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "Live Modus"
       loadDataFromDB()
   //     log.name = "a"
   //     log.id = 1
        
        self.pageTitel = NSArray(objects: "0","1", "2", "3" )
        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        
        
        self.pageViewController.dataSource = self
        
        
        var startVC = self.viewControllerAtindex(0) as ContentViewController
        
       // var startVC = self.storyboard?.instantiateViewControllerWithIdentifier("ContentViewController") as SteuerungTableViewController
        
        
        var viewControllers = NSArray(object: startVC)
        
        self.pageViewController.setViewControllers(viewControllers as [AnyObject], direction: .Forward, animated: true, completion: nil)
        
        self.pageViewController.view.frame = CGRectMake(0, 30, self.view.frame.width, self.view.frame.size.height - 60)
        
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func viewControllerAtindex(index: Int)  -> ContentViewController{
        
        
        if((self.pageTitel.count == 0 )) || (index >= self.pageTitel.count)
        {
          
            return ContentViewController()
            
        }
        
        
        if (index == 0){
            var vc: ContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Map") as! ContentViewController
            
            vc.log = logs.last
            vc.titelText = self.pageTitel[index] as! String
            vc.pageIndex = index
            return vc
        }

        
        
            
        if (index == 1){
            var vc: ContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("GPS") as! ContentViewController
            
            vc.log = logs.last
            vc.titelText = self.pageTitel[index] as! String
            vc.pageIndex = index
            return vc
            
        }
        if (index == 2){
            var vc: ContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("BilderViewController") as! ContentViewController
            
          
            vc.log =   logs.last
            vc.titelText = self.pageTitel[index] as! String
            vc.pageIndex = index
            return vc
            
        }
        
        
        if (index == 3){
            var vc: ContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Plotter") as! ContentViewController
            
            vc.log = logs.last
            vc.titelText = self.pageTitel[index] as! String
            vc.pageIndex = index
            return vc
        }
        
      /*  if (index == 4){
            var vc: ContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Status") as! ContentViewController
            
            vc.log = logs.first
            vc.titelText = self.pageTitel[index] as! String
            vc.pageIndex = index
            return vc
        }
*/

        
        var vc: ContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ContentViewController") as! ContentViewController
        
        
        vc.titelText = self.pageTitel[index] as! String
        vc.pageIndex = index
        return vc
        
    }
 
    // MARK: -Page View Controller Data Source
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
      
        
        var vc = viewController as! ContentViewController
        
        
        var index = vc.pageIndex as Int
        if (index == 0 || index == NSNotFound ){
            return nil
        }
        
        index--
        
        
        
        
       return self.viewControllerAtindex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
      
        var vc = viewController as! ContentViewController
        var index = vc.pageIndex as Int
        
        if (index == NSNotFound ){
            return nil
        }
        
        
        index++
        
        if (index == self.pageTitel.count){
            return nil
            
        }
        
        
       return self.viewControllerAtindex(index)
        
    }
    
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.pageTitel.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}

