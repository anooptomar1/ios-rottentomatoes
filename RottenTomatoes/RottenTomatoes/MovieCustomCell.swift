//
//  MovieCustomCell.swift
//  RottenTomatoes
//
//  Created by Anoop tomar on 2/6/15.
//  Copyright (c) 2015 devtechie.com. All rights reserved.
//

import UIKit

class MovieCustomCell: UITableViewCell {

    @IBOutlet weak var movieThumbnail: UIImageView!
    
    @IBOutlet weak var movieTitleLbl: UILabel!
    
    @IBOutlet weak var movieDescLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
