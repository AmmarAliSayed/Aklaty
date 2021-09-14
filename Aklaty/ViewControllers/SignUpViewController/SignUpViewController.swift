//
//  SignUpViewController.swift
//  Aklaty
//
//  Created by Macbook on 15/07/2021.
//

import UIKit
import JGProgressHUD
import NVActivityIndicatorView

class SignUpViewController: UIViewController {
    //MARK: - Vars
    var passwordVisibility: (UIButton, String)?
    var signupViewModel = SignupViewModel()
    let hud = JGProgressHUD(style: .dark)
    var activityIdicator: NVActivityIndicatorView?
    //MARK: - IBOutlets
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        signupViewModel.bindSignUpViewModelToView = { [weak self] in
            self?.showSuccessAlert()
        }
        signupViewModel.bindViewModelErrorToView =  { [weak self] in
            self?.showErrorAlert()
        }
        signupViewModel.shouldStartLoading =  { [weak self] in
            self?.showLoadingIdicator()
        }
        
        signupViewModel.shouldEndLoading =  { [weak self] in
            self?.hideLoadingIdicator()
        }
        signupViewModel.shouldDismissView =  { [weak self] in
            self?.dismissView()
        }
        //make button rounded
        signUpButton.layer.cornerRadius = 10
        
        configureUI()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        activityIdicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60.0, height: 60.0), type: .ballPulse, color: #colorLiteral(red: 1, green: 0.8431372549, blue: 0, alpha: 1), padding: nil)
        
    }
    //MARK: - IBActions
    

    @IBAction func signUpButtonPressed(_ sender: Any) {
        let userName = nameTextField.text
        let email = emailTextField.text
        let phone = phoneTextField.text
        let password = passwordTextField.text
        if textFieldsHaveText() {
            signupViewModel.signupUserWith(email: email!, password: password!, userName: userName!, phone: phone!)
        } else {
           showRequiredFieldsAlert()
        }
       
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
    //MARK: - Helpers
    
    func configureUI(){
        passwordVisibility = PasswordVisibility.insertEyeIcon(textfield: passwordTextField, systemImage: "eye.slash")
        
        passwordVisibility?.0.addTarget(self, action: #selector(showPasswordTapped), for: .touchUpInside)
        
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
        self.hud.textLabel.text = signupViewModel.showSuccess
        self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        self.hud.show(in: self.view)
        self.hud.dismiss(afterDelay: 2.0)
    }
    private func showErrorAlert(){
      //  print("error registering", error!.localizedDescription)
        self.hud.textLabel.text = signupViewModel.showError
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
    private func dismissView() {
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    private func textFieldsHaveText() -> Bool {
        return (emailTextField.text != "" && passwordTextField.text != "" && nameTextField.text != "" && phoneTextField.text != "")
    }
}
