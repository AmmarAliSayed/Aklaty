//
//  ItemViewModel.swift
//  Aklaty
//
//  Created by Macbook on 02/08/2021.
//

import Foundation
import FirebaseAuth
class CategoryItemDetailsViewModel: NSObject {
    //property from model
    var fireStoreService : FireStoreService!
    var authenticationService : AuthenticationService!
   var selectedCategoryItem : CategoryItem!
    //property to get the data when success
    var categoryItemData : CategoryItem!{
        didSet{
            //we add listener her so when we set the employeeData property we will call
            //bindEmplyeesViewModelToView() function type so this is a callback because I do not know when
            //the data come ->Asynchronous
            self.bindItemViewModelToView()
        }
    }
    var ItemReviewsData : [Review]!{
        didSet{
           //we add listener her so when we set the employeeData property we will call
            //bindEmplyeesViewModelToView() function type so this is a callback because I do not know when
                //the data come ->Asynchronous
            self.bindItemReviewsViewModelToView()
            }
    }
    //function type - property
    var bindItemViewModelToView : (()->()) = {}
    var bindItemReviewsViewModelToView : (()->()) = {}
    var shouldShowAlert: ((_ message: String) -> ()) = {_ in }
    //inilizer
    init( item : CategoryItem) {
        super.init()
        self.fireStoreService = FireStoreService()
        self.authenticationService = AuthenticationService()
        self.selectedCategoryItem = item
        self.fetchItemDataFromApi()
        self.fetchReviews()
    }
    
    func fetchItemDataFromApi(){
        if let  id = selectedCategoryItem.id {
            fireStoreService.retrieveCategoryItemDetailsFromFirebase(id) { [weak self] (item) in
                
                self?.categoryItemData = item
        }
        }else{
            print("error")
        }
    }
    
    func addNewReview(review : Review){
        fireStoreService.saveItemReviewsToFirestore(review) { (error) in
            if error == nil {
                print("save!")
            } else {
                print("error", error!.localizedDescription)
        }
        }
    }
    func fetchReviews(){
        
        if let  id = selectedCategoryItem.id {
            fireStoreService.retrieveItemReviewsFromFirebase(id) { [weak self](reviews) in
                self?.ItemReviewsData = reviews
            }
        }else{
            print("error")
        }
    }
//    func updateCategoryItemPrice(updatedPrice : Double){
//        fireStoreService.updateCategoryItemInFirestore(categoryItemData, withValues: [K.CategoryItemFStore.updatedPriceField : updatedPrice]) { (error) in
//            if error != nil {
//                print("error updating the basket", error!.localizedDescription)
//            }
//            // call fetchItemDataFromApi() method because we update items and we need to get the latest items after update -> refresh items
//            self.fetchItemDataFromApi()
//        }
//    }

    func addOrderedCategoryItemToFirebase(OrderdCategoryItem : OrderedCategoryItem){
        fireStoreService.saveOrderedCategoryItemToFirestore(OrderdCategoryItem) { (error) in
            if let error :Error = error{
                                    let message = error.localizedDescription
                                    print("\(message)")
                                }else{
                                    print("Registration operation done!")
                                }
        }
    }
    
    func saveOrderedCategoryItemToBasket(OrderdCategoryItem : OrderedCategoryItem){
        if Auth.auth().currentUser != nil {
            //createNewBasket()
            fireStoreService.downloadBasketFromFirestore(Auth.auth().currentUser!.uid) { (basket) in

                if basket == nil {
                    self.createNewBasket()
                } else {
                    basket!.categoryItemsIds.append(OrderdCategoryItem.id)
                    self.updateBasket(basket: basket!, withValues: [ K.BasketFStore.CategoryItemsIds  : basket!.categoryItemsIds])
                }
            }
        }else{
            //
        }
        
    }
    private func createNewBasket() {
        
        let id = UUID().uuidString
        let curruntUserId = Auth.auth().currentUser!.uid
        let newBasket = Basket()
        newBasket.basketId = id
        newBasket.ownerId = curruntUserId
        if let itemId = categoryItemData.id  {
            newBasket.categoryItemsIds  = [itemId]
        
        fireStoreService.saveBasketToFirestore(newBasket)
        
            self.shouldShowAlert("Added to basket!")
    }
}
    //if user has allready a basket ,update basket for him
    private func updateBasket(basket: Basket, withValues: [String : Any]) {
        
        fireStoreService .updateBasketInFirestore(basket, withValues: withValues) { (error) in
            //if  an error happend
            if error != nil {
                self.shouldShowAlert("Error: \(error!.localizedDescription)")
                print("error updating basket", error!.localizedDescription)
            } else {
                self.shouldShowAlert("Added to basket!")
            }
        }
    }
}
