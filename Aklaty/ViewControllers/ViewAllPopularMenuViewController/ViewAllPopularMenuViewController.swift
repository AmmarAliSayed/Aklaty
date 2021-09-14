//
//  ViewAllPopularMenuViewController.swift
//  Aklaty
//
//  Created by Macbook on 27/07/2021.
//

import UIKit

class ViewAllPopularMenuViewController: UIViewController {
    //MARK: - IBOutlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var myCollectionView: UICollectionView!{
            didSet{
                myCollectionView.delegate = self
                myCollectionView.dataSource = self
            }
        }
    //MARK: - Vars
    var itemViewModel = PopularMenuItemViewModel()
    var items :[Item] = []
    //set margins of the cell
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    private let itemsPerRow: CGFloat = 2
    //MARK: - lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //hide tab bar
        self.tabBarController?.tabBar.isHidden = true
        itemViewModel.bindItemsViewModelToView = {
            self.loadItems()
        }
        //make searchBar textField color
        let textFieldInsideSearchBar = self.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.backgroundColor = #colorLiteral(red: 1, green: 0.8431372549, blue: 0, alpha: 1)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.myCollectionView.reloadData()
    }
    //MARK: - Load items from firebase
    
    private func loadItems() {
        items = itemViewModel.popularMenuItemsData
        self.myCollectionView.reloadData()
    }


}
extension ViewAllPopularMenuViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MenuCollectionViewCell.self) , for: indexPath) as? MenuCollectionViewCell else {
            return UICollectionViewCell()
        }
      //  Utilities.makeViewRounded(view: cell.menuView, cornerRadius: 10, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
//        cell.categoryView.layer.cornerRadius = 10
//        cell.categoryView.layer.borderWidth = 2
//        cell.categoryView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        cell.menuPriceLabel.text = "$ \(items[indexPath.row].price ?? 0.0)"
        cell.menuNameLabel.text = items[indexPath.row].name
            if items[indexPath.row].imageLinks.count > 0 {
                downloadImagesFromFirebase(imageUrls: [items[indexPath.row].imageLinks.first!]) { (images) in
                    DispatchQueue.main.async {
                        cell.menuImageView.image = images.first as? UIImage
                    }
                }
            }
          
            return cell
        }

     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let itemDetailsViewController = storyBoard.instantiateViewController(withIdentifier: "ItemDetailsViewController") as! PopularMenuItemDetailsViewController
        itemDetailsViewController.itemDetailsViewModel = self.itemViewModel.getItemDetailsViewModel(index: indexPath.row)
        self.navigationController?.pushViewController(itemDetailsViewController, animated: true)
    }
 
}

extension ViewAllPopularMenuViewController: UICollectionViewDelegateFlowLayout {
    
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


