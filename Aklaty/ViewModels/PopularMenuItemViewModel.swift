//
//  ItemViewModel.swift
//  Aklaty
//
//  Created by Macbook on 04/08/2021.
//

import Foundation
class PopularMenuItemViewModel: NSObject {
    //property from model
    var fireStoreService :  FireStoreService!
    //property to get the data when success
    var popularMenuItemsData : [Item]!{
        didSet{
            self.bindItemsViewModelToView()
        }
    }
    var bindItemsViewModelToView : (()->()) = {}
    
    //inilizer
    override init() {
        super.init()
        self.fireStoreService = FireStoreService()
        self.fetchPopularMenuItemsFromApi()
    }
    
    func fetchPopularMenuItemsFromApi(){
        fireStoreService.retrieveItemsFromPopularMenuFirestore { (items) in
            self.popularMenuItemsData = items
        }
    }

    func getItemDetailsViewModel(index : Int) -> PopularMenuItemDetailsViewModel {
        return PopularMenuItemDetailsViewModel(item: popularMenuItemsData[index])
    }
}
