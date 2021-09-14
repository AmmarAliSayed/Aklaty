//
//  IntroCollectionViewCell.swift
//  Maktabty
//
//  Created by Macbook on 05/05/2021.
//

import UIKit

class IntroCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var introImage: UIImageView!
    @IBOutlet weak var titlelable: UILabel!
    @IBOutlet weak var discriptionLabel: UILabel!
    
    
    static let idintfier = String(describing: IntroCollectionViewCell.self)
    
    func ConfigureCell(_ onBoard:IntroDataModel) {
        
        introImage.image = onBoard.images
        titlelable.text = onBoard.title
        discriptionLabel.text = onBoard.discreption
    }
}
