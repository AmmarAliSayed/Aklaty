//
//  BasketViewModel.swift
//  Aklaty
//
//  Created by Macbook on 22/08/2021.
//

import Foundation
import FirebaseAuth
class BasketViewModel: NSObject {
    //property from model
    var fireStoreService :  FireStoreService!
    var basketData: Basket!
   
    //property to get the data when success
    var basketHealthyFood:[OrderedItem]!{
        didSet{
            bindHealthyFoodItemsToView()
        }
    }
    var basketPopularMenu:[OrderedItem]!{
        didSet{
            bindPopularMenuItemsToView()
        }
    }
    var basketOrderedCategoryItems:[OrderedCategoryItem]!{
        didSet{
            bindOrderedCategoryItemsToView()
        }
    }
    var basketTodayOffersItems:[OrderedOffer]!{
        didSet{
            bindTodayOffersItemsToView()
        }
    }
    var basketFreeDeliveryItems:[OrderedOffer]!{
        didSet{
            bindFreeDeliveryItemsToView()
        }
    }
    var bindHealthyFoodItemsToView : (()->()) = {}
    var bindPopularMenuItemsToView : (()->()) = {}
    var bindOrderedCategoryItemsToView : (()->()) = {}
    var bindTodayOffersItemsToView : (()->()) = {}
    var bindFreeDeliveryItemsToView : (()->()) = {}
  //  var bindBasketViewModelToView : (()->()) = {}
   // var shouldUpdateTotalLabels: ((_ flag :Bool) -> ()) = {_ in }
    //inilizer
    override init() {
        super.init()
        self.fireStoreService = FireStoreService()
        self.loadBasketFromFirestore()
      //  self.getBasketCategoryItems()
        
    }
    
    private func loadBasketFromFirestore() {
        
        fireStoreService.downloadBasketFromFirestore(Auth.auth().currentUser!.uid) { [self] (basket) in

            if let  myBasket = basket{
                self.basketData = myBasket
                self.getBasketCategoryItems()
                self.getBasketPopularMenu()
                self.getBasketHealthyFoodItems()
                self.getFreeDeliveryItems()
                self.getBasketTodayOfferItems()
            }
            
        }
    }
    
    private func getBasketCategoryItems() {
        fireStoreService.downloadOrderedCategoryItemsForSpecificBasket(basketData.categoryItemsIds) { (items) in
            self.basketOrderedCategoryItems = items
               // self.shouldUpdateTotalLabels(false)
            }
        
    }
    private func getBasketPopularMenu() {
         fireStoreService.downloadOrderedPopularMenuItemForSpecificBasket(basketData.popularMenuIds) { (basketPopularMenuIds) in
                self.basketPopularMenu = basketPopularMenuIds
              //  self.shouldUpdateTotalLabels(false)
            }
    }
    private func getBasketHealthyFoodItems() {
        
            fireStoreService.downloadOrderedHealthyFoodItemsForSpecificBasket(basketData.healthyFoodIds) { (healthyFoodIds) in
                self.basketHealthyFood = healthyFoodIds
              //  self.shouldUpdateTotalLabels(false)
            }
    }
    private func getBasketTodayOfferItems() {
        
        fireStoreService.downloadOrderedTodayItemsForSpecificBasket(basketData.TodayOffersIds) { (ids) in
            self.basketTodayOffersItems = ids
              //  self.shouldUpdateTotalLabels(false)
            }
    }
    private func getFreeDeliveryItems() {
        
        fireStoreService.downloadFreeDeliveryItemsForSpecificBasket(basketData.FreeDeliveryIds) { (ids) in
            self.basketFreeDeliveryItems = ids
              //  self.shouldUpdateTotalLabels(false)
            }
    }
    
    func updateBasketCategoryItems(){
        if let basket = basketData{
            fireStoreService.updateBasketInFirestore(basket, withValues: [K.BasketFStore.CategoryItemsIds : basketData.categoryItemsIds])  { (error) in
        
                            if error != nil {
                                print("error updating the basket", error!.localizedDescription)
                            }
                            // call getBasketCategoryItems() method because we deleted items and we need to get the latest items after deletion -> refresh items
                            self.getBasketCategoryItems()
                           
                           
                        }
            }
        
      }
    
    func updateBasketPopularMenu(){
        if let basket = basketData{
            fireStoreService.updateBasketInFirestore(basket, withValues: [K.BasketFStore.popularMenuIds : basketData.popularMenuIds])  { (error) in
        
                            if error != nil {
                                print("error updating the basket", error!.localizedDescription)
                            }
                            // call updateBasketPopularMenu() method because we deleted items and we need to get the latest items after deletion -> refresh items
                                self.getBasketPopularMenu()
                              
                        }
            }
        
      }
    func updateBasketHealthyFood(){
        if let basket = basketData{
            fireStoreService.updateBasketInFirestore(basket, withValues: [K.BasketFStore.healthyFoodIds : basketData.healthyFoodIds])  { (error) in
        
                            if error != nil {
                                print("error updating the basket", error!.localizedDescription)
                            }
                            // call updateBasketPopularMenu() method because we deleted items and we need to get the latest items after deletion -> refresh items
                            self.getBasketHealthyFoodItems()
                           
                }
            }
        
      }
    func updateBasketTodayOffer(){
        if let basket = basketData{
            fireStoreService.updateBasketInFirestore(basket, withValues: [K.BasketFStore.TodayOffersIds : basketData.TodayOffersIds])  { (error) in
        
                            if error != nil {
                                print("error updating the basket", error!.localizedDescription)
                            }
                            // call updateBasketPopularMenu() method because we deleted items and we need to get the latest items after deletion -> refresh items
                            self.getBasketTodayOfferItems()
                           
                }
            }
        
      }
    func updateBasketFreeDelivery(){
        if let basket = basketData{
            fireStoreService.updateBasketInFirestore(basket, withValues: [K.BasketFStore.FreeDeliveryIds : basketData.FreeDeliveryIds])  { (error) in
        
                            if error != nil {
                                print("error updating the basket", error!.localizedDescription)
                            }
                            // call updateBasketPopularMenu() method because we deleted items and we need to get the latest items after deletion -> refresh items
                            self.getFreeDeliveryItems()
                           
                }
            }
        
      }
}
