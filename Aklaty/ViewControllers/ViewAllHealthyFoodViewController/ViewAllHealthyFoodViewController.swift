//
//  ViewAllHealthyFoodViewController.swift
//  Aklaty
//
//  Created by Macbook on 27/07/2021.
//

import UIKit

class ViewAllHealthyFoodViewController: UIViewController {
    //MARK: - IBOutlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var myCollectionView: UICollectionView!{
            didSet{
                myCollectionView.delegate = self
                myCollectionView.dataSource = self
            }
        }
    //MARK: - Vars
    var itemViewModel = HealthyFoodItemViewModel()
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
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
//        itemViewModel.bindItemsViewModelToView = {
//            self.loadItems()
//        }
        self.myCollectionView.reloadData()
        //make searchBar textField color
        let textFieldInsideSearchBar = self.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.backgroundColor = #colorLiteral(red: 1, green: 0.8431372549, blue: 0, alpha: 1)
    }
    //MARK: - Load items from firebase
    
    private func loadItems() {
        items = itemViewModel.healthyFoodItemsData
        self.myCollectionView.reloadData()
    }
}
extension ViewAllHealthyFoodViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HealthyFoodCollectionViewCell.self) , for: indexPath) as? HealthyFoodCollectionViewCell else {
            return UICollectionViewCell()
        }
      //  Utilities.makeViewRounded(view: cell.healthyView, cornerRadius: 10, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
//        cell.categoryView.layer.cornerRadius = 10
//        cell.categoryView.layer.borderWidth = 2
//        cell.categoryView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
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
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let itemDetailsViewController = storyBoard.instantiateViewController(withIdentifier: "HealthyFoodItemDetailsViewController") as! HealthyFoodItemDetailsViewController
        itemDetailsViewController.itemDetailsViewModel = self.itemViewModel.getItemDetailsViewModel(index: indexPath.row)
        self.navigationController?.pushViewController(itemDetailsViewController, animated: true)
    }
 
}

extension ViewAllHealthyFoodViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
//        let availableWidth = view.frame.width - paddingSpace
//        let withPerItem = availableWidth / itemsPerRow
        //return CGSize(width: withPerItem, height: withPerItem)
       
        let width = (view.frame.size.width - 30) / 2
        //let height = (view.frame.size.width ) / 2
        return CGSize(width: width, height: 170)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return sectionInsets.left

    }
}


