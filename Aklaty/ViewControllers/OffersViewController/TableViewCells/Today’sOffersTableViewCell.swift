//
//  Today’sOffersTableViewCell.swift
//  Aklaty
//
//  Created by Macbook on 22/07/2021.
//

import UIKit
import Gemini

protocol  Today_sOffersCellDelegate: class {
    func selectedItemIndex(itemIndex: Int)
}
class Today_sOffersTableViewCell: UITableViewCell {

    //MARK: - Vars
    var OfferViewModel = TodayOfferViewModel()
    weak var delegate: Today_sOffersCellDelegate?
    var offers :[Offer] = []
    //MARK: - IBOutlets
    @IBOutlet weak var addButtonOutlet: UIButton!
    @IBOutlet weak var TodayOfferCollectionView: GeminiCollectionView!{
        didSet{
            TodayOfferCollectionView.delegate = self
            TodayOfferCollectionView.dataSource = self
            // Configure the animation type
            TodayOfferCollectionView.gemini
                .scaleAnimation()
                .scale(0.75)
                .scaleEffect(.scaleUp) // or .scaleDown
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addButtonOutlet.layer.cornerRadius = 10
        
        OfferViewModel.bindOfferViewModelToView = {
            self.loadOffers()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //MARK: - Load categories from firebase
    
    private func loadOffers() {
        offers = OfferViewModel.offersData
        self.TodayOfferCollectionView.reloadData()
    }
}
extension Today_sOffersTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return offers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = TodayOfferCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: Today_sOffersCollectionViewCell.self) , for: indexPath) as? Today_sOffersCollectionViewCell else {
            return UICollectionViewCell()
        }
        // Animate the cell
        self.TodayOfferCollectionView.animateCell(cell)
//
//        cell.occasionDateView.layer.cornerRadius = cell.occasionView.frame.size.width/40
//        cell.occasionDateView.clipsToBounds = true
//        cell.occasionDateView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//        cell.occasionDateView.layer.borderWidth = 1.0
        
        cell.offerNameLabel.text = offers[indexPath.row].name
        cell.discountRateLabel.text = "\(offers[indexPath.row].discountRate ?? 0)% OFF"
        cell.offerTimeLabel.text = "\(offers[indexPath.row].time ?? "") mins"
        cell.offerPriceLabel.text = "$ \(offers[indexPath.row].price ?? 0.0)"
       
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
     self.TodayOfferCollectionView.animateVisibleCells()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        // Animate
        if let cell = cell as? Today_sOffersCollectionViewCell {
           self.TodayOfferCollectionView.animateCell(cell)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     
        self.delegate?.selectedItemIndex(itemIndex: indexPath.row)
   }
}
extension Today_sOffersTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
      //  return CGSize(width: 400, height: collectionView.bounds.height)
        return CGSize(width: 200, height: 250)
       
    }
    
  
}
