//
//  OccasionOfferViewModel.swift
//  Aklaty
//
//  Created by Macbook on 19/08/2021.
//

import Foundation
class OccasionOfferViewModel: NSObject {
    //property from model
    var fireStoreService :  FireStoreService!
    //property to get the data when success
    var occasionOffersData : [OccasionOffer]!{
        didSet{
            self.bindOccasionOfferViewModelToView()
        }
    }
   
    var bindOccasionOfferViewModelToView : (()->()) = {}
    
    //inilizer
    override init() {
        super.init()
        self.fireStoreService = FireStoreService()
        self.fetchOccasionOffersDataFromApi()
    }
    
    func fetchOccasionOffersDataFromApi(){
        fireStoreService.retrieveOccasionOffersFromFirebase { (offers) in
            self.occasionOffersData = offers
        }
    }
    
}
