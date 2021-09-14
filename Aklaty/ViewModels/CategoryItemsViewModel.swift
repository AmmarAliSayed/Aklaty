//
//  CategoryItemsViewModel.swift
//  Aklaty
//
//  Created by Macbook on 30/07/2021.
//

import Foundation
class CategoryItemsViewModel: NSObject {
    //property from model
    var fireStoreService :  FireStoreService!
    
    var selectedCateggory : Category!
    //property to get the data when success
    var categoryItemsData : [CategoryItem]!{
        didSet{
            self.bindCategoryItemsViewModelToView()
        }
    }
   
    var bindCategoryItemsViewModelToView : (()->()) = {}
    
    //inilizer
     init(category : Category) {
        super.init()
        self.fireStoreService = FireStoreService()
        self.selectedCateggory = category
        self.fetchCategoryItemsFromApi()
    }
    
    func fetchCategoryItemsFromApi(){
        if let  id = selectedCateggory.id {
            fireStoreService.retrieveCategoryItemsFromFirebase(id) { (categoryItems) in
                self.categoryItemsData = categoryItems
            }
        }else{
            
        }
       
    }
    
    func getAddItemToCategoryViewModel() -> AddItemToCategoryViewModel {
        return AddItemToCategoryViewModel(category: selectedCateggory)
    }
    func getCategoryItemDetailsViewModel(index : Int) -> CategoryItemDetailsViewModel {
        return CategoryItemDetailsViewModel(item: categoryItemsData[index])
    }
}
