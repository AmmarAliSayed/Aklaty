//
//  EditUserViewController.swift
//  Aklaty
//
//  Created by Macbook on 04/09/2021.
//

import UIKit
import Gallery
import JGProgressHUD
import NVActivityIndicatorView
import FirebaseAuth
class EditUserViewController: UIViewController {
    //MARK: - IBOutlets
   
    @IBOutlet weak var saveButtonOutlet: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var userImageView: UIImageView!
    //MARK: - Vars
    var userDetailsViewModel : UserDetailsViewModel!
    var editUserViewModel : EditUserViewModel!
    var userImages: [UIImage?] = []
    var userImagesLinks: [String?] = []
    var gallery: GalleryController!
    let hud = JGProgressHUD(style: .dark)
    var activityIndicator: NVActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //hide tab bar
        self.tabBarController?.tabBar.isHidden = true
        userImageView.layer.cornerRadius = userImageView.frame.size.width/2
        userImageView.layer.masksToBounds = true
        //make button rounded
        saveButtonOutlet.layer.cornerRadius = 10
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //put the activityIndicator in center of the screen
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60, height: 60), type: .ballPulse, color: #colorLiteral(red: 1, green: 0.8431372549, blue: 0, alpha: 1), padding: nil)
        
        userDetailsViewModel = UserDetailsViewModel()
        editUserViewModel = EditUserViewModel()
        
       userDetailsViewModel.bindUserDetailsViewModelToView = {
           self.getUserDetails()
           }
        editUserViewModel.bindEditViewModelToView = { [weak self] in
            self?.showSuccessAlert()
        }
        editUserViewModel.bindViewModelErrorToView =  { [weak self] in
            self?.showErrorAlert()
        }
        editUserViewModel.shouldStartLoading =  { [weak self] in
            self?.showLoadingIndicator()
        }
        
        editUserViewModel.shouldEndLoading =  { [weak self] in
            self?.hideLoadingIndicator()
        }
        editUserViewModel.shouldDismissView =  { [weak self] in
            self?.dismissView()
        }
    }
    //MARK: - IBActions
        @IBAction func choosePhotoButtonPressed(_ sender: Any) {
            //reset itemImages array before add new images for new item
            userImages = []
            showImageGallery()
           // getUserDetails()
        }
        
        @IBAction func saveButtonPressed(_ sender: Any) {
            saveNewData()
        }
        
        
    //MARK: - helper functions
    func getUserDetails(){
        nameTextField.text = userDetailsViewModel.userData.name
        phoneTextField.text = userDetailsViewModel.userData.phone
        emailTextField.text = userDetailsViewModel.userData.email
        
        if (userDetailsViewModel.userData.imageLinks.count) > 0 {
            downloadImagesFromFirebase(imageUrls:[(userDetailsViewModel.userData.imageLinks.first!)]) { (images) in
                DispatchQueue.main.async { [self] in
                    userImageView.image = images.first as? UIImage
                }
            }
        }
       
    }
    
    private func saveNewData(){
       // showLoadingIndicator()
        if userImages.count > 0 {//then user add images
            uploadImages(images: userImages, itemId:Auth.auth().currentUser!.uid) { (imageLinkArray) in
                
                self.userImagesLinks = imageLinkArray
                self.updateCurrentUser()
                //go back
             //   self.hideLoadingIndicator()
               // self.popTheView()
            }
          
    }else{
        self.updateCurrentUser()
        //go back
      //  self.hideLoadingIndicator()
        //self.popTheView()
    }
}
    private func updateCurrentUser(){
            dismissKeyboard()
        
        if textFieldsHaveText() {
            let withValues = [K.UsersFStore.userNameField : nameTextField.text!, K.UsersFStore.emailField : emailTextField.text!, K.UsersFStore.phoneField : phoneTextField.text! ,K.UsersFStore.imageLinksField :userImagesLinks ] as [String : Any]
            editUserViewModel.updateCurrentUser(Values: withValues)
        }else{
            showRequiredFieldsAlert()
        }
        }
        private func dismissKeyboard() {
            self.view.endEditing(false)
        }
        //check that all textFields Have Text or not empty
        private func textFieldsHaveText() -> Bool {
            return (emailTextField.text != "" && nameTextField.text != "" && phoneTextField.text != "")
        }
        private func popTheView() {
            self.navigationController?.popViewController(animated: true)
        }
        //MARK: Show Gallery
        private func showImageGallery() {
            
            self.gallery = GalleryController()
            self.gallery.delegate = self
            
            Config.tabsToShow = [.imageTab, .cameraTab]
            Config.Camera.imageLimit = 6
            
            self.present(self.gallery, animated: true, completion: nil)
        }
        //MARK: Activity Indicator
        
        private func showLoadingIndicator() {
            
            if activityIndicator != nil {
                self.view.addSubview(activityIndicator!)
                activityIndicator!.startAnimating()
            }
        }

        private func hideLoadingIndicator() {
            
            if activityIndicator != nil {
                activityIndicator!.removeFromSuperview()
                activityIndicator!.stopAnimating()
            }
        }

    //MARK: - Alert
    private func showSuccessAlert(){
        self.hud.textLabel.text = editUserViewModel.showSuccess
        self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        self.hud.show(in: self.view)
        self.hud.dismiss(afterDelay: 2.0)
    }
    private func showErrorAlert(){
      //  print("error registering", error!.localizedDescription)
        self.hud.textLabel.text = editUserViewModel.showError
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


}
//MARK: - GalleryControllerDelegate

extension EditUserViewController: GalleryControllerDelegate {
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        if images.count > 0 {
            //convert the user selected images [resolvedImages] to uiImage type and then stored in itemImages array
            Image.resolve(images: images) { (resolvedImages) in
                
                self.userImages = resolvedImages
            }
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }

    
}

