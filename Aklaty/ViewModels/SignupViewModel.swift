//
//  SignupViewModel.swift
//  Aklaty
//
//  Created by Macbook on 23/07/2021.
//

import Foundation
class SignupViewModel: NSObject {
    //property from model
    var authenticationService : AuthenticationService!
    //property to get the data when success
    var showSuccess : String!{
        didSet{
            //we add listener her so when we set the showSuccess property we will call
            //bindSignUpViewModelToView() function type so this is a callback because I do not know when
            //the data come ->Asynchronous
            self.bindSignUpViewModelToView()
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
    var bindSignUpViewModelToView : (()->()) = {}
    var bindViewModelErrorToView : (()->()) = {}
    var shouldStartLoading: (() -> ()) = {}
    var shouldEndLoading: (() -> ()) = {}
    var shouldDismissView: (() -> ()) = {}
    //inilizer
    override init() {
        super.init()
        self.authenticationService = AuthenticationService()
      //  self.emailPasswordSignup(email: <#T##String#>, password: <#T##String#>, userName: <#T##String#>, phone: <#T##String#>)
    }
    
    func signupUserWith(email: String, password: String,userName :String,phone :String){
        shouldStartLoading()
        authenticationService.registerUserWith(email: email, password: password, userName: userName, phone: phone) { (error) in
            
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

