//
//  HomeViewController.swift
//  Makestagram
//
//  Created by Nam-Anh Vu on 12/8/17.
//  Copyright © 2017 TenTwelve. All rights reserved.
//

import UIKit
import Kingfisher

class HomeViewController: UIViewController {

    // MARK - Properties
    
    var posts = [Post]()
    
    let timestampFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        return dateFormatter
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        
        UserService.posts(for: User.current) { (posts) in
            self.posts = posts
            self.tableView.reloadData()
        }
        
    }
    
    func configureTableView() {
        
        // remove separators for empty cells
        tableView.tableFooterView = UIView()
        // remove separators from cells
        tableView.separatorStyle = .none
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("indexPath.section is \(indexPath.section)")
        print("indexPath.row is \(indexPath.row)")

        let post = posts[indexPath.section]
        
        switch indexPath.row {
        case 0:
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostHeaderCell", for: indexPath) as! PostHeaderCell
            cell.usernameLabel.text = User.current.username
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostImageCell", for: indexPath) as! PostImageCell
            
            let imageURL = URL(string: post.imageURL)
            cell.postImageView.kf.setImage(with: imageURL)
            
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostActionCell", for: indexPath) as! PostActionCell
            cell.delegate = self
            configureCell(cell, with: post)
            
            return cell
            
        default:
            fatalError("Error: unexpected indexPath.")
        }
    }
    
    func configureCell(_ cell: PostActionCell, with post: Post) {
        cell.timeAgoLabel.text = timestampFormatter.string(from: post.creationDate)
        cell.likeButton.isSelected = post.isLiked
        cell.likeLabel.text = "\(post.likeCount) likes"
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0:
            return PostHeaderCell.height
            
        case 1:
            let post = posts[indexPath.section]
            print("\(indexPath.section) with imageHeight: \(post.imageHeight)")
            return post.imageHeight
            
        case 2:
            return PostActionCell.height
            
        default:
            fatalError()
        }
    }
}

extension HomeViewController: PostActionCellDelegate {
    func didTapLikeButton(_ likeButton: UIButton, on cell: PostActionCell) {

        // Ensure an index path exists for the given cell
        // We'll need the index path of the cell later to reference correct post
        guard let indexPath = tableView.indexPath(for: cell)
            else { return }

        // set the like button to false so the user doesn't accidentally
        // send multiple requests by tapping too quickly
        likeButton.isUserInteractionEnabled = false
        
        // reference the correct post corresponding with the PostActionCell that the user tapped
        let post = posts[indexPath.section]
        
        // use LikeService to like or unlike the post based on the isLiked property
        LikeService.setIsLiked(!post.isLiked, for: post) { (success) in
            
            // Use defer to set the button to true whenever the closure returns
            defer {
                likeButton.isUserInteractionEnabled = true
            }
            
            // basic error handling if something goes wrong with the network request
            guard success else { return }
            
            // change the likeCount and isLiked properties of our post if network request was successful
            post.likeCount += !post.isLiked ? 1 : -1
            post.isLiked = !post.isLiked
            
            // get a reference to current cell
            guard let cell = self.tableView.cellForRow(at: indexPath) as? PostActionCell
                else { return }
            
            // Update the UI of the cell on the main thread
            DispatchQueue.main.async {
                self.configureCell(cell, with: post)
            }
        }
    }
}









