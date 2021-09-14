//
//  ItemDetailsTableViewCell.swift
//  Aklaty
//
//  Created by Macbook on 01/08/2021.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {
    @IBOutlet weak var cellView: UIView!
    
    @IBOutlet weak var userReviewLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
