//
//  CategoriesCollectionViewCell.swift
//  Aklaty
//
//  Created by Macbook on 15/07/2021.
//

import UIKit
import Gemini
class CategoriesCollectionViewCell: GeminiCell {
    
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryName: UILabel!
   
    @IBOutlet weak var categoryImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      //  contentView.backgroundColor = UIColor.white
        contentView.layer.borderWidth = 3
        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.layer.masksToBounds = true
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 10
       
    }
}
