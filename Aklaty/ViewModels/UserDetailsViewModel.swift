//
//  UserDetailsViewModel.swift
//  Aklaty
//
//  Created by Macbook on 02/09/2021.
//

import Foundation
import FirebaseAuth
class UserDetailsViewModel: NSObject {
    //property from model
    var fireStoreService : FireStoreService!
    var authenticationService : AuthenticationService!
    //property to get the data when success
    var userData : User!{
        didSet{
            //we add listener her so when we set the employeeData property we will call
            //bindEmplyeesViewModelToView() function type so this is a callback because I do not know when
            //the data come ->Asynchronous
            self.bindUserDetailsViewModelToView()
        }
    }
    //function type - property
    var bindUserDetailsViewModelToView : (()->()) = {}
    var shouldReturnToWelcomeView: (() -> ()) = {}
    //inilizer
    override init() {
        super.init()
        self.fireStoreService = FireStoreService()
        self.authenticationService = AuthenticationService()
        self.fetchUserDataFromApi()
    }
    
    func fetchUserDataFromApi(){
        
        if let userId = Auth.auth().currentUser?.uid {
            fireStoreService.retriveUserFromFirestore(userId: userId) { [weak self] (user) in
                if let  user = user{
                    self?.userData = user
                }
            }
        }else{
           print("error fetch User Data From Api")
        }
    }
    
     func logOutUser() {
        authenticationService.logOutCurrentUser { (error) in
            
            if error == nil {
                print("logged out")
               // self.navigationController?.popViewController(animated: true)
                self.shouldReturnToWelcomeView()
            }  else {
                print("error login out ", error!.localizedDescription)
            }
        }
        
    }
}
