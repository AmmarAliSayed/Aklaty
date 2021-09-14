//
//  OffersViewController.swift
//  Aklaty
//
//  Created by Macbook on 17/07/2021.
//

import UIKit


class OffersViewController: UIViewController{
   
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    //MARK: - Vars
    var todayOfferViewModel = TodayOfferViewModel()
    var freeDeliveryOfferViewModel = FreeDeliveryOfferViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //show tab bar
        self.tabBarController?.tabBar.isHidden = false
    }
    

}

extension OffersViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Configure the cell...
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: OccasionTableViewCell.self)) as? OccasionTableViewCell else {
                return UITableViewCell()
            }
            // set delegate
           // cell.delegate = self
            //cell.BooksCollectionView.reloadData()
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: Today_sOffersTableViewCell.self)) as? Today_sOffersTableViewCell else {
                return UITableViewCell()
            }
            // set delegate
            cell.delegate = self
            return cell

        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FreeDeliveryTableViewCell.self)) as? FreeDeliveryTableViewCell else {
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
             return 200
         case 1:
             return 290
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
extension OffersViewController : Today_sOffersCellDelegate{
    func selectedItemIndex(itemIndex: Int) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let todayOfferItemDetailsViewController = storyBoard.instantiateViewController(withIdentifier: "TodayOfferItemDetailsViewController") as! TodayOfferItemDetailsViewController
        todayOfferItemDetailsViewController.itemDetailsViewModel = self.todayOfferViewModel.getOfferDetailsViewModel(index: itemIndex)
        self.navigationController?.pushViewController(todayOfferItemDetailsViewController, animated: true)

    }
    
}
extension OffersViewController : FreeDeliveryOffersCellDelegate{
    func selectedFreeDeliveryOfferIndex(itemIndex: Int) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let freeDeliveryItemDetailsViewController = storyBoard.instantiateViewController(withIdentifier: "FreeDeliveryItemDetailsViewController") as! FreeDeliveryItemDetailsViewController
        freeDeliveryItemDetailsViewController.itemDetailsViewModel = self.freeDeliveryOfferViewModel.getOfferDetailsViewModel(index: itemIndex)
        self.navigationController?.pushViewController(freeDeliveryItemDetailsViewController, animated: true)

    }
    }


