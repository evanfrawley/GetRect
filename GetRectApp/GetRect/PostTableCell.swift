//
//  PostTableCell.swift
//  GetRect
//
//  Created by Evan on 5/26/16.
//  Copyright © 2016 iGuest. All rights reserved.
//

import UIKit

class PostTableCell: UITableViewCell {
    
    
    @IBOutlet weak var art: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var artist: UILabel!
    var uri:String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
