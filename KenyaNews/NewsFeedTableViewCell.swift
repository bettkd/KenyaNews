//
//  NewsFeedTableViewCell.swift
//  KE1
//
//  Created by Dominic Bett on 12/20/15.
//  Copyright © 2015 Dominic Bett. All rights reserved.
//

import UIKit

class NewsFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var imgThumbnail: UIImageView! = UIImageView()
    @IBOutlet weak var lblDate: UILabel! = UILabel()
    @IBOutlet var lblViews: UILabel! = UILabel()
    @IBOutlet weak var lblTitle: UILabel! = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
