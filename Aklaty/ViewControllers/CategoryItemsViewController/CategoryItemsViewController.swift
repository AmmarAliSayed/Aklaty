//
//  CategoryItemsViewController.swift
//  Aklaty
//
//  Created by Macbook on 28/07/2021.
//

import UIKit

class CategoryItemsViewController: UIViewController {
    //MARK: - IBOutlets
        @IBOutlet weak var myCollectionView: UICollectionView!{
            didSet{
                myCollectionView.delegate = self
                myCollectionView.dataSource = self
            }
        }
    @IBOutlet weak var searchBar: UISearchBar!
    //MARK: - Vars
    var categoryItemsViewModel : CategoryItemsViewModel!
    var categoryItems :[CategoryItem] = []
    //set margins of the cell
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    private let itemsPerRow: CGFloat = 2
    //MARK: - lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
      //  print(CategoryItemsViewModel.selectedCateggory.name ?? "default value")
        categoryItemsViewModel.bindCategoryItemsViewModelToView = {
            self.loadCategoryItems()
            //make searchBar textField color
            let textFieldInsideSearchBar = self.searchBar.value(forKey: "searchField") as? UITextField
            textFieldInsideSearchBar?.backgroundColor = #colorLiteral(red: 1, green: 0.8431372549, blue: 0, alpha: 1)
            
    }
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(true)
////        CategoryItemsViewModel.bindCategoryItemsViewModelToView = {
////            self.loadCategoryItems()
////        }
//        //categoryItemsViewModel = CategoryItemsViewModel()
//       
//        }
    }
    
    //MARK: - Load categories from firebase
    
    private func loadCategoryItems() {
        categoryItems = categoryItemsViewModel.categoryItemsData
        self.myCollectionView.reloadData()
    }
    //MARK: Navigation
    //called before segue operation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "categoryItemsToAddSeg"{
              let addItemToCategoryViewController = segue.destination as! AddItemToCategoryViewController
            addItemToCategoryViewController.addItemCategoryViewModel = self.categoryItemsViewModel.getAddItemToCategoryViewModel()
          }
    }

}
extension CategoryItemsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryItems.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CategoriesCollectionViewCell.self) , for: indexPath) as? CategoriesCollectionViewCell else {
            return UICollectionViewCell()
        }
      //  Utilities.makeViewRounded(cell.categoryView)
        Utilities.makeViewRounded(view: cell.categoryView, cornerRadius: 10, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
//        cell.categoryView.layer.cornerRadius = 10
//        cell.categoryView.layer.borderWidth = 2
//        cell.categoryView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        cell.categoryName.text = categoryItems[indexPath.row].name
            
            if categoryItems[indexPath.row].imageLinks.count > 0 {
                downloadImagesFromFirebase(imageUrls: [categoryItems[indexPath.row].imageLinks.first!]) { (images) in
                    DispatchQueue.main.async {
                        cell.categoryImageView.image = images.first as? UIImage
                    }
                }
            }
          
            return cell
        }

     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       // performSegue(withIdentifier: "categoryToCategoryItemsSeg", sender: indexPath)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let itemDetailsViewController = storyBoard.instantiateViewController(withIdentifier: "CategoryItemDetailsViewController") as! CategoryItemDetailsViewController
        itemDetailsViewController.categoryItemDetailsViewModel = self.categoryItemsViewModel.getCategoryItemDetailsViewModel(index: indexPath.row)
        self.navigationController?.pushViewController(itemDetailsViewController, animated: true)

    }
    
}
extension CategoryItemsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
//        let availableWidth = view.frame.width - paddingSpace
//        let withPerItem = availableWidth / itemsPerRow
        //return CGSize(width: withPerItem, height: withPerItem)
       
        let size = (view.frame.size.width - 30) / 2
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return sectionInsets.left

    }
}
