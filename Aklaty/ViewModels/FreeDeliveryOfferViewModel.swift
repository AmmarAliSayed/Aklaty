//
//  FreeDeliveryOfferViewModel.swift
//  Aklaty
//
//  Created by Macbook on 21/08/2021.
//

import Foundation
class FreeDeliveryOfferViewModel: NSObject {
    //property from model
    var fireStoreService :  FireStoreService!
    //property to get the data when success
    var offersData : [Offer]!{
        didSet{
            self.bindOfferViewModelToView()
        }
    }
   
    var bindOfferViewModelToView : (()->()) = {}
    
    //inilizer
    override init() {
        super.init()
        self.fireStoreService = FireStoreService()
        self.fetchOffersDataFromApi()
    }
    
    func fetchOffersDataFromApi(){
        fireStoreService.retrieveFreeDeliveryOffersFromFirebase { (offers) in
            self.offersData = offers
        }
    }
    func getOfferDetailsViewModel(index : Int) -> FreeDeliveryOfferDetailsViewModel {
        return FreeDeliveryOfferDetailsViewModel(item: offersData[index])
    }
}
