//
//  EditUserViewModel.swift
//  Aklaty
//
//  Created by Macbook on 05/09/2021.
//

import Foundation
class EditUserViewModel: NSObject {
    //property from model
    var fireStoreService : FireStoreService!
    //property to get the data when success
    var showSuccess : String!{
        didSet{
            //we add listener her so when we set the showSuccess property we will call
            //bindSignUpViewModelToView() function type so this is a callback because I do not know when
            //the data come ->Asynchronous
            self.bindEditViewModelToView()
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
    var bindEditViewModelToView : (()->()) = {}
    var bindViewModelErrorToView : (()->()) = {}
    var shouldStartLoading: (() -> ()) = {}
    var shouldEndLoading: (() -> ()) = {}
    var shouldDismissView: (() -> ()) = {}
    //inilizer
    override init() {
        super.init()
        self.fireStoreService = FireStoreService()
    }
    
     func updateCurrentUser(Values: [String : Any]){
        shouldStartLoading()
        fireStoreService.updateCurrentUserInFirestore(withValues: Values) { (error) in
            
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

