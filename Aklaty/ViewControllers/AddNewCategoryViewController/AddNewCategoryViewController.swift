//
//  AddNewCategoryViewController.swift
//  Aklaty
//
//  Created by Macbook on 28/07/2021.
//

import UIKit
import JGProgressHUD
import NVActivityIndicatorView
import Gallery
class AddNewCategoryViewController: UIViewController {
    //MARK: - Vars
    var addNewCategoryViewModel = AddNewCategoryViewModel()
    let hud = JGProgressHUD(style: .dark)
    var activityIdicator: NVActivityIndicatorView?
    var categoryImages: [UIImage?] = []
    var gallery: GalleryController!
    //MARK: - IBOutlets
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var categoryNameTextField: UITextField!
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //hide tab bar
        self.tabBarController?.tabBar.isHidden = true
        addNewCategoryViewModel.bindAddNewCategoryViewModelToView = { [weak self] in
            self?.showSuccessAlert()
        }
        addNewCategoryViewModel.bindViewModelErrorToView =  { [weak self] in
            self?.showErrorAlert()
        }
        addNewCategoryViewModel.shouldStartLoading =  { [weak self] in
            self?.showLoadingIdicator()
        }
        
        addNewCategoryViewModel.shouldEndLoading =  { [weak self] in
            self?.hideLoadingIdicator()
        }
        addNewCategoryViewModel.shouldDismissView =  { [weak self] in
            self?.dismissView()
        }
        //make button rounded
        doneButton.layer.cornerRadius = 10
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        activityIdicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60.0, height: 60.0), type: .ballPulse, color: #colorLiteral(red: 1, green: 0.8431372549, blue: 0, alpha: 1), padding: nil)
        
    }
    //MARK: - IBActions
    
    @IBAction func chooseImageButtonPressed(_ sender: Any) {
        //reset itemImages array before add new images for new item
        categoryImages = []
        showImageGallery()
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
      
        if textFieldsHaveText() {
            addNewCategory()
        } else {
           showRequiredFieldsAlert()
        }
       
    }
    //MARK: - Helpers
    
    
    
    func addNewCategory(){
        let category = Category()
        let categoryName = categoryNameTextField.text
        category.name = categoryName
        let id = UUID().uuidString
        category.id = id
        category.imageLinks = []
        if categoryImages.count > 0 {//then user add images
            uploadImages(images: categoryImages, itemId: id) { [ weak self] (imageLinkArray) in
                
                category.imageLinks = imageLinkArray
                self!.addNewCategoryViewModel.addNewCategoryToFirebase(category: category)
              //  saveBookToFirestore(book)
                //after save item in firestore we save it in Algolia too
               // saveBookToAlgolia(book: book)
               // self.hideLoadingIndicator()
                //go back after add the item
               // self.popTheView()
            }
          
            
        } else {
         //then user don't add images so save item without images
            self.addNewCategoryViewModel.addNewCategoryToFirebase(category: category)
          //  saveBookToAlgolia(book: book)
            //go back after add the item
          //  popTheView()
        }
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
        self.hud.textLabel.text = addNewCategoryViewModel.showSuccess
        self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        self.hud.show(in: self.view)
        self.hud.dismiss(afterDelay: 2.0)
    }
    private func showErrorAlert(){
      //  print("error registering", error!.localizedDescription)
        self.hud.textLabel.text = addNewCategoryViewModel.showError
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
        return (categoryNameTextField.text != "")
    }
    //MARK: Show Gallery
    private func showImageGallery() {
        
        self.gallery = GalleryController()
        self.gallery.delegate = self
        
        Config.tabsToShow = [.imageTab, .cameraTab]
        Config.Camera.imageLimit = 1
        
        self.present(self.gallery, animated: true, completion: nil)
    }
}
//MARK: - GalleryControllerDelegate

extension AddNewCategoryViewController: GalleryControllerDelegate {
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        if images.count > 0 {
            //convert the user selected images [resolvedImages] to uiImage type and then stored in categoryImages array
            Image.resolve(images: images) { (resolvedImages) in
                
                self.categoryImages = resolvedImages
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
