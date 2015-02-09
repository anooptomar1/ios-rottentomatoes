//
//  BoxOfficeTableViewCell.swift
//  RottenTomatoes
//
//  Created by Anoop tomar on 2/8/15.
//  Copyright (c) 2015 devtechie.com. All rights reserved.
//

import UIKit

class BoxOfficeTableViewCell: UITableViewCell {

    @IBOutlet weak var movieDetailsLbl: UILabel!
    @IBOutlet weak var movieTitlelbl: UILabel!
    @IBOutlet weak var movieImageThumb: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
