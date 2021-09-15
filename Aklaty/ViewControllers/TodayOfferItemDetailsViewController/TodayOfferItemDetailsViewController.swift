//
//  TodayOfferItemDetailsViewController.swift
//  Aklaty
//
//  Created by Macbook on 13/09/2021.
//

import UIKit
import JGProgressHUD
import NVActivityIndicatorView
import Gallery
class TodayOfferItemDetailsViewController: UIViewController {

    //MARK: - outlets
        @IBOutlet weak var tableView: UITableView!{
            didSet{
                tableView.delegate = self
                tableView.dataSource = self
            }
        }
        @IBOutlet weak var discountRateLabel: UILabel!
        @IBOutlet weak var reviewTextField: UITextField!
        @IBOutlet weak var orderNumberLabel: UILabel!
        @IBOutlet weak var itemImageView: UIImageView!
        @IBOutlet weak var nameLabel: UILabel!
       // @IBOutlet weak var descriptionLabel: UILabel!
        @IBOutlet weak var timeLabel: UILabel!
        @IBOutlet weak var priceLabel: UILabel!
        //@IBOutlet weak var coloriesLabel: UILabel!
        @IBOutlet weak var reviewView: UIView!
        @IBOutlet weak var noOfOrdersView: UIView!
        @IBOutlet weak var mainView: UIView!
        
        //MARK: - Vars
        var itemReviews :[Review] = []
        var userImages : [String] = []
        var itemDetailsViewModel : TodayOfferDetailsViewModel!
        var userDetailsViewModel : UserDetailsViewModel!
        var orderNum :Int = 1
        var newPrice :Double = 0.0
        var oldPrice :Double = 0.0
        let hud = JGProgressHUD(style: .dark)
        //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.makeViewRounded(view: mainView, cornerRadius: 30, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        Utilities.makeViewRounded(view: noOfOrdersView, cornerRadius: 10, color: #colorLiteral(red: 0.9764705882, green: 0.9764705882, blue: 0.9764705882, alpha: 1))
        Utilities.makeViewRounded(view: reviewView, cornerRadius: 30, color: #colorLiteral(red: 0.9764705882, green: 0.9764705882, blue: 0.9764705882, alpha: 1))
        //hide tab bar
        self.tabBarController?.tabBar.isHidden = true
        
        itemDetailsViewModel.bindItemViewModelToView = { [weak self] in
            self?.updateItem()
        }

        itemDetailsViewModel.bindItemReviewsViewModelToView = { [weak self] in
            self?.loadItemReviews()
        }
        itemDetailsViewModel.shouldShowAlert = { str in
            self.showBasketAlert(message: str)
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        userDetailsViewModel = UserDetailsViewModel()
        userDetailsViewModel.bindUserDetailsViewModelToView = {
           self.addUserImage()
           }
        }
    //MARK: - IBActions
     @IBAction func orderButtonPressed(_ sender: Any) {
         
        addNewOrderedItem()
     }
     @IBAction func decreaseOrderNumberButtonPressed(_ sender: Any) {
        if orderNum > 1{
            orderNum -= 1
            orderNumberLabel.text = "\(Int(orderNum))"
            newPrice = oldPrice * Double(orderNum)
            priceLabel.text = "$\(newPrice)"
        }
        
     }
     @IBAction func increaseOrderNumberButtonPressed(_ sender: Any) {

        orderNum += 1
        orderNumberLabel.text = "\(Int(orderNum))"
//        if var price = categoryItemDetailsViewModel.categoryItemData.price{
//            price *= orderNum
//            priceLabel.text = "$\(price)"
//            //update price in firebase
//            categoryItemDetailsViewModel.updateCategoryItemPrice(updatedPrice: price)
//        }
        newPrice = oldPrice * Double(orderNum)
        priceLabel.text = "$\(newPrice)"
     }
     @IBAction func addNewReviewButtonPressed(_ sender: Any) {
         if textFieldsHaveText(){
             addReview()
         }else{
             showRequiredFieldsAlert()
         }
        
     }
     //MARK: - Helpers
     
     func updateItem(){
         nameLabel.text = itemDetailsViewModel.itemData.name
        discountRateLabel.text = "\(itemDetailsViewModel.itemData.discountRate ?? 0)% OFF"
         timeLabel.text = itemDetailsViewModel.itemData.time
         if let price = itemDetailsViewModel.itemData.price{
             priceLabel.text = "$\(price)"
             newPrice = price
             oldPrice = price
            // coloriesLabel.text = "\(calories)"
         }
         if itemDetailsViewModel.itemData.imageLinks.count > 0 {
             downloadImagesFromFirebase(imageUrls: [itemDetailsViewModel.itemData.imageLinks.first!]) { (images) in
                 DispatchQueue.main.async { [weak self] in
                     self!.itemImageView.image = images.first as? UIImage
                 }
             }
         }
     }
    func addNewOrderedItem(){
        let item = OrderedOffer()
        item.id = itemDetailsViewModel.itemData.id
        item.name = itemDetailsViewModel.itemData.name
        item.price = newPrice
        item.numOfOrders = orderNum
        item.time = itemDetailsViewModel.itemData.time
        item.imageLinks = itemDetailsViewModel.itemData.imageLinks
        itemDetailsViewModel.addOrderedTodayOfferToFirebase(item: item)
        itemDetailsViewModel.saveOrderedTodayOfferToBasket(item: item)
    }
    
     private func loadItemReviews() {
         itemReviews = itemDetailsViewModel.ItemReviewsData
         self.tableView.reloadData()
     }
     //check that all textFields Have Text or not empty
     private func textFieldsHaveText() -> Bool {
         return (reviewTextField.text != "")
     }
     private func addReview(){
         let review = Review()
         let id = UUID().uuidString
         let reviewBody = reviewTextField.text
         review.id = id
         review.itemId = itemDetailsViewModel.itemData.id
         review.body = reviewBody
         review.userImageLinks = userImages
         reviewTextField.text = ""
        itemDetailsViewModel.addNewReview(review: review)
     }
    private func addUserImage(){
       userImages = userDetailsViewModel.userData.imageLinks
    }
     private func showRequiredFieldsAlert(){
         hud.textLabel.text = "Enter a new Review!"
         hud.indicatorView = JGProgressHUDErrorIndicatorView()
         hud.show(in: self.view)
         hud.dismiss(afterDelay: 2.0)
     }
    private func showBasketAlert(message :String) {
        self.hud.textLabel.text = message
        self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        self.hud.show(in: self.view)
        self.hud.dismiss(afterDelay: 2.0)
    }

}
extension TodayOfferItemDetailsViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return  itemReviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Configure the cell...
       
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ReviewTableViewCell.self)) as? ReviewTableViewCell else {
                return UITableViewCell()
            }
        Utilities.makeViewRounded(view: cell.cellView, cornerRadius:20, color: #colorLiteral(red: 0.9750739932, green: 0.9750967622, blue: 0.9750844836, alpha: 1))
        cell.userReviewLabel.text = itemReviews[indexPath.row].body
        cell.userImageView.layer.cornerRadius = cell.userImageView.frame.size.width/2
        cell.userImageView.layer.masksToBounds = true
        if (itemReviews[indexPath.row].userImageLinks.count) > 0 {
            downloadImagesFromFirebase(imageUrls:[(itemReviews[indexPath.row].userImageLinks.first!)]) { (images) in
                DispatchQueue.main.async {
                    cell.userImageView.image = images.first as? UIImage
                }
            }
        }
          return cell
        
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         
             return 100
         
     }
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
     }
}
