//
//  AddItemViewModel.swift
//  Aklaty
//
//  Created by Macbook on 04/08/2021.
//

import Foundation
class AddItemViewModel: NSObject {
    //property from model
    var fireStoreService : FireStoreService!
    //property to get the data when success
    var showSuccess : String!{
        didSet{
            //we add listener her so when we set the showSuccess property we will call
            //bindAddNewCategoryViewModelToView() function type so this is a callback because I do not know when
            //the data come ->Asynchronous
            self.bindAddItemViewModelToView()
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
    var bindAddItemViewModelToView : (()->()) = {}
    var bindViewModelErrorToView : (()->()) = {}
    var shouldStartLoading: (() -> ()) = {}
    var shouldEndLoading: (() -> ()) = {}
    var shouldDismissView: (() -> ()) = {}
    //inilizer
    override init() {
        super.init()
        self.fireStoreService = FireStoreService()
    }
    func addItemToPopularMenuFirebase(item:Item){
        shouldStartLoading()
        fireStoreService.saveItemToPopularMenuFirestore(item) { (error) in
            
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
    
    func addItemToHealthyFoodFirebase(item:Item){
            shouldStartLoading()
            fireStoreService.saveItemToHealthyFoodFirestore(item) { (error) in
            
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
