//
//  PostTableViewCell.swift
//  Foody
//
//  Created by Giovanni Lenguito on 02/12/2016.
//  Copyright © 2016 Giovanni Lenguito. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    //MARK: Properties
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var viewBtn: UIButton!
    @IBOutlet weak var postDescription: UILabel!
    @IBOutlet weak var yumButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
