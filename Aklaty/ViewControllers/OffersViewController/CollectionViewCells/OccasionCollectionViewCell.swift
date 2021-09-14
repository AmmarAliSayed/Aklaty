//
//  OccasionCollectionViewCell.swift
//  Aklaty
//
//  Created by Macbook on 21/07/2021.
//

import UIKit
import Gemini
class OccasionCollectionViewCell: GeminiCell {
  //  @IBOutlet weak var occasionView: UIView!
    @IBOutlet weak var discountRateLabel: UILabel!
    @IBOutlet weak var offerImageView: UIImageView!
    
    @IBOutlet weak var occasionDateLabel: UILabel!
    @IBOutlet weak var occasionDateView: UIView!
    @IBOutlet weak var occasionTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
      //contentView.backgroundColor = #colorLiteral(red: 1, green: 0.8431372549, blue: 0, alpha: 1)
        contentView.layer.borderWidth = 3
      // contentView.layer.borderColor = #colorLiteral(red: 0.09411764706, green: 0.1176470588, blue: 0.1450980392, alpha: 1)
        contentView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        contentView.layer.masksToBounds = true
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 10
       
    }
  
}
