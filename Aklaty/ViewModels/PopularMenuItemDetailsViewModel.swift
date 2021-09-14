//
//  ItemDetailsViewModel.swift
//  Aklaty
//
//  Created by Macbook on 05/08/2021.
//

import Foundation
import FirebaseAuth

class PopularMenuItemDetailsViewModel: NSObject {
    //property from model
    var fireStoreService : FireStoreService!
    var authenticationService : AuthenticationService!
   var selectedItem :Item!
    //property to get the data when success
    var itemData : Item!{
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
    init( item : Item) {
        super.init()
        self.fireStoreService = FireStoreService()
        self.authenticationService = AuthenticationService()
        self.selectedItem = item
        self.fetchItemDataFromApi()
        self.fetchReviews()
    }
    
    func fetchItemDataFromApi(){
        if let  id = selectedItem.id {
            fireStoreService.retrievePopularMenuItemDetailsFromFirebase(id) { [weak self] (item) in
                self?.itemData = item
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
        
        if let  id = selectedItem.id {
            fireStoreService.retrieveItemReviewsFromFirebase(id) { [weak self](reviews) in
                self?.ItemReviewsData = reviews
            }
        }else{
            print("error")
        }
    }
    func addOrderedPopularMenuItemToFirebase(item : OrderedItem){
        fireStoreService.saveOrderedPopularMenuItemToFirestore(item) { (error) in
            if let error :Error = error{
                     let message = error.localizedDescription
                        print("\(message)")
                       }else{
                        print("Registration operation done!")
                     }
        }
    }
    
    func saveOrderedPopularMenuItemToBasket(item : OrderedItem){
        if Auth.auth().currentUser != nil {
            //createNewBasket()
            fireStoreService.downloadBasketFromFirestore(Auth.auth().currentUser!.uid) { (basket) in

                if basket == nil {
                    self.createNewBasket()
                } else {
                    basket!.popularMenuIds.append(item.id)
                    self.updateBasket(basket: basket!, withValues: [ K.BasketFStore.popularMenuIds  : basket!.popularMenuIds])
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
        if let itemId = itemData.id  {
            newBasket.popularMenuIds  = [itemId]
        
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
