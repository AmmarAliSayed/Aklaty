//
//  Constants.swift
//  Aklaty
//
//  Created by Macbook on 22/07/2021.
//

import Foundation

struct K {

    
    //Firestore
    struct CategoryItemFStore {
        static let collectionName = "categoryItems"
        static let categoryItemIdField = "categoryItemId"
        static let categoryIdField = "categoryId"
        static let categoryItemNameField = "categoryItemName"
        static let priceField = "price"
       // static let updatedPriceField = "updatedPrice"
        static let timeField = "time"
        static let caloriesField = "calories"
        static let description = "description"
        static let imageLinksField = "images"
        static let reviewsField = "reviews"
    }
    struct UsersFStore {
        static let collectionName = "Users"
        static let userIdField = "userId"
        static let userNameField = "userName"
        static let phoneField = "phone"
        static let emailField = "email"
        static let imageLinksField = "imageLinks"

    }
    struct CategoryFStore {
        static let collectionName = "Categories"
        static let categoryIdField = "categoryId"
        static let categoryNameField = "categoryName"
        static let imagesLinksField = "images"
    }
    
    struct ReviewFStore {
        //static let collectionName = "Categories"
        static let bodyField = "body"
        static let reviewImagesLinksField = "images"
        static let itemIDField = "itemId"
        static let reviewId = "id"
    }
    struct ItemFStore {
        static let itemIdField = "itemId"
        static let ItemNameField = "itemName"
        static let priceField = "price"
        static let timeField = "time"
        static let caloriesField = "calories"
        static let description = "description"
        static let imageLinksField = "images"
        static let reviewsField = "reviews"
    }
    struct OccasionOfferFStore {
        static let occasionOfferIdField = "id"
        static let offerDiscriptionField = "offerDiscription"
        static let imagesLinksField = "images"
        static let discountRateField = "discountRate"
        static let vaildTimeField = "vaildTime"
    }
    struct OfferFStore {
        static let offerIdField = "id"
        static let offerNameField = "name"
        static let priceField = "price"
        static let timeField = "time"
        static let discountRateField = "discountRate"
        static let imageLinksField = "images"
    }
    struct BasketFStore {
        static let collectionName = "Basket"
        static let basketIdField = "basketId"
        static let ownerIdField = "ownerId"
        static let CategoryItemsIds = "categoryItemsIds"
        static let popularMenuIds = "popularMenuIds"
        static let healthyFoodIds = "healthyFoodIds"
        static let TodayOffersIds = "TodayOffersIds"
        static let FreeDeliveryIds = "FreeDeliveryIds"
    }
    struct OrderdCategoryItemFStore {
        static let collectionName = "categoryItems"
        static let categoryItemIdField = "categoryItemId"
        static let categoryIdField = "categoryId"
        static let categoryItemNameField = "categoryItemName"
        static let priceField = "price"
        static let ordersNumber = "numOfOrders"
        static let timeField = "time"
        static let caloriesField = "calories"
        static let description = "description"
        static let imageLinksField = "images"
        static let reviewsField = "reviews"
    }
    struct OrderedItemFStore {
        static let itemIdField = "itemId"
        static let ItemNameField = "itemName"
        static let priceField = "price"
        static let ordersNumber = "numOfOrders"
        static let timeField = "time"
        static let caloriesField = "calories"
        static let description = "description"
        static let imageLinksField = "images"
        static let reviewsField = "reviews"
    }
    
    struct OrderedOfferFStore {
        static let itemIdField = "itemId"
        static let ItemNameField = "itemName"
        static let priceField = "price"
        static let ordersNumber = "numOfOrders"
        static let timeField = "time"
        static let imageLinksField = "images"
        static let reviewsField = "reviews"
    }
    
//    struct UserDefaultsData{
//        static let userName = "userName"
//        static let email = "email"
//        static let CURRENTUSER  = "currentUser"
//    }
    //Storage
    struct Storage {
        static let folderPath = "gs://aklaty-62e58.appspot.com"
    }
    struct Algolia {
        static let SEARCH_KEY = "f4569f625aecd42443cf2edef0e94198"
        static let ADMIN_KEY = "019dfe23504a4258de97be6f05ec541d"
        static let  APP_ID = "0IGVB9B4TU"
    }
}
