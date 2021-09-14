//
//  AddItemToCategoryViewModel.swift
//  Aklaty
//
//  Created by Macbook on 30/07/2021.
//

import Foundation
class AddItemToCategoryViewModel: NSObject {
    //property from model
    var fireStoreService : FireStoreService!
    var selectedCateggory : Category!
    //property to get the data when success
    var showSuccess : String!{
        didSet{
            //we add listener her so when we set the showSuccess property we will call
            //bindAddNewCategoryViewModelToView() function type so this is a callback because I do not know when
            //the data come ->Asynchronous
            self.bindAddItemToCategoryViewModelToView()
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
    var bindAddItemToCategoryViewModelToView : (()->()) = {}
    var bindViewModelErrorToView : (()->()) = {}
    var shouldStartLoading: (() -> ()) = {}
    var shouldEndLoading: (() -> ()) = {}
    var shouldDismissView: (() -> ()) = {}
    //inilizer
    init(category : Category) {
        super.init()
        self.fireStoreService = FireStoreService()
        self.selectedCateggory = category
    }
    func addCategoryItemToFirebase(categoryItem : CategoryItem){
        shouldStartLoading()
        fireStoreService.saveCategoryItemToFirestore(categoryItem) { (error) in
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
