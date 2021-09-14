//
//  HealthyFoodItemViewModel.swift
//  Aklaty
//
//  Created by Macbook on 11/08/2021.
//

import Foundation
class HealthyFoodItemViewModel: NSObject {
    //property from model
    var fireStoreService :  FireStoreService!
    //property to get the data when success
    var healthyFoodItemsData : [Item]!{
        didSet{
            self.bindItemsViewModelToView()
        }
    }
    var bindItemsViewModelToView : (()->()) = {}
    
    //inilizer
    override init() {
        super.init()
        self.fireStoreService = FireStoreService()
        self.fetchHealthyItemsFromApi()
    }
    
    func fetchHealthyItemsFromApi(){
        fireStoreService.retrieveItemsFromHealthyFoodFirestore { (items) in
            self.healthyFoodItemsData = items
        }
    }
    func getItemDetailsViewModel(index : Int) -> HealthyFoodItemDetailsViewModel {
        return HealthyFoodItemDetailsViewModel(item: healthyFoodItemsData[index])
    }
}
