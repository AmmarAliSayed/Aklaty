//
//  ViewAllCategoriesViewController.swift
//  Aklaty
//
//  Created by Macbook on 27/07/2021.
//

import UIKit
import JGProgressHUD
import NVActivityIndicatorView
class ViewAllCategoriesViewController: UIViewController {
    //MARK: - IBOutlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var myCollectionView: UICollectionView!{
            didSet{
                myCollectionView.delegate = self
                myCollectionView.dataSource = self
            }
        }
    //MARK: - Vars
    var categoryViewModel : CategoryViewModel!
    var categories :[Category] = []
    var filteredCategories : [Category] = []
    var isSearching = false
    let hud = JGProgressHUD(style: .dark)
    var activityIdicator: NVActivityIndicatorView?
    //set margins of the cell
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    private let itemsPerRow: CGFloat = 2
    //MARK: - lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //hide tab bar
        self.tabBarController?.tabBar.isHidden = true
        //self.searchBar.setSearchFieldBackgroundImage(UIImage(named: "SearchFieldBackground"), for: UIControl.State.normal)
        //make searchBar textField color
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.backgroundColor = #colorLiteral(red: 1, green: 0.8431372549, blue: 0, alpha: 1)
        searchBar.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        activityIdicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60.0, height: 60.0), type: .ballPulse, color: #colorLiteral(red: 1, green: 0.8431372549, blue: 0, alpha: 1), padding: nil)
       // self.myCollectionView.reloadData()
        categoryViewModel = CategoryViewModel()
       categoryViewModel.bindCategoriesViewModelToView = {
           self.loadCategories()
       }
        categoryViewModel.bindfilteredCategoriesToView = {
            self.loadFilteredCategories()
        }
    }
    //MARK: - Load categories from firebase
    
    private func loadCategories() {
        categories = categoryViewModel.categoriesData
        self.myCollectionView.reloadData()
    }
    private func loadFilteredCategories() {
        filteredCategories = categoryViewModel.filteredItemsData
        self.myCollectionView.reloadData()
    }
    //MARK: - Activity Indicator
    
    private func showLoadingIdicator() {
        
        if activityIdicator != nil {
            self.view.addSubview(activityIdicator!)
            activityIdicator!.startAnimating()
        }
        
    }

    private func hideLoadingIdicator() {
        
        if activityIdicator != nil {
            activityIdicator!.removeFromSuperview()
            activityIdicator!.stopAnimating()
        }
    }
    

}
extension ViewAllCategoriesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        if (isSearching) {
            return  filteredCategories.count
           }
           else {
            return categories.count
           }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CategoriesCollectionViewCell.self) , for: indexPath) as? CategoriesCollectionViewCell else {
            return UICollectionViewCell()
        }
        if isSearching {
            cell.categoryName.text = filteredCategories[indexPath.row].name
            if filteredCategories[indexPath.row].imageLinks.count > 0 {
                downloadImagesFromFirebase(imageUrls: [filteredCategories[indexPath.row].imageLinks.first!]) { (images) in
                    DispatchQueue.main.async {
                        cell.categoryImageView.image = images.first as? UIImage
                    }
                }
        }
        }else{
            cell.categoryName.text = categories[indexPath.row].name
                
                if categories[indexPath.row].imageLinks.count > 0 {
                    downloadImagesFromFirebase(imageUrls: [categories[indexPath.row].imageLinks.first!]) { (images) in
                        DispatchQueue.main.async {
                            cell.categoryImageView.image = images.first as? UIImage
                        }
                    }
            }
        }
        
        cell.contentView.backgroundColor = .black
            return cell
        }

     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "categoryToCategoryItemsSeg", sender: indexPath)
    }
    //MARK: Navigation
    //called before segue operation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "categoryToCategoryItemsSeg"{
            guard let selectedIndexPath = sender as? NSIndexPath else{ return }
              let categoryItemsViewController = segue.destination as! CategoryItemsViewController
            categoryItemsViewController.categoryItemsViewModel = self.categoryViewModel.getCategoryItemsViewModel(for: selectedIndexPath.row)
          }
    }
}

extension ViewAllCategoriesViewController: UICollectionViewDelegateFlowLayout {
    
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


extension ViewAllCategoriesViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText.count != 0) {
            isSearching = true
            categoryViewModel.searchInFirebase(forName: searchText)
        }else{
            self.hideLoadingIdicator()
            isSearching = false
        }
        self.myCollectionView.reloadData()
    
      }
    }
       
