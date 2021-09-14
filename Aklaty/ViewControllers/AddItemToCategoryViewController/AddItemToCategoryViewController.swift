//
//  AddFoodViewController.swift
//  Aklaty
//
//  Created by Macbook on 28/07/2021.
//

import UIKit
import JGProgressHUD
import NVActivityIndicatorView
import Gallery
class AddItemToCategoryViewController: UIViewController {
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var noOfCaloriesTextField: UITextField!
    @IBOutlet weak var foodNameTextField: UITextField!
    @IBOutlet weak var foodDescriptionTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var doneButton: UIButton!
    //MARK: - Vars
    var addItemCategoryViewModel : AddItemToCategoryViewModel!
    let hud = JGProgressHUD(style: .dark)
    var activityIdicator: NVActivityIndicatorView?
    var categoryItemImages: [UIImage?] = []
    var gallery: GalleryController!
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //hide tab bar
        self.tabBarController?.tabBar.isHidden = true
     //   print(addItemCategoryViewModel.selectedCateggory.name ?? "no value")
        
        addItemCategoryViewModel.bindAddItemToCategoryViewModelToView = { [weak self] in
            self?.showSuccessAlert()
        }
        addItemCategoryViewModel.bindViewModelErrorToView =  { [weak self] in
            self?.showErrorAlert()
        }
        addItemCategoryViewModel.shouldStartLoading =  { [weak self] in
            self?.showLoadingIdicator()
        }
        
        addItemCategoryViewModel.shouldEndLoading =  { [weak self] in
            self?.hideLoadingIdicator()
        }
        addItemCategoryViewModel.shouldDismissView =  { [weak self] in
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
        categoryItemImages = []
        showImageGallery()
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        if textFieldsHaveText() {
            addNewCategoryItem()
        } else {
           showRequiredFieldsAlert()
        }
    }
    //MARK: - Helpers
    func addNewCategoryItem(){
        let categoryItem = CategoryItem()
        let id = UUID().uuidString
        categoryItem.id = id
        categoryItem.categoryId = addItemCategoryViewModel.selectedCateggory.id
        categoryItem.name = foodNameTextField.text
        categoryItem.description = foodDescriptionTextField.text
        categoryItem.calories = Int(noOfCaloriesTextField.text ?? "")
        categoryItem.price = Double(priceTextField.text ?? "")
        categoryItem.time = timeTextField.text
        categoryItem.imageLinks = []
       // categoryItem.updatedPrice = 0.0
        
        if categoryItemImages.count > 0 {//then user add images
            uploadImages(images: categoryItemImages, itemId: id) { [ weak self] (imageLinkArray) in
                
                categoryItem.imageLinks = imageLinkArray
                self?.addItemCategoryViewModel.addCategoryItemToFirebase(categoryItem: categoryItem)
                //after save item in firestore we save it in Algolia too
               // saveBookToAlgolia(book: book)
               // self.hideLoadingIndicator()
                //go back after add the item
               // self.popTheView()
            }
          
            
        } else {
         //then user don't add images so save item without images
            self.addItemCategoryViewModel.addCategoryItemToFirebase(categoryItem: categoryItem)
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
        self.hud.textLabel.text = addItemCategoryViewModel.showSuccess
        self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        self.hud.show(in: self.view)
        self.hud.dismiss(afterDelay: 2.0)
    }
    private func showErrorAlert(){
      //  print("error registering", error!.localizedDescription)
        self.hud.textLabel.text = addItemCategoryViewModel.showError
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
       return (priceTextField.text != "" && noOfCaloriesTextField.text != "" && foodNameTextField.text != "" && foodDescriptionTextField.text != "" && timeTextField.text != "")
        
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

extension AddItemToCategoryViewController: GalleryControllerDelegate {
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        if images.count > 0 {
            //convert the user selected images [resolvedImages] to uiImage type and then stored in categoryImages array
            Image.resolve(images: images) { (resolvedImages) in
                
                self.categoryItemImages = resolvedImages
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
