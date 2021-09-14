//
//  Basket.swift
//  Aklaty
//
//  Created by Macbook on 22/08/2021.
//

import Foundation
class Basket {
    var basketId: String!
    var ownerId: String!
    var categoryItemsIds: [String] = []
    var popularMenuIds: [String] = []
    var healthyFoodIds: [String] = []
    var TodayOffersIds : [String] = []
    var FreeDeliveryIds : [String] = []
    init() {
        
    }
    init(_dictionary: NSDictionary) {
        basketId = _dictionary[K.BasketFStore.basketIdField] as? String
        ownerId = _dictionary[K.BasketFStore.ownerIdField] as? String
        categoryItemsIds = _dictionary[K.BasketFStore.CategoryItemsIds] as! [String]
        popularMenuIds = _dictionary[K.BasketFStore.popularMenuIds] as! [String]
        healthyFoodIds = _dictionary[K.BasketFStore.healthyFoodIds] as! [String]
        TodayOffersIds = _dictionary[K.BasketFStore.TodayOffersIds] as! [String]
        FreeDeliveryIds = _dictionary[K.BasketFStore.FreeDeliveryIds] as! [String]
    }
}
