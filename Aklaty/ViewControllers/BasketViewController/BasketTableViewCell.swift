//
//  BasketTableViewCell.swift
//  Aklaty
//
//  Created by Macbook on 22/08/2021.
//

import UIKit

class BasketTableViewCell: UITableViewCell {
    @IBOutlet weak var orderdFoodNumberLabel: UILabel!
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodTimeLabel: UILabel!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var foodPriceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //181E25
        foodTimeLabel.textColor = .white
        //foodNameLabel.textColor = .white
        foodPriceLabel.textColor = .white
       // orderdFoodNumberLabel.textColor = .white
        contentView.backgroundColor = #colorLiteral(red: 0.09411764706, green: 0.1176470588, blue: 0.1450980392, alpha: 1)
        contentView.layer.borderWidth = 3
        contentView.layer.borderColor = #colorLiteral(red: 1, green: 0.8431372549, blue: 0, alpha: 1)
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
