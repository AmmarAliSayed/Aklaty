//
//  Food.swift
//  Aklaty
//
//  Created by Macbook on 28/07/2021.
//

import Foundation
class CategoryItem {
    var id: String!
    var categoryId: String!
    var name: String!
    var time: String!
    var description: String!
    var price: Double!
   // var updatedPrice: Double!
    var calories: Int!
    //var reviews: [Review]!
    var imageLinks: [String]!
    init() {
        
    }
    init(_dictionary: NSDictionary) {
        id = _dictionary[K.CategoryItemFStore.categoryItemIdField] as? String
        categoryId = _dictionary[K.CategoryItemFStore.categoryIdField] as? String
        name = _dictionary[K.CategoryItemFStore.categoryItemNameField] as? String
        imageLinks = _dictionary[K.CategoryItemFStore.imageLinksField] as? [String]
        description = _dictionary[K.CategoryItemFStore.description] as? String
        calories = _dictionary[K.CategoryItemFStore.caloriesField] as? Int
        price = _dictionary[K.CategoryItemFStore.priceField] as? Double
       // updatedPrice = _dictionary[K.CategoryItemFStore.updatedPriceField] as? Double
        time = _dictionary[K.CategoryItemFStore.timeField] as? String
    }
}
