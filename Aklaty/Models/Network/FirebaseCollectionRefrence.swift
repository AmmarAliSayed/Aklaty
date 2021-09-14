//
//  FirebaseCollectionRefrence.swift
//  Aklaty
//
//  Created by Macbook on 22/07/2021.
//

import Foundation
import FirebaseFirestore
enum FCollectionRefrence : String {
    case Category
    case Users
    case CategoryItems
    case Reviews
    case PopularMenu
    case HealthyFood
    case OccasionOffer
    case TodayOffers
    case FreeDelivery
    case Baskets
    case OrderedCategoryItems
    case OrderedPopularMenuItems
    case OrderedHealthyFoodItems
    case OrderedTodayOfferItems
    case OrderedFreeDeliveryItems
}
func getFirebaseReference(_ collectionRefrence : FCollectionRefrence) -> CollectionReference {
    return Firestore.firestore().collection(collectionRefrence.rawValue)
}
