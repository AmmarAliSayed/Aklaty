//
//  OrderedCategoryItem.swift
//  Aklaty
//
//  Created by Macbook on 29/08/2021.
//

import Foundation
class OrderedCategoryItem {
    var id: String!
    var categoryId: String!
    var name: String!
    var time: String!
    var numOfOrders: Int!
    var description: String!
    var price: Double!
   // var updatedPrice: Double!
    var calories: Int!
    //var reviews: [Review]!
    var imageLinks: [String]!
    init() {
        
    }
    init(_dictionary: NSDictionary) {
        id = _dictionary[K.OrderdCategoryItemFStore.categoryItemIdField] as? String
        categoryId = _dictionary[K.OrderdCategoryItemFStore.categoryIdField] as? String
        name = _dictionary[K.OrderdCategoryItemFStore.categoryItemNameField] as? String
        imageLinks = _dictionary[K.OrderdCategoryItemFStore.imageLinksField] as? [String]
        description = _dictionary[K.OrderdCategoryItemFStore.description] as? String
        calories = _dictionary[K.OrderdCategoryItemFStore.caloriesField] as? Int
        price = _dictionary[K.OrderdCategoryItemFStore.priceField] as? Double
        numOfOrders = _dictionary[K.OrderdCategoryItemFStore.ordersNumber] as? Int
        time = _dictionary[K.CategoryItemFStore.timeField] as? String
    }
}
