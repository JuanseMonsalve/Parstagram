//
//  FeedViewController.swift
//  Parstagram
//
//  Created by Juan S Monsalve on 10/6/21.
//

import UIKit
import Parse
import AlamofireImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Variables and constants--->
    let myRefreshControll = UIRefreshControl()
    var numberOfPosts: Int!
    var posts = [PFObject]()
    //-------------------------<
    
    // Outlets ------->
    @IBOutlet weak var tableView: UITableView!
    //-------------------------<
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //load initial posts
        loadPosts()
        
        //Set up refresh controll
        myRefreshControll.addTarget(self, action: #selector(loadPosts), for: .valueChanged)
        tableView.refreshControl = myRefreshControll
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150 //not the actual height
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadPosts()
    }
    
    @objc func loadPosts() {
        
        // Testing reload wheel  ->
        //run(after: 3, closure: refresh)
        // Testing reload wheel  -<
        
        numberOfPosts = 20
        
        let query = PFQuery(className:"Posts")
        query.includeKey("author")
        query.limit = numberOfPosts
        
        
        //get data an reload table
        query.findObjectsInBackground { (posts, error) in
            if posts != nil{
                self.posts = posts!
                self.tableView.reloadData()
                self.myRefreshControll.endRefreshing()
            }
        }
    }
    
    func loadMorePosts() {
        
        numberOfPosts += 10
        
        let query = PFQuery(className:"Posts")
        query.includeKey("author")
        query.limit = numberOfPosts
        
        
        //get data an reload table
        query.findObjectsInBackground { (posts, error) in
            if posts != nil{
                self.posts = posts!
                self.tableView.reloadData()
            }
        }
    }
    
    // Fuction to load more posts, sometimes it need override ------>
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath:IndexPath){
        if indexPath.row + 1 == posts.count{
            loadMorePosts()
        }
    }
    //-------------------------<
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Here the cell is populated with information!
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        
        let post = posts[indexPath.row]
        let user = post["author"] as! PFUser
        
        cell.usernameLabel.text = user.username
        cell.captionLabel.text = post["caption"] as! String
        
        let imgeFile = post["image"] as! PFFileObject
        let urlString = imgeFile.url!
        let url = URL(string: urlString)!
        
        cell.photoView.af.setImage(withURL: url)
        
        return cell
    }
    
    /*
     // Testing for refreshing wheel -->
    func run(after wait: TimeInterval, closure: @escaping () -> Void) {
        let queue = DispatchQueue.main
        queue.asyncAfter(deadline: DispatchTime.now() + wait, execute: closure)
    }
    
    func refresh() {
        run(after: 2) {
           self.myRefreshControll.endRefreshing()
        }
    }
     // Testing for refreshing wheel --<
     */
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
