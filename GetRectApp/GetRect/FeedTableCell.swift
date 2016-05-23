//
//  FeedTableCell.swift
//  GetRect
//
//  Created by Evan on 5/23/16.
//  Copyright © 2016 iGuest. All rights reserved.
//

import UIKit

class FeedTableCell: UITableViewCell {

    @IBOutlet weak var art: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var score: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
