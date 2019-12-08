//
//  HomeTableViewCell.swift
//  Cleanse
//
//  Created by Alek Matthiessen on 12/7/19.
//  Copyright © 2019 The Matthiessen Group, LLC. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
        
    @IBOutlet weak var titleback: UIImageView!
    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var viewslabel: UILabel!
    @IBOutlet weak var tapdown: UIButton!
    @IBOutlet weak var tapup: UIButton!
    @IBOutlet weak var upvoteslabel: UILabel!
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var titlelabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
