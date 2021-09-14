//
//  CategoryViewModel.swift
//  Aklaty
//
//  Created by Macbook on 29/07/2021.
//

import Foundation
class CategoryViewModel: NSObject {
    //property from model
    var fireStoreService :  FireStoreService!
    var algoliaService : AlgoliaService!
    //property to get the data when success
    //
    var categoriesData : [Category]!{
        didSet{
            self.bindCategoriesViewModelToView()
        }
    }
    var filteredItemsData : [Category]!{
        didSet{
            self.bindfilteredCategoriesToView()
        }
    }
    var bindCategoriesViewModelToView : (()->()) = {}
    var bindfilteredCategoriesToView : (()->()) = {}
    var shouldStartLoading: (() -> ()) = {}
    var shouldEndLoading: (() -> ()) = {}
    //inilizer
    override init() {
        super.init()
        self.fireStoreService = FireStoreService()
        self.algoliaService = AlgoliaService()
        self.fetchCategoriesFromApi()
    }
    
    func fetchCategoriesFromApi(){
        fireStoreService.retrieveCategoriesFromFirebase { (categories) in
            self.categoriesData = categories
        }
    }
    
     func searchInFirebase(forName: String) {

        shouldStartLoading()

        algoliaService.searchCategoryInAlgolia(searchString: forName) { [ self] (itemIds) in
            fireStoreService.downloadCategoriesForSearch(itemIds) { (items) in
                self.filteredItemsData = items
              //  self.myCollectionView.reloadData()
                self.shouldEndLoading()
            }
        }
    }
    func getCategoryItemsViewModel(for index: Int) -> CategoryItemsViewModel {
        return CategoryItemsViewModel(category: categoriesData[index])
    }
}
