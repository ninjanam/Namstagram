//
//  PostHeaderCell.swift
//  Makestagram
//
//  Created by Nam-Anh Vu on 12/12/17.
//  Copyright © 2017 TenTwelve. All rights reserved.
//

import UIKit

class PostHeaderCell: UITableViewCell {
    
    static let height: CGFloat = 54
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func optionsButtonTapped(_ sender: Any) {
        print("options button tapped")
    }
    
}
