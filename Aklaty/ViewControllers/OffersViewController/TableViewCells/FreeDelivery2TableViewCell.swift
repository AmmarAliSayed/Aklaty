//
//  FreeDelivery2TableViewCell.swift
//  Aklaty
//
//  Created by Macbook on 22/07/2021.
//

import UIKit

class FreeDelivery2TableViewCell: UITableViewCell {
   
    @IBOutlet weak var offerImageView: UIImageView!
    @IBOutlet weak var offerTimeLabel: UILabel!
    @IBOutlet weak var offerNameLabel: UILabel!
    @IBOutlet weak var offerPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       // offerPriceLabel.textColor = .white
        //offerTimeLabel.textColor = .white
        //offerNameLabel.textColor = .white
        contentView.backgroundColor = #colorLiteral(red: 0.09411764706, green: 0.1176470588, blue: 0.1450980392, alpha: 1)
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = #colorLiteral(red: 0.09411764706, green: 0.1176470588, blue: 0.1450980392, alpha: 1)
        contentView.layer.masksToBounds = true
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = contentView.frame.size.width / 30
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //space between cells in table view
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
}
