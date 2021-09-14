//
//  AddTodayOfferViewModel.swift
//  Aklaty
//
//  Created by Macbook on 21/08/2021.
//

import Foundation
class AddTodayOfferViewModel: NSObject {
    //property from model
    var fireStoreService : FireStoreService!
    //property to get the data when success
    var showSuccess : String!{
        didSet{
            //we add listener her so when we set the showSuccess property we will call
            //bindAddNewCategoryViewModelToView() function type so this is a callback because I do not know when
            //the data come ->Asynchronous
            self.bindOfferViewModelToView()
        }
    }
    //property when the error happened
    var showError : String!{
        didSet{
            //we add listener her so when we set the showError property we will call
            //bindViewModelErrorToView() function type
            self.bindViewModelErrorToView()
        }
    }
    //five functions type - five properties
    var bindOfferViewModelToView : (()->()) = {}
    var bindViewModelErrorToView : (()->()) = {}
    var shouldStartLoading: (() -> ()) = {}
    var shouldEndLoading: (() -> ()) = {}
    var shouldDismissView: (() -> ()) = {}
    //inilizer
    override init() {
        super.init()
        self.fireStoreService = FireStoreService()
    }
    func addOfferToFirebase(offer:Offer){
        shouldStartLoading()
        fireStoreService.saveTodayOffersFirestore(offer) { (error) in
            
            if let error :Error = error{
                let message = error.localizedDescription
                self.showError = message
            }else{
                self.showSuccess = "Registration operation done!"
                self.shouldDismissView()
            }
            self.shouldEndLoading()
        }
        
    }
    
   
}
