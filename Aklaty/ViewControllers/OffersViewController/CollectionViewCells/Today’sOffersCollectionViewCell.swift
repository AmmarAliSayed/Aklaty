//
//  Today’sOffersCollectionViewCell.swift
//  Aklaty
//
//  Created by Macbook on 22/07/2021.
//

import UIKit
import Gemini
class Today_sOffersCollectionViewCell: GeminiCell {
    
    @IBOutlet weak var discountRateLabel: UILabel!
    @IBOutlet weak var offerImageView: UIImageView!
    @IBOutlet weak var offerTimeLabel: UILabel!
    @IBOutlet weak var offerNameLabel: UILabel!
    @IBOutlet weak var offerPriceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        offerPriceLabel.textColor = #colorLiteral(red: 1, green: 0.8431372549, blue: 0, alpha: 1)
        offerTimeLabel.textColor = .white
        offerNameLabel.textColor = #colorLiteral(red: 1, green: 0.8431372549, blue: 0, alpha: 1)
        discountRateLabel.textColor = .white
        contentView.backgroundColor = #colorLiteral(red: 0.09411764706, green: 0.1176470588, blue: 0.1450980392, alpha: 1)
        contentView.layer.borderWidth = 3
        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.layer.masksToBounds = true
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = contentView.frame.size.width / 30
       
    }
}
