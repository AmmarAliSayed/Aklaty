//
//  HealthyFoodTableViewCell.swift
//  Aklaty
//
//  Created by Macbook on 16/07/2021.
//

import UIKit
import Gemini
protocol HealthyFoodCellDelegate: class {
    func selectedHealthyFoodItemIndex(index: Int)
}
class HealthyFoodTableViewCell: UITableViewCell {
   
    @IBOutlet weak var viewAllButtonOutlet: UIButton!
    @IBOutlet weak var HealthyCollectionView: GeminiCollectionView!{
        didSet{
            HealthyCollectionView.delegate = self
            HealthyCollectionView.dataSource = self
            // Configure the animation type
            HealthyCollectionView.gemini
                .scaleAnimation()
                .scale(0.75)
                .scaleEffect(.scaleUp) // or .scaleDown
        }
    }
    //MARK: - Vars
    var itemViewModel = HealthyFoodItemViewModel()
    var items :[Item] = []
    weak var delegate: HealthyFoodCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // Initialization code
        itemViewModel.bindItemsViewModelToView = {
            self.loadItems()
        }
        //make button rounded
        viewAllButtonOutlet.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //MARK: - Load items from firebase
    
    private func loadItems() {
        items = itemViewModel.healthyFoodItemsData
        self.HealthyCollectionView.reloadData()
    }
}
extension HealthyFoodTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = HealthyCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HealthyFoodCollectionViewCell.self) , for: indexPath) as? HealthyFoodCollectionViewCell else {
            return UICollectionViewCell()
    }
        //make view rounded
        cell.healthyView.layer.cornerRadius = cell.healthyView.frame.size.width/10
        cell.healthyView.clipsToBounds = true
        cell.healthyView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        cell.healthyView.layer.borderWidth = 1.0
        // Animate the cell
        self.HealthyCollectionView.animateCell(cell)
        
        cell.priceLabel.text = "\(items[indexPath.row].price ?? 0.0)"
        cell.calaroiesLabel.text = "\(items[indexPath.row].calories ?? 0) calroies"
        cell.healthyFoodNameLabel.text = items[indexPath.row].name
       // cell.additionalHealthyFoodLabel.text = items[indexPath.row].description
            if items[indexPath.row].imageLinks.count > 0 {
                downloadImagesFromFirebase(imageUrls: [items[indexPath.row].imageLinks.first!]) { (images) in
                    DispatchQueue.main.async {
                        cell.healthyImageView.image = images.first as? UIImage
                    }
                }
            }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     
        self.delegate?.selectedHealthyFoodItemIndex(index: indexPath.row)
   }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // Animate the cell  while scrolling
        self.HealthyCollectionView.animateVisibleCells()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        // Animate
        if let cell = cell as? HealthyFoodCollectionViewCell {
            self.HealthyCollectionView.animateCell(cell)
        }
        
    }
}
