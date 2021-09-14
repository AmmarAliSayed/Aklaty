//
//  HomeViewController.swift
//  Aklaty
//
//  Created by Macbook on 15/07/2021.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    //MARK: - Vars
    var homeUserNameViewModel = HomeUserNameViewModel()
    var categoryViewModel = CategoryViewModel()
    var menuItemViewModel = PopularMenuItemViewModel()
    var healthyFoodItemViewModel = HealthyFoodItemViewModel()
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        homeUserNameViewModel.bindUserNameViewModelToView = {
            self.updateuserNameLabel()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    //MARK: - helper functions
    func updateuserNameLabel(){
        userNameLabel.text = homeUserNameViewModel.userData.name
       
    }
}

extension HomeViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Configure the cell...
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CategoriesTableViewCell.self)) as? CategoriesTableViewCell else {
                return UITableViewCell()
            }
            // set delegate
           cell.delegate = self
            //cell.BooksCollectionView.reloadData()
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MenuTableViewCell.self)) as? MenuTableViewCell else {
                return UITableViewCell()
            }
            // set delegate
            cell.delegate = self
            return cell

        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HealthyFoodTableViewCell.self)) as? HealthyFoodTableViewCell else {
                return UITableViewCell()
            }
            // set delegate
            cell.delegate = self
            return cell

        default:
            return UITableViewCell()
        
    }
    
    
}
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         
         switch indexPath.row {
         case 0:
             return 180
         case 1:
             return 250
         case 2:
             return 300
         default:
             return 100
         }
     }
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
     }
}
extension HomeViewController : CategoryCellDelegate{
    func selectedCategoryIndex(categoryIndex: Int) {
              guard let categoryItemsViewController = self.storyboard?.instantiateViewController(identifier: String(describing: CategoryItemsViewController.self)) as? CategoryItemsViewController else {
                    return
                }
        categoryItemsViewController.categoryItemsViewModel = self.categoryViewModel.getCategoryItemsViewModel(for: categoryIndex)
        
        self.navigationController?.pushViewController(categoryItemsViewController, animated: true)

    }
    
}
extension HomeViewController :MenuCellDelegate{
    func selectedItemIndex(itemIndex: Int) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let itemDetailsViewController = storyBoard.instantiateViewController(withIdentifier: "ItemDetailsViewController") as! PopularMenuItemDetailsViewController
        itemDetailsViewController.itemDetailsViewModel = self.menuItemViewModel.getItemDetailsViewModel(index: itemIndex)
        self.navigationController?.pushViewController(itemDetailsViewController, animated: true)

    }
}
extension HomeViewController :HealthyFoodCellDelegate{
    func selectedHealthyFoodItemIndex(index: Int) {
           let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
           let itemDetailsViewController = storyBoard.instantiateViewController(withIdentifier: "HealthyFoodItemDetailsViewController") as! HealthyFoodItemDetailsViewController
           itemDetailsViewController.itemDetailsViewModel = self.healthyFoodItemViewModel.getItemDetailsViewModel(index: index)
           self.navigationController?.pushViewController(itemDetailsViewController, animated: true)
    }
    
    
}
