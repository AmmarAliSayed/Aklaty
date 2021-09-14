//
//  HomeUserNameViewModel.swift
//  Aklaty
//
//  Created by Macbook on 27/07/2021.
//

import Foundation
import FirebaseAuth

class HomeUserNameViewModel: NSObject {
    //property from model
    var fireStoreService : FireStoreService!
    //property to get the data when success
    var userData : User!{
        didSet{
            //we add listener her so when we set the employeeData property we will call
            //bindEmplyeesViewModelToView() function type so this is a callback because I do not know when
            //the data come ->Asynchronous
            self.bindUserNameViewModelToView()
        }
    }
    //function type - property
    var bindUserNameViewModelToView : (()->()) = {}
   
    //inilizer
    override init() {
        super.init()
        self.fireStoreService = FireStoreService()
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
}
