//
//  MenuCollectionViewCell.swift
//  Aklaty
//
//  Created by Macbook on 15/07/2021.
//

import UIKit

class MenuCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var menuPriceLabel: UILabel!
    
    @IBOutlet weak var menuNameLabel: UILabel!
    @IBOutlet weak var menuImageView: UIImageView!
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
