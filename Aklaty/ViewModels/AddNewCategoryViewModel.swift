//
//  AddNewCategoryViewModel.swift
//  Aklaty
//
//  Created by Macbook on 29/07/2021.
//

import Foundation
class AddNewCategoryViewModel: NSObject {
    //property from model
    var fireStoreService : FireStoreService!
    var algoliaService : AlgoliaService!
    //property to get the data when success
    var showSuccess : String!{
        didSet{
            //we add listener her so when we set the showSuccess property we will call
            //bindAddNewCategoryViewModelToView() function type so this is a callback because I do not know when
            //the data come ->Asynchronous
            self.bindAddNewCategoryViewModelToView()
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
    var bindAddNewCategoryViewModelToView : (()->()) = {}
    var bindViewModelErrorToView : (()->()) = {}
    var shouldStartLoading: (() -> ()) = {}
    var shouldEndLoading: (() -> ()) = {}
    var shouldDismissView: (() -> ()) = {}
    //inilizer
    override init() {
        super.init()
        self.fireStoreService = FireStoreService()
        self.algoliaService = AlgoliaService()
    }
    func addNewCategoryToFirebase(category : Category){
        shouldStartLoading()
        fireStoreService.saveCategoryToFirebase(category) { (error) in
            if let error :Error = error{
                         let message = error.localizedDescription
                         self.showError = message
                     }else{
                         self.showSuccess = "Registration operation done!"
                         self.shouldDismissView()
                     }
            //after save item in firestore we save it in Algolia too
                self.addNewCategoryToAlgolia(category)
                 self.shouldEndLoading()
        }
    }
    func addNewCategoryToAlgolia(_ category : Category){
        algoliaService.saveCategoryToAlgolia(category: category)
    }
}
