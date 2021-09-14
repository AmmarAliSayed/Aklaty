//
//  BasketViewController.swift
//  Aklaty
//
//  Created by Macbook on 22/08/2021.
//

import UIKit
import JGProgressHUD

class BasketViewController: UIViewController {
    //MARK: - IBOutlets
        @IBOutlet weak var numberOfItemsInBasketLabel: UILabel!
        @IBOutlet weak var totalPriceInBasketLabel: UILabel!
        @IBOutlet weak var tabelView: UITableView!
        @IBOutlet weak var checkOutButtonOutlet: UIButton!
        //MARK: - Vars
        var basketHealthyFoodItems:[OrderedItem] = []
        var basketPopularMenuItems:[OrderedItem] = []
        var basketOrderedCategoryItems:[OrderedCategoryItem] = []
        var basketOrderedFreeDeliveryItems:[OrderedOffer] = []
        var basketOrderedTodayOfferItems:[OrderedOffer] = []
        var  viewModel : BasketViewModel!
       // var basket : Basket?
//    var viewModel : BasketViewModel! {
//        didSet{
//            self.loadCategoryItemsFromFirebase()
//        }
//    }
        var basketTotalNumberOfItems = 0
        let hud = JGProgressHUD(style: .dark)
        //var orderedItemIds : [String] = []
        //MARK: - Life Cycle
        override func viewDidLoad() {
            super.viewDidLoad()
            tabelView.dataSource = self
            tabelView.delegate = self
           
            
            
//            viewModel.bindBasketViewModelToView = {
//                self.loadBasketFromFirestore()
//            }

//
//            viewModel.bindCategoryItemsToView =  {
//                self.loadCategoryItemsFromFirebase()
//            }
//            viewModel.bindHealthyFoodItemsToView =  { [weak self] in
//                self?.loadHealthyItemsFromFirebase()
//            }
            
//            viewModel.shouldUpdateTotalLabels =  { flag in
//                self.updateTotalLabels(flag)
//            }
            
            
        }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // we must inialze BasketViewModel() in viewDidAppear() beacause we want call
       // loadBasketFromFirestore() when we add new item to the baseket 
        viewModel = BasketViewModel()
        
        viewModel.bindOrderedCategoryItemsToView =  {
            self.loadOrderedCategoryItemsFromFirebase()
            }
        viewModel.bindPopularMenuItemsToView =  {
            self.loadPopularItemsFromFirebase()
            }
        viewModel.bindHealthyFoodItemsToView =  {
            self.loadHealthyItemsFromFirebase()
            }
        viewModel.bindTodayOffersItemsToView =  {
            self.loadTodayOfferItemsFromFirebase()
            }
        viewModel.bindFreeDeliveryItemsToView =  {
            self.loadFreeDeliveryItemsFromFirebase()
            }
        
      //  loadBasketFromFirestore()
//        if returnBasketItemsNumber() > 0 {
//            self.tabelView.reloadData()
//            self.updateTotalLabels(false)
//
//        }else{
//            self.tabelView.reloadData()
//            self.updateTotalLabels(true)
//
//        }
        
        
    }
    //MARK: - IBActions
        @IBAction func checkOutButtonPressed(_ sender: Any) {
            
            if  viewModel.basketData != nil {
                
                self.emptyTheBasket()
                self.updateTotalLabels(true)
                self.showNotification(text: "you will receive a message on your phone has all details about receiving the products", isError: false)
            } else {
                self.showNotification(text: "Please add items frist!", isError: true)
            }
        }
    
    //MARK: - Helpers
