//
//  PhotosViewController.swift
//  instagram
//
//  Created by Lyn Han on 1/7/16.
//  Copyright © 2016 lyn. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var posts : [NSDictionary]!

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        print("viewDidLoad")
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.rowHeight = 320;
        tableView.dataSource = self
        tableView.delegate = self

        let clientId = "e05c462ebd86446ea48a5af73769b602"
        let url = NSURL(string:"https://api.instagram.com/v1/media/popular?client_id=\(clientId)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            print("setting posts")
                            self.posts = responseDictionary["data"] as! [NSDictionary]
                            self.tableView.reloadData()
                    }
                }
        });
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection sectionIndex: Int) -> UIView? {
        print("viewForHeaderInSection")

        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        let profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 70, height: 70))
        
        let usernameLabel = UILabel(frame: CGRect( x:100, y: 10, width:200, height: 70))
        
        
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 40;
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).CGColor
        profileView.layer.borderWidth = 1;
        
        // Use the section number to get the right URL
        if posts != nil {
            let post = posts![sectionIndex]
            let baseUrl = post["images"]!["low_resolution"]!!["url"] as? String
            if baseUrl != nil {
                let imageUrl = NSURL(string: baseUrl!)
                profileView.setImageWithURL(imageUrl!)
            }
            usernameLabel.text = post["user"]!["username"] as? String
        }
        headerView.addSubview(profileView)
        headerView.addSubview(usernameLabel)
        
        
        return headerView
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        print("numberOfSectionsInTableView")
        if let posts = posts {
            return posts.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInSection")
       return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("cellForRowAtIndexPath")
        let cell = tableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath) as! PostCell
//        let post = posts![indexPath]
//        let baseUrl = post["images"]!["low_resolution"]!!["url"] as? String
//        if baseUrl != nil {
//            print("\(post)")
//            let imageUrl = NSURL(string: baseUrl!)
//            cell.postImageView.setImageWithURL(imageUrl!)
//        }
        return cell
    }

    
}

