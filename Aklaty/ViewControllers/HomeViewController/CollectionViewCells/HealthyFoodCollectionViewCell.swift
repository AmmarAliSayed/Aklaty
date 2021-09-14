//
//  HealthyFoodCollectionViewCell.swift
//  Aklaty
//
//  Created by Macbook on 16/07/2021.
//

import UIKit
import Gemini

class HealthyFoodCollectionViewCell: GeminiCell {
    @IBOutlet weak var healthyView: UIView!
    @IBOutlet weak var additionalHealthyFoodLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var calaroiesLabel: UILabel!
    @IBOutlet weak var healthyFoodNameLabel: UILabel!
    @IBOutlet weak var healthyImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       // contentView.backgroundColor = UIColor.white
        contentView.layer.borderWidth = 3
        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.layer.masksToBounds = true
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 10
       
    }
}