//    private func loadBasketFromFirestore() {
//       // basket = viewModel.basketData
//        loadCategoryItemsFromFirebase()
//        loadHealthyItemsFromFirebase()
//        loadPopularItemsFromFirebase()
//
//    }
    func loadOrderedCategoryItemsFromFirebase(){
        self.basketOrderedCategoryItems = viewModel.basketOrderedCategoryItems
        self.updateTotalLabels(false)
        self.tabelView.reloadData()
    }
    func loadHealthyItemsFromFirebase(){
        self.basketHealthyFoodItems = viewModel.basketHealthyFood
        self.updateTotalLabels(false)
        self.tabelView.reloadData()
    }
    func loadPopularItemsFromFirebase(){
        self.basketPopularMenuItems = viewModel.basketPopularMenu
        self.updateTotalLabels(false)
        self.tabelView.reloadData()
    }
    func loadFreeDeliveryItemsFromFirebase(){
        self.basketOrderedFreeDeliveryItems = viewModel.basketFreeDeliveryItems
        self.updateTotalLabels(false)
        self.tabelView.reloadData()
    }
    func loadTodayOfferItemsFromFirebase(){
        self.basketOrderedTodayOfferItems = viewModel.basketTodayOffersItems
        self.updateTotalLabels(false)
        self.tabelView.reloadData()
    }
    private func updateTotalLabels(_ isEmpty: Bool) {
        
        if isEmpty {
            numberOfItemsInBasketLabel.text = "Items in basket: 0"
            totalPriceInBasketLabel.text = "Total price: $ \(returnBasketTotalPrice())"
        } else {
            numberOfItemsInBasketLabel.text = "Items in basket: \(returnBasketItemsNumber())"
            totalPriceInBasketLabel.text = "Total price: $ \(returnBasketTotalPrice())"
        }
        
        checkoutButtonStatusUpdate()
    }
    
    private func returnBasketItemsNumber() -> Int{
//        if let number =  viewModel.basketCategoryItems?.count , let number2 =  viewModel.basketPopularMenu?.count , let number3 =  viewModel.basketHealthyFood?.count{
//            return  number + number2 + number3
//        }else{
//            return 0
//        }
        
        var totalNum = 0
        for item in basketOrderedCategoryItems {
            totalNum += item.numOfOrders
        }
        
        for item in basketPopularMenuItems {
            totalNum += item.numOfOrders
        }
        
        for item in basketHealthyFoodItems {
            totalNum += item.numOfOrders
        }
        
        for item in basketOrderedTodayOfferItems {
            totalNum += item.numOfOrders
        }
        for item in basketOrderedFreeDeliveryItems {
            totalNum += item.numOfOrders
        }
        return totalNum
//          return  basketOrderedCategoryItems.count +  basketHealthyFoodItems.count +  basketPopularMenuItems.count
    }
    private func returnBasketTotalPrice() -> Double {
        
        var totalPrice = 0.0
        
//        if let basketCategoryItems =  viewModel.basketCategoryItems, let basketHealthyFood =  viewModel.basketPopularMenu , let basketPopularMenu =  viewModel.basketHealthyFood{
            
            for item in basketOrderedCategoryItems {
                totalPrice += item.price
            }
            
            for item in basketPopularMenuItems {
                totalPrice += item.price
            }
            
            for item in basketHealthyFoodItems {
                totalPrice += item.price
            }
            for item in basketOrderedTodayOfferItems {
                totalPrice += item.price
            }
            for item in basketOrderedFreeDeliveryItems {
                totalPrice += item.price
            }
        
            return totalPrice
//        }else{
//            return 0.0
//        }
        
        
    }
    
    private func removeCategoryItemFromBasket(itemId: String) {
        
        for i in 0..<viewModel.basketData.categoryItemsIds.count {
            
            if itemId == viewModel.basketData.categoryItemsIds[i] {
                viewModel.basketData.categoryItemsIds.remove(at: i)
                return
            }
        }
    }
    
    private func removePopularMenuFromBasket(itemId: String) {
      
        for i in 0..<viewModel.basketData.popularMenuIds.count {
                
                if itemId == viewModel.basketData.popularMenuIds[i] {
                    viewModel.basketData.popularMenuIds.remove(at: i)
                    return
                }
            }
        
       
    }
    private func removeHealthyFoodFromBasket(itemId: String) {
        
            for i in 0..<viewModel.basketData.healthyFoodIds.count {
                
                if itemId == viewModel.basketData.healthyFoodIds[i] {
                    viewModel.basketData.healthyFoodIds.remove(at: i)
                    return
                }
            }
        
       
    }
    private func removeFreeDeliveryFromBasket(itemId: String) {
        
        for i in 0..<viewModel.basketData.FreeDeliveryIds.count {
                
            if itemId == viewModel.basketData.FreeDeliveryIds[i] {
                viewModel.basketData.FreeDeliveryIds.remove(at: i)
                    return
                }
            }
        
       
    }
    private func removeTodayOfferFromBasket(itemId: String) {
        
        for i in 0..<viewModel.basketData.TodayOffersIds.count {
                
            if itemId == viewModel.basketData.TodayOffersIds[i] {
                viewModel.basketData.TodayOffersIds.remove(at: i)
                    return
                }
            }
        
       
    }
    //MARK: - Control checkoutButton
    
    private func checkoutButtonStatusUpdate() {
//        if let number =  viewModel.basketCategoryItems?.count , let number2 =  viewModel.basketPopularMenu?.count , let number3 =  viewModel.basketHealthyFood?.count{
//            checkOutButtonOutlet.isEnabled = number > 0 || number2 > 0 || number3 > 0
//        }else{
//
//        }
//
        checkOutButtonOutlet.isEnabled =  basketOrderedCategoryItems.count > 0 || basketPopularMenuItems.count > 0 || basketHealthyFoodItems.count > 0
            || basketOrderedTodayOfferItems.count > 0 || basketOrderedFreeDeliveryItems.count > 0
        
        if checkOutButtonOutlet.isEnabled {
            checkOutButtonOutlet.backgroundColor = #colorLiteral(red: 1, green: 0.8431372549, blue: 0, alpha: 1)
        } else {
            disableCheckoutButton()
        }
    }

    private func disableCheckoutButton() {
        checkOutButtonOutlet.isEnabled = false
        checkOutButtonOutlet.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
    }
    private func emptyTheBasket() {
        
        basketOrderedCategoryItems.removeAll()
        basketHealthyFoodItems.removeAll()
        basketPopularMenuItems.removeAll()
        basketOrderedTodayOfferItems.removeAll()
        basketOrderedFreeDeliveryItems.removeAll()
        tabelView.reloadData()
        
        if let basket = self.viewModel.basketData {
            basket.categoryItemsIds = []
            basket.popularMenuIds = []
            basket.healthyFoodIds = []
            basket.TodayOffersIds = []
            basket.FreeDeliveryIds = []
        }
        
        viewModel.updateBasketCategoryItems()
        viewModel.updateBasketPopularMenu()
        viewModel.updateBasketHealthyFood()
        viewModel.updateBasketTodayOffer()
        viewModel.updateBasketFreeDelivery()
    }
    private func showNotification(text: String, isError: Bool) {
        
        if isError {
            self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
        } else {
            self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        }
        
        self.hud.textLabel.text = text
        self.hud.show(in: self.view)
        self.hud.dismiss(afterDelay: 2.0)
    }
}
extension BasketViewController : UITableViewDataSource ,UITableViewDelegate {
    
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return basketOrderedCategoryItems.count
        case 1:
           return  basketPopularMenuItems.count
            
