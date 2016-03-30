//
//  FeedVC.swift
//  devslopes-showcase-lewis
//
//  Created by Lewis Black on 29/03/2016.
//  Copyright © 2016 Lewis Black. All rights reserved.
//

import UIKit
import Firebase

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        DataService.ds.REF_POSTS.observeEventType(.Value, withBlock: { snapshot in
            //print(snapshot.value)
            
            self.posts = []
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                
                for snap in snapshots {
                    //print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, dictionary: postDict)
                        self.posts.append(post)
                    }
                }
                
            }
            
            
            self.tableView.reloadData()
        })
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
        //change
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
        //change
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let post = posts[indexPath.row]
        print(post.postDescription)
        
        return tableView.dequeueReusableCellWithIdentifier("PostCell") as! PostCell
    
    }


}
