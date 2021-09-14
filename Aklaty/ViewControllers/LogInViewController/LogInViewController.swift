//
//  LogInViewController.swift
//  Aklaty
//
//  Created by Macbook on 14/07/2021.
//

import UIKit
import JGProgressHUD
import NVActivityIndicatorView
import GoogleSignIn
//import FBSDKLoginKit
//import FBSDKCoreKit
//import FirebaseAuth

class LogInViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var loginButton: UIButton!
  //  @IBOutlet weak var loginWithFacebookButton: FBLoginButton!
    @IBOutlet weak var loginWithGoogleButton: GIDSignInButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    //MARK: - Vars
    var passwordVisibility: (UIButton, String)?
    let hud = JGProgressHUD(style: .dark)
    var activityIdicator: NVActivityIndicatorView?
    
    var loginViewModel = LogInViewModel()
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loginViewModel.bindLogInViewModelToView = { [weak self] in
            self?.showSuccessAlert()
        }
        loginViewModel.bindViewModelErrorToView =  { [weak self] in
            self?.showErrorAlert()
        }
        loginViewModel.shouldStartLoading =  { [weak self] in
            self?.showLoadingIdicator()
        }
        
        loginViewModel.shouldEndLoading =  { [weak self] in
            self?.hideLoadingIdicator()
        }
        loginViewModel.shouldGoToAnotherView =  { [weak self] in
            self?.goToAnotherView()
        }
        //make button rounded
        loginButton.layer.cornerRadius = 10
       // loginWithFacebookButton.layer.cornerRadius = 10
       loginWithGoogleButton.layer.cornerRadius = 20
        //google signIn
        GIDSignIn.sharedInstance()?.presentingViewController = self
        //facebook login
//        let loginWithFacebookButton = FBLoginButton()
//        loginWithFacebookButton.delegate = self
//        loginWithFacebookButton.center = view.center
//              view.addSubview(loginWithFacebookButton)
//        loginWithFacebookButton.permissions = ["public_profile","email"]
        configureUI()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        activityIdicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60.0, height: 60.0), type: .ballPulse, color: #colorLiteral(red: 1, green: 0.8431372549, blue: 0, alpha: 1), padding: nil)
        
    }
    //MARK: - IBActions
    @IBAction func loginButtonPressed(_ sender: Any) {
        let password = passwordTextField.text
        let email = emailTextField.text
        if textFieldsHaveText() {
            loginViewModel.logInUserWith(email: email!, password: password!)
        } else {
            showRequiredFieldsAlert()
        }
    }
    
//    @IBAction func loginWithFacebookButtonPressed(_ sender: Any) {
//        GIDSignIn.sharedInstance().signIn()
//    }
//
    @IBAction func loginWithGoogleButtonPressed(_ sender: Any) {
    }
    
     @IBAction func backButtonPressed(_ sender: Any) {
         self.navigationController?.popViewController(animated: true)
     }
    
    @objc func showPasswordTapped(){
        
        if passwordVisibility?.1 == "eye.slash"{
            
            passwordVisibility = PasswordVisibility.insertEyeIcon(textfield: passwordTextField, systemImage: "eye")
            passwordVisibility?.0.addTarget(self, action: #selector(showPasswordTapped), for: .touchUpInside)
            
        }else{
            
            passwordVisibility = PasswordVisibility.insertEyeIcon(textfield: passwordTextField, systemImage: "eye.slash")
            passwordVisibility?.0.addTarget(self, action: #selector(showPasswordTapped), for: .touchUpInside)
            
        }
        
    }
    //MARK: - Helper Functions
    func configureUI(){
        passwordVisibility = PasswordVisibility.insertEyeIcon(textfield: passwordTextField, systemImage: "eye.slash")
        
        passwordVisibility?.0.addTarget(self, action: #selector(showPasswordTapped), for: .touchUpInside)
        
    }
    
    private func goToAnotherView() {
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let homeViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//        self.navigationController?.pushViewController(homeViewController, animated: true)
        self.performSegue(withIdentifier: "fromSignInToTaBar", sender: nil)
    }
    private func textFieldsHaveText() -> Bool {
        return (emailTextField.text != "" && passwordTextField.text != "")
    }
    //MARK: - Activity Indicator
    
    private func showLoadingIdicator() {
        
        if activityIdicator != nil {
            self.view.addSubview(activityIdicator!)
            activityIdicator!.startAnimating()
        }
        
    }

    private func hideLoadingIdicator() {
        
        if activityIdicator != nil {
            activityIdicator!.removeFromSuperview()
            activityIdicator!.stopAnimating()
        }
    }
    
    //MARK: - Alert
    private func showSuccessAlert(){
        self.hud.textLabel.text = loginViewModel.showSuccess
        self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        self.hud.show(in: self.view)
        self.hud.dismiss(afterDelay: 2.0)
    }
    private func showErrorAlert(){
      //  print("error registering", error!.localizedDescription)
        self.hud.textLabel.text = loginViewModel.showError
        self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
        self.hud.show(in: self.view)
        self.hud.dismiss(afterDelay: 2.0)
    }
    
    private func showRequiredFieldsAlert(){
        hud.textLabel.text = "All fields are required"
        hud.indicatorView = JGProgressHUDErrorIndicatorView()
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 2.0)
    }
    
}
//extension  LogInViewController :  LoginButtonDelegate{
//    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
////        let token = result?.token?.tokenString
////        let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields":"email,  name"], tokenString: token, version: nil, httpMethod: .get)
////        request.start { (connection, result, error) in
////            print("\(result ?? "no result")")
////        }
//        // `AccessToken` is generated after user logs in through Facebook SDK successfully
//        guard let facebookToken = result?.token?.tokenString else{
//            print("user failed to login with facebook")
//            return
//        }
//
//                let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields":"email,  name"], tokenString: facebookToken, version: nil, httpMethod: .get)
//                request.start { (connection, result, error) in
//                    guard let result = result as? [String : Any], error == nil else{
//                        print("failed to request")
//                        return
//                    }
//                    print("\(result)")
//                    let credential = FacebookAuthProvider.credential(withAccessToken: facebookToken)
//                    FirebaseAuth.Auth.auth().signIn(with: credential) { (authResult, error) in
////                      if let error = error {
////                        print("Firebase auth fails with error: \(error.localizedDescription)")
////                      } else if let result = result {
////                        print("\(result.user.displayName )")
////                      }
//
//                        guard authResult != nil ,error==nil  else{
//                            if let error = error {
//                                print("Firebase auth fails with error")
//                             }
//                            return
//                        }
//                        print("Firebase auth success")
//
//                }
//                }
//
//    }
//    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
//
//    }
//
//
//
//
//}