        case 2:
           return basketHealthyFoodItems.count
        case 3:
           return  basketOrderedTodayOfferItems.count
        case 4:
           return  basketOrderedFreeDeliveryItems.count
        default:
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BasketTableViewCell.self)) as? BasketTableViewCell else {
                return UITableViewCell()
            }
            
            cell.foodNameLabel.text = basketOrderedCategoryItems[indexPath.row].name
            cell.foodTimeLabel.text = basketOrderedCategoryItems[indexPath.row].time + " Min"
            cell.foodPriceLabel.text = "$ \(basketOrderedCategoryItems[indexPath.row].price ?? 0.0)"
            cell.orderdFoodNumberLabel.text = "\(basketOrderedCategoryItems[indexPath.row].numOfOrders ?? 0) Items"

            if basketOrderedCategoryItems[indexPath.row].imageLinks.count > 0 {
                downloadImagesFromFirebase(imageUrls: [basketOrderedCategoryItems[indexPath.row].imageLinks.first!]) { (images) in
                    DispatchQueue.main.async {
                        cell.foodImageView.image = images.first as? UIImage
                    }
                }
            }

            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BasketTableViewCell.self)) as? BasketTableViewCell else {
                return UITableViewCell()
            }
            cell.foodNameLabel.text = basketPopularMenuItems[indexPath.row].name
            cell.foodTimeLabel.text = basketPopularMenuItems[indexPath.row].time + " Min"
            cell.foodPriceLabel.text = "$ \(basketPopularMenuItems[indexPath.row].price ?? 0.0)"
            cell.orderdFoodNumberLabel.text = "\(basketPopularMenuItems[indexPath.row].numOfOrders ?? 0) Items"
            if basketPopularMenuItems[indexPath.row].imageLinks.count > 0 {
                downloadImagesFromFirebase(imageUrls: [basketPopularMenuItems[indexPath.row].imageLinks.first!]) { (images) in
                    DispatchQueue.main.async {
                        cell.foodImageView.image = images.first as? UIImage
                    }
                }
            }
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BasketTableViewCell.self)) as? BasketTableViewCell else {
                return UITableViewCell()
            }
            cell.foodNameLabel.text = basketHealthyFoodItems[indexPath.row].name
            cell.foodTimeLabel.text = basketHealthyFoodItems[indexPath.row].time + " Min"
            cell.foodPriceLabel.text = "$ \(basketHealthyFoodItems[indexPath.row].price ?? 0.0)"
            cell.orderdFoodNumberLabel.text = "\(basketHealthyFoodItems[indexPath.row].numOfOrders ?? 0) Items"
            if basketHealthyFoodItems[indexPath.row].imageLinks.count > 0 {
                downloadImagesFromFirebase(imageUrls: [basketHealthyFoodItems[indexPath.row].imageLinks.first!]) { (images) in
                    DispatchQueue.main.async {
                        cell.foodImageView.image = images.first as? UIImage
                    }
                }
            }
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BasketTableViewCell.self)) as? BasketTableViewCell else {
                return UITableViewCell()
            }
            cell.foodNameLabel.text = basketOrderedTodayOfferItems[indexPath.row].name
            cell.foodTimeLabel.text = basketOrderedTodayOfferItems[indexPath.row].time + " Min"
            cell.foodPriceLabel.text = "$ \(basketOrderedTodayOfferItems[indexPath.row].price ?? 0.0)"
            cell.orderdFoodNumberLabel.text = "\(basketOrderedTodayOfferItems[indexPath.row].numOfOrders ?? 0) Items"
            if basketOrderedTodayOfferItems[indexPath.row].imageLinks.count > 0 {
                downloadImagesFromFirebase(imageUrls: [basketOrderedTodayOfferItems[indexPath.row].imageLinks.first!]) { (images) in
                    DispatchQueue.main.async {
                        cell.foodImageView.image = images.first as? UIImage
                    }
                }
            }
            return cell
        case 4:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BasketTableViewCell.self)) as? BasketTableViewCell else {
                return UITableViewCell()
            }
            cell.foodNameLabel.text = basketOrderedFreeDeliveryItems[indexPath.row].name
            cell.foodTimeLabel.text = basketOrderedFreeDeliveryItems[indexPath.row].time + " Min"
            cell.foodPriceLabel.text = "$ \(basketOrderedFreeDeliveryItems[indexPath.row].price ?? 0.0)"
            cell.orderdFoodNumberLabel.text = "\(basketOrderedFreeDeliveryItems[indexPath.row].numOfOrders ?? 0) Items"
            if basketOrderedFreeDeliveryItems[indexPath.row].imageLinks.count > 0 {
                downloadImagesFromFirebase(imageUrls: [basketOrderedFreeDeliveryItems[indexPath.row].imageLinks.first!]) { (images) in
                    DispatchQueue.main.async {
                        cell.foodImageView.image = images.first as? UIImage
                    }
                }
            }
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var myTitle = ""
      
        switch (section) {
            case 0:
                myTitle = "Category Items"
            case 1:
                myTitle = "Popular Menu"
            case 2:
                myTitle = "Healthy Food"
            case 3:
                myTitle = "Toaday Offer"
            case 4:
                myTitle = "Free Delivery"
            default:
                break;
        }
        return  myTitle
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return 130
        case 1:
            return 130
        case 2:
            return 130
        case 3:
            return 130
        case 4:
            return 130
        default:
            return 130
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
        if editingStyle == .delete {
            
            switch indexPath.section {
            case 0:
             //   print("error updating the basket")
                let itemToDelete = basketOrderedCategoryItems[indexPath.row]
               basketOrderedCategoryItems.remove(at: indexPath.row)
                tabelView.reloadData()
                self.updateTotalLabels(false)
                removeCategoryItemFromBasket(itemId: itemToDelete.id)
                viewModel.updateBasketCategoryItems()
            case 1:
               // print("error updating the basket")
                let itemToDelete = basketPopularMenuItems[indexPath.row]
                basketPopularMenuItems.remove(at: indexPath.row)
                tabelView.reloadData()
                self.updateTotalLabels(false)
                removePopularMenuFromBasket(itemId: itemToDelete.id)
                viewModel.updateBasketPopularMenu()
            case 2:
                let itemToDelete = basketHealthyFoodItems[indexPath.row]
                basketHealthyFoodItems.remove(at: indexPath.row)
                tabelView.reloadData()
                self.updateTotalLabels(false)
                removeHealthyFoodFromBasket(itemId: itemToDelete.id)
                viewModel.updateBasketHealthyFood()
            case 3:
                let itemToDelete = basketOrderedTodayOfferItems[indexPath.row]
                basketOrderedTodayOfferItems.remove(at: indexPath.row)
                tabelView.reloadData()
                self.updateTotalLabels(false)
                removeTodayOfferFromBasket(itemId: itemToDelete.id)
                viewModel.updateBasketTodayOffer()
            case 4:
                let itemToDelete = basketOrderedFreeDeliveryItems[indexPath.row]
                basketOrderedFreeDeliveryItems.remove(at: indexPath.row)
                tabelView.reloadData()
                self.updateTotalLabels(false)
                removeFreeDeliveryFromBasket(itemId: itemToDelete.id)
                viewModel.updateBasketFreeDelivery()
            default:
                print("default")
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
//    //hide section name if no data in cells
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if (section == 0 && basketBooks.isEmpty) {
//            return 0.0
//        }
//        return 0.0
//    }
    
}
