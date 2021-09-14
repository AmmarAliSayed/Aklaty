//
//  OccasionTableViewCell.swift
//  Aklaty
//
//  Created by Macbook on 21/07/2021.
//

import UIKit
import Gemini

class OccasionTableViewCell: UITableViewCell {
    //MARK: - Vars
    var occasionOfferViewModel = OccasionOfferViewModel()
    var offers :[OccasionOffer] = []
    
    //MARK: - IBOutlets
    @IBOutlet weak var addButtonOutlet: UIButton!
    @IBOutlet weak var occasionCollectionView: GeminiCollectionView!{
        didSet{
            occasionCollectionView.delegate = self
            occasionCollectionView.dataSource = self
            // Configure the animation type
            occasionCollectionView.gemini
                .scaleAnimation()
                .scale(0.75)
                .scaleEffect(.scaleUp) // or .scaleDown
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //make button rounded
        addButtonOutlet.layer.cornerRadius = 10
        
        occasionOfferViewModel.bindOccasionOfferViewModelToView = {
            self.loadOffers()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //MARK: - Load categories from firebase
    
    private func loadOffers() {
        offers = occasionOfferViewModel.occasionOffersData
        self.occasionCollectionView.reloadData()
    }

}
extension OccasionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return  offers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = occasionCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: OccasionCollectionViewCell.self) , for: indexPath) as? OccasionCollectionViewCell else {
            return UICollectionViewCell()
        }
        // Animate the cell
        self.occasionCollectionView.animateCell(cell)
        
        cell.occasionDateView.layer.cornerRadius = cell.contentView.frame.size.width/40
        cell.occasionDateView.clipsToBounds = true
        cell.occasionDateView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        cell.occasionDateView.layer.borderWidth = 1.0
        
        cell.occasionTitleLabel.text = offers[indexPath.row].offerDiscription
        cell.discountRateLabel.text = "\(offers[indexPath.row].discountRate ?? 0)%" 
        cell.occasionDateLabel.text = offers[indexPath.row].vaildTime
       
            if offers[indexPath.row].imageLinks.count > 0 {
                downloadImagesFromFirebase(imageUrls: [offers[indexPath.row].imageLinks.first!]) { (images) in
                    DispatchQueue.main.async {
                        cell.offerImageView.image = images.first as? UIImage
                    }
                }
            }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // Animate the cell  while scrolling
      self.occasionCollectionView.animateVisibleCells()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        // Animate
        if let cell = cell as? CategoriesCollectionViewCell {
            self.occasionCollectionView.animateCell(cell)
        }
        
    }
    
}
extension OccasionTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
      //  return CGSize(width: 400, height: collectionView.bounds.height)
        return CGSize(width: 400, height: 130)
       
    }
    
  
}
