//
//  CategoriesTableViewCell.swift
//  Aklaty
//
//  Created by Macbook on 15/07/2021.
//

import UIKit
import Gemini

protocol CategoryCellDelegate: class {
    func selectedCategoryIndex(categoryIndex: Int)
}
class CategoriesTableViewCell: UITableViewCell {
    //MARK: - Vars
    var categoryViewModel = CategoryViewModel()
    var categories :[Category] = []
    weak var delegate: CategoryCellDelegate?
    //MARK: - IBOutlets
    @IBOutlet weak var viewAllButtonOutlet: UIButton!
    @IBOutlet weak var CategoriesCollectionView: GeminiCollectionView!{
        didSet{
            CategoriesCollectionView.delegate = self
            CategoriesCollectionView.dataSource = self
            // Configure the animation type
            CategoriesCollectionView.gemini
                .scaleAnimation()
                .scale(0.75)
                .scaleEffect(.scaleUp) // or .scaleDown
           
            }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //make button rounded
        viewAllButtonOutlet.layer.cornerRadius = 10
        
        categoryViewModel.bindCategoriesViewModelToView = {
            self.loadCategories()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    //MARK: - Load categories from firebase
    
    private func loadCategories() {
        categories = categoryViewModel.categoriesData
        self.CategoriesCollectionView.reloadData()
    }
}
extension CategoriesTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = CategoriesCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CategoriesCollectionViewCell.self) , for: indexPath) as? CategoriesCollectionViewCell else {
            return UICollectionViewCell()
        }
        // Animate the cell
        self.CategoriesCollectionView.animateCell(cell)
    //    Utilities.makeViewRounded(view: cell.categoryView, cornerRadius: 10, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
       // Utilities.makeViewRounded(cell.categoryView)
        
        cell.categoryName.text = categories[indexPath.row].name
            
            if categories[indexPath.row].imageLinks.count > 0 {
                downloadImagesFromFirebase(imageUrls: [categories[indexPath.row].imageLinks.first!]) { (images) in
                    DispatchQueue.main.async {
                        cell.categoryImageView.image = images.first as? UIImage
                    }
                }
            }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     
        self.delegate?.selectedCategoryIndex(categoryIndex: indexPath.row)
   }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // Animate the cell  while scrolling
        self.CategoriesCollectionView.animateVisibleCells()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        // Animate
        if let cell = cell as? CategoriesCollectionViewCell {
            self.CategoriesCollectionView.animateCell(cell)
        }
        
    }
    
}
extension CategoriesTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
      //  return CGSize(width: 400, height: collectionView.bounds.height)
        return CGSize(width: 150, height: 120)
       
    }
    
  
}
