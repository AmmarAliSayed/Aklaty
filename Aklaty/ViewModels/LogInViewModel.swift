//
//  LogInViewModel.swift
//  Aklaty
//
//  Created by Macbook on 23/07/2021.
//

import Foundation
import GoogleSignIn
import Firebase
import UIKit
class LogInViewModel: NSObject {
    //property from model
    var authenticationService : AuthenticationService!
    //property to get the data when success
    var showSuccess : String!{
        didSet{
            //we add listener her so when we set the showSuccess property we will call
            //bindSignUpViewModelToView() function type so this is a callback because I do not know when
            //the data come ->Asynchronous
            self.bindLogInViewModelToView()
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
    var bindLogInViewModelToView : (()->()) = {}
    var bindViewModelErrorToView : (()->()) = {}
    var shouldStartLoading: (() -> ()) = {}
    var shouldEndLoading: (() -> ()) = {}
    var shouldGoToAnotherView: (() -> ()) = {}
    //inilizer
    override init() {
        super.init()
        self.authenticationService = AuthenticationService()
        GIDSignIn.sharedInstance().delegate = self
    }
    
    func logInUserWith(email: String, password: String){
        shouldStartLoading()
        authenticationService.loginUserWith(email: email, password: password) { (error) in
            
                if let error :Error = error{
                    let message = error.localizedDescription
                    self.showError = message
                    
                }else{
                    self.showSuccess = "Registration operation done!"
                    self.shouldGoToAnotherView()
                }
            self.shouldEndLoading()
        }
    }
    func fetchGoogleUserDataAndSaveItToFireStore(){
        //Fetching User Profile Image, Name & Email
        let currentUser = Auth.auth().currentUser
        //print(currentUser?.uid ?? "no id")
       // print(currentUser?.displayName ?? "no id")
       // print(currentUser?.email ?? "no id")
        let user  = User()
        let googleUser: GIDGoogleUser = GIDSignIn.sharedInstance()!.currentUser
        if let id = currentUser?.uid {
            user.userId = id
         //   user.phone = phone
        }
//        if let phone = currentUser?.phoneNumber {
//          user.phone = phone
//        }
        let fullName = googleUser.profile.name
        let email = googleUser.profile.email
       
       // let imageUrl = GIDSignIn.sharedInstance().currentUser.profile.imageURL(withDimension: 400).absoluteString
        if googleUser.profile.hasImage {
            let imageUrl = googleUser.profile.imageURL(withDimension: 200) .absoluteString
           // let url  = NSURL(string: imageUrl)! as URL
           // let data = NSData(contentsOf: url)
            user.imageLinks = [imageUrl]
        }else{
           // user.imageLinks = [UIImage(named: "")]
        }
        user.name = fullName
        user.email = email
        
        //user.phone = googleUser
        FireStoreService.saveUserToFirestore(user: user)
    }
    
    }

extension LogInViewModel : GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
       
        if let error = error {
        print(error.localizedDescription)
        return
        }
        guard let auth = user.authentication else { return }
        let credentials = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
        Auth.auth().signIn(with: credentials) { (authResult, error) in
        if let error = error {
        print(error.localizedDescription)
        } else {
        //print(“Login Successful.”)
        print("user email:\(user.profile.email ?? "no email")")
        //This is where you should add the functionality of successful login
        //i.e. dismissing this view or push the home view controller etc
            self.shouldGoToAnotherView()
            self.fetchGoogleUserDataAndSaveItToFireStore()
        }
    }
        
        

   
}
}
