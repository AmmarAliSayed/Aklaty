//
//  FireStoreService.swift
//  Aklaty
//
//  Created by Macbook on 22/07/2021.
//

import Foundation
import FirebaseAuth
class FireStoreService {

    //MARK: - User
    // create user collection in firestore
   static func saveUserToFirestore(user: User) {
        
    getFirebaseReference(.Users).document(user.userId).setData([K.UsersFStore.userIdField :user.userId ?? "" ,   K.UsersFStore.userNameField : user.name ?? "" ,  K.UsersFStore.phoneField : user.phone ?? "00000000000", K.UsersFStore.emailField : user.email ?? "" ,  K.UsersFStore.imageLinksField : user.imageLinks ?? []])  { (error) in
            
            if error != nil {
                print("error saving user \(error!.localizedDescription)")
            }
        }
    }

func retriveUserFromFirestore(userId: String, completion: @escaping (_ user: User?) -> Void) {

    getFirebaseReference(.Users).whereField(K.UsersFStore.userIdField , isEqualTo: userId).getDocuments { (snapshot, error) in
        
        guard let snapshot = snapshot else {
            
            completion(nil)
            return
        }
        
        if !snapshot.isEmpty && snapshot.documents.count > 0 {
            let user = User(_dictionary: snapshot.documents.first!.data() as NSDictionary)
            completion(user)
        } else {
            completion(nil)
        }
    }

}
    func updateCurrentUserInFirestore(withValues: [String : Any], completion: @escaping (_ error: Error?) -> Void) {
        
            getFirebaseReference(.Users).document(Auth.auth().currentUser!.uid).updateData(withValues) { (error) in
                
                completion(error)
                
                if error == nil {// then no error so the user object updated in firestore so can save it in UserDefaults
                    //saveUserLocally(mUserDictionary: userObject)
                    print("update done")
                }
            }
        
    }
    //MARK: - Category
    func saveCategoryToFirebase(_ category : Category ,completion: @escaping (_ error: Error?) ->Void){
        //create random id
//        let id = UUID().uuidString
//        category.id = id
        getFirebaseReference(.Category).document(category.id).setData([K.CategoryFStore.categoryIdField :category.id , K.CategoryFStore.categoryNameField : category.name ,  K.CategoryFStore.imagesLinksField : category.imageLinks]) { (error) in
            if let e = error {
                print("there is an error in saving data to fireStore \(e)")
                completion(e)
            }else {
                print("successifly saving data to fireStore")
                completion(nil)
            }
        }}
    func retrieveCategoriesFromFirebase(completion: @escaping (_ categoryArray: [Category]) -> Void) {
        
        var categoriesArr: [Category] = []
        
        getFirebaseReference(.Category).getDocuments { (snapshot, error) in
            
            guard let snapshot = snapshot else {
                completion(categoriesArr)
                return
            }
            
            if !snapshot.isEmpty {
                
                for doc in snapshot.documents {
                    // print(doc.data())
                    let data = doc.data()
                    if let categoryName = data[K.CategoryFStore.categoryNameField ] as? String ,let  images = data [K.CategoryFStore.imagesLinksField]as? [String] , let categoryId =  data[K.CategoryFStore.categoryIdField] as? String {
                       
                        let category = Category()
                        category.id  = categoryId
                        category.name = categoryName
                        category.imageLinks = images
                        categoriesArr.append(category)
                    }
                   
                }
            }
            
            completion(categoriesArr)
        }
        
    }
    //MARK: Save items func

    func saveCategoryItemToFirestore(_ categoryItem : CategoryItem ,completion: @escaping (_ error: Error?) ->Void){
 //K.CategoryItemFStore.reviewsField : categoryItem.reviews ?? []
        getFirebaseReference(.CategoryItems).document(categoryItem.id).setData([K.CategoryItemFStore.categoryItemIdField :categoryItem.id ?? "" ,K.CategoryItemFStore.categoryIdField :categoryItem.categoryId ?? "" , K.CategoryItemFStore.categoryItemNameField : categoryItem.name ?? "" , K.CategoryItemFStore.description : categoryItem.description ?? "" ,K.CategoryItemFStore.timeField : categoryItem.time ?? "" ,K.CategoryItemFStore.priceField : categoryItem.price ?? 0.0 ,K.CategoryItemFStore.caloriesField : categoryItem.calories ?? 0 ,
                                                                                K.CategoryItemFStore.imageLinksField : categoryItem.imageLinks ?? []]) { (error) in
            if let e = error {
                print("there is an error in saving data to fireStore \(e)")
                completion(e)
            }else {
                print("successifly saving data to fireStore")
                completion(nil)
            }
        }}
    func retrieveCategoryItemsFromFirebase(_ withCategoryId: String,completion: @escaping (_ categoryItemsArray: [CategoryItem]) -> Void) {
        //,let  reviews = data [ K.CategoryItemFStore.reviewsField]as? [Review]
        var categoriesItemsArr: [CategoryItem] = []
        
        getFirebaseReference(.CategoryItems).whereField(K.CategoryItemFStore.categoryIdField, isEqualTo: withCategoryId).getDocuments  { (snapshot, error) in
            
            guard let snapshot = snapshot else {
                completion(categoriesItemsArr)
                return
            }
            
            if !snapshot.isEmpty {
                for doc in snapshot.documents {
                    // print(doc.data())
                    let data = doc.data()
                   print(data)
                    if let categoryItemId = data[K.CategoryItemFStore.categoryItemIdField ] as? String,let categoryId = data[K.CategoryItemFStore.categoryIdField ] as? String,let  images = data [ K.CategoryItemFStore.imageLinksField]as? [String] , let categoryItemName = data[K.CategoryItemFStore.categoryItemNameField ] as? String, let description = data[K.CategoryItemFStore.description ] as? String,let time = data[K.CategoryItemFStore.timeField ] as? String,let calories = data[K.CategoryItemFStore.caloriesField ] as? Int ,let price = data[K.CategoryItemFStore.priceField ] as? Double {
                       
                        let categoryItem = CategoryItem()
                        categoryItem.id = categoryItemId
                       // print("\(categoryItemId)")
                        categoryItem.categoryId = categoryId
                        categoryItem.description = description
                        categoryItem.name = categoryItemName
                        categoryItem.price = price
                        categoryItem.calories = calories
                        categoryItem.imageLinks = images
                       // categoryItem.updatedPrice = updatedPrice
                        categoryItem.time = time
                        
                       categoriesItemsArr.append(categoryItem)
                    }
                   
                }
            }
            
            completion(categoriesItemsArr)
        }
    }
    
    func downloadCategoriesForSearch (_ withIds: [String], completion: @escaping (_ itemsArray: [Category]) ->Void) {
        
        var count = 0
        var itemArr: [Category] = []
        
        if withIds.count > 0 {
            
            for itemId in withIds {

                getFirebaseReference(.Category).document(itemId).getDocument { (snapshot, error) in
                    
                    guard let snapshot = snapshot else {
                        completion(itemArr)
                        return
                    }

                    if snapshot.exists {

                        itemArr.append(Category(_dictionary: snapshot.data()! as NSDictionary))
                        count += 1
                    }
                    
                    if count == withIds.count {
                        completion(itemArr)
                    }
                    
                }
            }
        } else {
            completion(itemArr)
        }
    }

    func updateCategoryItemInFirestore(_ item: CategoryItem, withValues: [String : Any], completion: @escaping (_ error: Error?) -> Void) {
        
        
        getFirebaseReference(.CategoryItems).document(item.id).updateData(withValues) { (error) in
            completion(error)
        }
    }
    func retrieveCategoryItemDetailsFromFirebase(_ withCategoryItemId: String,completion: @escaping (_ categoryItem: CategoryItem?) -> Void) {
        
        getFirebaseReference(.CategoryItems).whereField(K.CategoryItemFStore.categoryItemIdField, isEqualTo: withCategoryItemId).getDocuments  { (snapshot, error) in
            
            guard let snapshot = snapshot else {
                completion(nil)
                return
            }
                    if !snapshot.isEmpty && snapshot.documents.count > 0 {
                        
                        let item = CategoryItem(_dictionary: snapshot.documents.first!.data() as NSDictionary)
                        completion(item)
                    } else {
                        completion(nil)
                    }
                }
    }
    //MARK: Reviews

    func saveItemReviewsToFirestore(_ review : Review ,completion: @escaping (_ error: Error?) ->Void){
 
        getFirebaseReference(.Reviews).document(review.id).setData([K.ReviewFStore.reviewId :review.id ?? "" ,K.ReviewFStore.itemIDField :review.itemId ?? "",K.ReviewFStore.bodyField :review.body ?? "",K.ReviewFStore.reviewImagesLinksField :review.userImageLinks ?? []]) { (error) in
            if let e = error {
                print("there is an error in saving data to fireStore \(e)")
                completion(e)
            }else {
                print("successifly saving data to fireStore")
                completion(nil)
            }
        }}
    func retrieveItemReviewsFromFirebase(_ withItemId: String,completion: @escaping (_ reviewsArray: [Review]) -> Void) {
        //,let  reviews = data [ K.CategoryItemFStore.reviewsField]as? [Review]
        var reviewsArr: [Review] = []
        
//        getFirebaseReference(.Reviews).whereField(K.ReviewFStore.itemIDField, isEqualTo: withItemId).getDocuments  { (snapshot, error) in
        getFirebaseReference(.Reviews).whereField(K.ReviewFStore.itemIDField, isEqualTo: withItemId).addSnapshotListener  { (snapshot, error) in
            
            //empty array to prevent the duplication of messages
            reviewsArr = []
            guard let snapshot = snapshot else {
                completion(reviewsArr)
                return
            }
            
            if !snapshot.isEmpty {
                for doc in snapshot.documents {
                    // print(doc.data())
                    let data = doc.data()
                  // print(data)
                    if let reviewId = data[K.ReviewFStore.reviewId ] as? String ,let itemId = data[K.ReviewFStore.itemIDField ] as? String ,let body = data[K.ReviewFStore.bodyField ] as? String , let images = data[K.ReviewFStore.reviewImagesLinksField ] as? [String]{
                       
                        let review = Review()
                        review.id = reviewId
                        review.itemId = itemId
                        review.body = body
                        review.userImageLinks = images
                       reviewsArr.append(review)
                    }
                   
                }
            }
            
            completion(reviewsArr)
        }
        
    }
//MARK: - Items
    func saveItemToPopularMenuFirestore(_ item : Item ,completion: @escaping (_ error: Error?) ->Void){
        getFirebaseReference(.PopularMenu).document(item.id).setData([K.ItemFStore.itemIdField :item.id ?? "",K.ItemFStore.ItemNameField :item.name ?? "" ,K.ItemFStore.description :item.description ?? "",K.ItemFStore.caloriesField :item.calories ?? 0 ,K.ItemFStore.priceField :item.price ?? 0.0 ,K.ItemFStore.imageLinksField :item.imageLinks ?? [],K.ItemFStore.timeField :item.time ?? ""]) { (error) in
          if let e = error {
              print("there is an error in saving data to fireStore \(e)")
              completion(e)
          }else {
              print("successifly saving data to fireStore")
              completion(nil)
          }
    }}
    
    func saveItemToHealthyFoodFirestore(_ item : Item ,completion: @escaping (_ error: Error?) ->Void){
        getFirebaseReference(.HealthyFood).document(item.id).setData([K.ItemFStore.itemIdField :item.id ?? "",K.ItemFStore.ItemNameField :item.name ?? "" ,K.ItemFStore.description :item.description ?? "",K.ItemFStore.caloriesField :item.calories ?? 0 ,K.ItemFStore.priceField :item.price ?? 0.0 ,K.ItemFStore.imageLinksField :item.imageLinks ?? [],K.ItemFStore.timeField :item.time ?? ""]) { (error) in
          if let e = error {
              print("there is an error in saving data to fireStore \(e)")
              completion(e)
          }else {
              print("successifly saving data to fireStore")
              completion(nil)
          }
    }}
    func retrieveItemsFromPopularMenuFirestore(completion: @escaping (_ itemArray: [Item]) -> Void) {
        
        var itemsArr: [Item] = []
        
        getFirebaseReference(.PopularMenu).getDocuments { (snapshot, error) in
            
            guard let snapshot = snapshot else {
                completion(itemsArr)
                return
            }
            
            if !snapshot.isEmpty {
                
                for doc in snapshot.documents {
                     print(doc.data())
                    let data = doc.data()
                    if let id = data[K.ItemFStore.itemIdField ] as? String,let  images = data [ K.ItemFStore.imageLinksField]as? [String] , let itemName = data[K.ItemFStore.ItemNameField ] as? String, let description = data[K.ItemFStore.description ] as? String ,let calories = data[K.ItemFStore.caloriesField ] as? Int ,let price = data[K.ItemFStore.priceField ] as? Double,let time = data[K.ItemFStore.timeField ] as? String{
                       
                        let item = Item()
                        item.id  = id
                       item.name = itemName
                        item.imageLinks = images
                       item.calories = calories
                       item.price = price
                        item.description = description
                        item.time = time
                        itemsArr.append(item)
                    }
                   
                }
            }
            
            completion(itemsArr)
        }
        
    }
    
    func retrieveItemsFromHealthyFoodFirestore(completion: @escaping (_ itemArray: [Item]) -> Void) {
        
        var itemsArr: [Item] = []
        
        getFirebaseReference(.HealthyFood).getDocuments { (snapshot, error) in
            
            guard let snapshot = snapshot else {
                completion(itemsArr)
                return
            }
            
            if !snapshot.isEmpty {
                
                for doc in snapshot.documents {
                     print(doc.data())
                    let data = doc.data()
                    if let id = data[K.ItemFStore.itemIdField ] as? String,let  images = data [ K.ItemFStore.imageLinksField]as? [String] , let itemName = data[K.ItemFStore.ItemNameField ] as? String, let description = data[K.ItemFStore.description ] as? String ,let calories = data[K.ItemFStore.caloriesField ] as? Int ,let price = data[K.ItemFStore.priceField ] as? Double,let time = data[K.ItemFStore.timeField ] as? String{
                       
                        let item = Item()
                        item.id  = id
                       item.name = itemName
                        item.imageLinks = images
                       item.calories = calories
                       item.price = price
                        item.description = description
                        item.time = time
                        itemsArr.append(item)
                    }
                   
                }
            }
            
            completion(itemsArr)
        }
        
    }
    func retrievePopularMenuItemDetailsFromFirebase(_ withItemId: String,completion: @escaping (_ item: Item?) -> Void) {
        
        getFirebaseReference(.PopularMenu).whereField(K.ItemFStore.itemIdField, isEqualTo: withItemId).getDocuments  { (snapshot, error) in
            
            guard let snapshot = snapshot else {
                completion(nil)
                return
            }
                    if !snapshot.isEmpty && snapshot.documents.count > 0 {
                        
                        let item = Item(_dictionary: snapshot.documents.first!.data() as NSDictionary)
                        completion(item)
                    } else {
                        completion(nil)
                    }
                }
    }
    
    func retrieveHealthyFoodItemDetailsFromFirebase(_ withItemId: String,completion: @escaping (_ item: Item?) -> Void) {
        
        getFirebaseReference(.HealthyFood).whereField(K.ItemFStore.itemIdField, isEqualTo: withItemId).getDocuments  { (snapshot, error) in
            
            guard let snapshot = snapshot else {
                completion(nil)
                return
            }
                    if !snapshot.isEmpty && snapshot.documents.count > 0 {
                        
                        let item = Item(_dictionary: snapshot.documents.first!.data() as NSDictionary)
                        completion(item)
                    } else {
                        completion(nil)
                    }
                }
    }
    //MARK: - Offers
    func saveOccasionOfferFirestore(_ offer : OccasionOffer ,completion: @escaping (_ error: Error?) ->Void){
        getFirebaseReference(.OccasionOffer).document(offer.id).setData([K.OccasionOfferFStore.occasionOfferIdField :offer.id ?? "",K.OccasionOfferFStore.offerDiscriptionField :offer.offerDiscription ?? "" ,K.OccasionOfferFStore.discountRateField :offer.discountRate ?? 0,K.OccasionOfferFStore.imagesLinksField :offer.imageLinks ?? [],K.OccasionOfferFStore.vaildTimeField :offer.vaildTime ?? ""]) { (error) in
          if let e = error {
              print("there is an error in saving data to fireStore \(e)")
              completion(e)
          }else {
              print("successifly saving data to fireStore")
              completion(nil)
          }
    }}
    func retrieveOccasionOffersFromFirebase(completion: @escaping (_ offersArray: [OccasionOffer]) -> Void) {
        
        var offersArr: [OccasionOffer] = []
        
        getFirebaseReference(.OccasionOffer).getDocuments { (snapshot, error) in
            
            guard let snapshot = snapshot else {
                completion(offersArr)
                return
            }
            
            if !snapshot.isEmpty {
                
                for doc in snapshot.documents {
                    // print(doc.data())
                    let data = doc.data()
                    if let offerId = data[K.OccasionOfferFStore.occasionOfferIdField ] as? String ,let  images = data [K.OccasionOfferFStore.imagesLinksField]as? [String] , let offerDisc =  data[K.OccasionOfferFStore.offerDiscriptionField] as? String , let offerTime =  data[K.OccasionOfferFStore.vaildTimeField] as? String , let discountRate =  data[K.OccasionOfferFStore.discountRateField] as? Int{
                       
                        let offer = OccasionOffer()
                        offer.id = offerId
                        offer.imageLinks = images
                        offer.discountRate = discountRate
                        offer.offerDiscription = offerDisc
                        offer.vaildTime = offerTime
                        offersArr.append(offer)
                    }
                   
                }
            }
            
            completion(offersArr)
        }
        
    }
    
    func saveTodayOffersFirestore(_ offer : Offer ,completion: @escaping (_ error: Error?) ->Void){
        getFirebaseReference(.TodayOffers).document(offer.id).setData([K.OfferFStore.offerIdField :offer.id ?? "",K.OfferFStore.offerNameField :offer.name ?? "" ,K.OfferFStore.discountRateField :offer.discountRate ?? 0,K.OfferFStore.imageLinksField :offer.imageLinks ?? [],K.OfferFStore.timeField :offer.time ?? "",K.OfferFStore.priceField :offer.price ?? 0.0]) { (error) in
          if let e = error {
              print("there is an error in saving data to fireStore \(e)")
              completion(e)
          }else {
              print("successifly saving data to fireStore")
              completion(nil)
          }
    }}
    
    func retrieveTodayOffersFromFirebase(completion: @escaping (_ offersArray: [Offer]) -> Void) {
        
        var offersArr: [Offer] = []
        
        getFirebaseReference(.TodayOffers).getDocuments { (snapshot, error) in
            
            guard let snapshot = snapshot else {
                completion(offersArr)
                return
            }
            
            if !snapshot.isEmpty {
                for doc in snapshot.documents {
                    // print(doc.data())
                    let data = doc.data()
                    if let offerId = data[K.OfferFStore.offerIdField ] as? String ,let  images = data [K.OfferFStore.imageLinksField]as? [String] , let offerName =  data[K.OfferFStore.offerNameField] as? String , let offerTime =  data[K.OfferFStore.timeField] as? String , let discountRate =  data[K.OfferFStore.discountRateField] as? Int , let price = data[K.OfferFStore.priceField] as? Double{
                       
                        let offer = Offer()
                        offer.id = offerId
                        offer.imageLinks = images
                        offer.discountRate = discountRate
                        offer.name = offerName
                        offer.time = offerTime
                        offer.price = price
                        offersArr.append(offer)
                    }
                   
                }
            }
            
            completion(offersArr)
        }
        
    }
    func retrieveTodayOfferDetailsFromFirebase(_ withItemId: String,completion: @escaping (_ item: Offer?) -> Void) {
        
        getFirebaseReference(.TodayOffers).whereField(K.OfferFStore.offerIdField, isEqualTo: withItemId).getDocuments  { (snapshot, error) in
            
            guard let snapshot = snapshot else {
                completion(nil)
                return
            }
                    if !snapshot.isEmpty && snapshot.documents.count > 0 {
                        
                        let item = Offer(_dictionary: snapshot.documents.first!.data() as NSDictionary)
                        completion(item)
                    } else {
                        completion(nil)
                    }
                }
    }
    func saveFreeDeliveryOffersFirestore(_ offer : Offer ,completion: @escaping (_ error: Error?) ->Void){
        getFirebaseReference(.FreeDelivery).document(offer.id).setData([K.OfferFStore.offerIdField :offer.id ?? "",K.OfferFStore.offerNameField :offer.name ?? "" ,K.OfferFStore.discountRateField :offer.discountRate ?? 0,K.OfferFStore.imageLinksField :offer.imageLinks ?? [],K.OfferFStore.timeField :offer.time ?? "",K.OfferFStore.priceField :offer.price ?? 0.0]) { (error) in
          if let e = error {
              print("there is an error in saving data to fireStore \(e)")
              completion(e)
          }else {
              print("successifly saving data to fireStore")
              completion(nil)
          }
    }}
    func retrieveFreeDeliveryOffersFromFirebase(completion: @escaping (_ offersArray: [Offer]) -> Void) {
        
        var offersArr: [Offer] = []
        
        getFirebaseReference(.FreeDelivery).getDocuments { (snapshot, error) in
            
            guard let snapshot = snapshot else {
                completion(offersArr)
                return
            }
            
            if !snapshot.isEmpty {
                for doc in snapshot.documents {
                    // print(doc.data())
                    let data = doc.data()
                    if let offerId = data[K.OfferFStore.offerIdField ] as? String ,let  images = data [K.OfferFStore.imageLinksField]as? [String] , let offerName =  data[K.OfferFStore.offerNameField] as? String , let offerTime =  data[K.OfferFStore.timeField] as? String , let discountRate =  data[K.OfferFStore.discountRateField] as? Int , let price = data[K.OfferFStore.priceField] as? Double{
                       
                        let offer = Offer()
                        offer.id = offerId
                        offer.imageLinks = images
                        offer.discountRate = discountRate
                        offer.name = offerName
                        offer.time = offerTime
                        offer.price = price
                        offersArr.append(offer)
                    }
                   
                }
            }
            
            completion(offersArr)
        }
        
    }
    func retrieveFreeDeliveryOfferDetailsFromFirebase(_ withItemId: String,completion: @escaping (_ item: Offer?) -> Void) {
        
        getFirebaseReference(.FreeDelivery).whereField(K.OfferFStore.offerIdField, isEqualTo: withItemId).getDocuments  { (snapshot, error) in
            
            guard let snapshot = snapshot else {
                completion(nil)
                return
            }
                    if !snapshot.isEmpty && snapshot.documents.count > 0 {
                        
                        let item = Offer(_dictionary: snapshot.documents.first!.data() as NSDictionary)
                        completion(item)
                    } else {
                        completion(nil)
                    }
                }
    }
    //MARK: - Basket
     func saveBasketToFirestore(_ basket: Basket) {
        getFirebaseReference(.Baskets).document(basket.basketId).setData([K.BasketFStore.basketIdField :basket.basketId , K.BasketFStore.ownerIdField : basket.ownerId ,  K.BasketFStore.CategoryItemsIds : basket.categoryItemsIds ,  K.BasketFStore.popularMenuIds : basket.popularMenuIds ,  K.BasketFStore.healthyFoodIds : basket.healthyFoodIds ,  K.BasketFStore.TodayOffersIds : basket.TodayOffersIds ,  K.BasketFStore.FreeDeliveryIds : basket.FreeDeliveryIds ]) { (error) in
            if let e = error {
                print("there is an error in saving data to fireStore \(e)")
            }else {
                print("successifly saving data to fireStore")
            }
        }}
    
    func updateBasketInFirestore(_ basket: Basket, withValues: [String : Any], completion: @escaping (_ error: Error?) -> Void) {
        
        
        getFirebaseReference(.Baskets).document(basket.basketId).updateData(withValues) { (error) in
            completion(error)
        }
    }
    
    func downloadBasketFromFirestore(_ ownerId: String, completion: @escaping (_ basket: Basket?)-> Void) {
        
        getFirebaseReference(.Baskets).whereField(K.BasketFStore.ownerIdField , isEqualTo: ownerId).getDocuments { (snapshot, error) in
            
            guard let snapshot = snapshot else {
                
                completion(nil)
                return
            }
            
            if !snapshot.isEmpty && snapshot.documents.count > 0 {
                let basket = Basket(_dictionary: snapshot.documents.first!.data() as NSDictionary)
                completion(basket)
            } else {
                completion(nil)
            }
        }
    }
    //MARK: Download Category Items for specific basket Func
    func downloadOrderedCategoryItemsForSpecificBasket (_ withIds: [String], completion: @escaping (_ categoryItemsArray: [OrderedCategoryItem]) ->Void) {
        
        var count = 0
        var itemsArr: [OrderedCategoryItem] = []
        
        if withIds.count > 0 {
            
            for itemId in withIds {
                getFirebaseReference(.OrderedCategoryItems).document(itemId).getDocument { (snapshot, error) in
                    
                    guard let snapshot = snapshot else {
                        completion(itemsArr)
                        return
                    }

                    if snapshot.exists {

                        itemsArr.append(OrderedCategoryItem(_dictionary: snapshot.data()! as NSDictionary))
                        count += 1
                    }
                    
                    if count == withIds.count {
                        completion(itemsArr)
                    }
                    
                }
            }
        } else {
            completion(itemsArr)
        }
    }
    
    func downloadOrderedPopularMenuItemForSpecificBasket (_ withIds: [String], completion: @escaping (_ itemsArray: [OrderedItem]) ->Void) {
        
        var count = 0
        var itemsArr: [OrderedItem] = []
        
        if withIds.count > 0 {
            
            for itemId in withIds {
                getFirebaseReference(.OrderedPopularMenuItems).document(itemId).getDocument { (snapshot, error) in
                    
                    guard let snapshot = snapshot else {
                        completion(itemsArr)
                        return
                    }

                    if snapshot.exists {

                        itemsArr.append(OrderedItem(_dictionary: snapshot.data()! as NSDictionary))
                        count += 1
                    }
                    
                    if count == withIds.count {
                        completion(itemsArr)
                    }
                    
                }
            }
        } else {
            completion(itemsArr)
        }
    }
    
    func downloadOrderedHealthyFoodItemsForSpecificBasket (_ withIds: [String], completion: @escaping (_ itemsArray: [OrderedItem]) ->Void) {
        
        var count = 0
        var itemsArr: [OrderedItem] = []
        
        if withIds.count > 0 {
            
            for itemId in withIds {
                getFirebaseReference(.OrderedHealthyFoodItems).document(itemId).getDocument { (snapshot, error) in
                    
                    guard let snapshot = snapshot else {
                        completion(itemsArr)
                        return
                    }

                    if snapshot.exists {

                        itemsArr.append(OrderedItem(_dictionary: snapshot.data()! as NSDictionary))
                        count += 1
                    }
                    
                    if count == withIds.count {
                        completion(itemsArr)
                    }
                    
                }
            }
        } else {
            completion(itemsArr)
        }
    }
    func downloadOrderedTodayItemsForSpecificBasket (_ withIds: [String], completion: @escaping (_ itemsArray: [OrderedOffer]) ->Void) {
        
        var count = 0
        var itemsArr: [OrderedOffer] = []
        
        if withIds.count > 0 {
            
            for itemId in withIds {
                getFirebaseReference(.OrderedTodayOfferItems).document(itemId).getDocument { (snapshot, error) in
                    
                    guard let snapshot = snapshot else {
                        completion(itemsArr)
                        return
                    }

                    if snapshot.exists {

                        itemsArr.append(OrderedOffer(_dictionary: snapshot.data()! as NSDictionary))
                        count += 1
                    }
                    
                    if count == withIds.count {
                        completion(itemsArr)
                    }
                    
                }
            }
        } else {
            completion(itemsArr)
        }
    }
    func downloadFreeDeliveryItemsForSpecificBasket (_ withIds: [String], completion: @escaping (_ itemsArray: [OrderedOffer]) ->Void) {
        
        var count = 0
        var itemsArr: [OrderedOffer] = []
        
        if withIds.count > 0 {
            
            for itemId in withIds {
                getFirebaseReference(.OrderedFreeDeliveryItems).document(itemId).getDocument { (snapshot, error) in
                    
                    guard let snapshot = snapshot else {
                        completion(itemsArr)
                        return
                    }

                    if snapshot.exists {

                        itemsArr.append(OrderedOffer(_dictionary: snapshot.data()! as NSDictionary))
                        count += 1
                    }
                    
                    if count == withIds.count {
                        completion(itemsArr)
                    }
                    
                }
            }
        } else {
            completion(itemsArr)
        }
    }
    func saveOrderedCategoryItemToFirestore(_ categoryItem : OrderedCategoryItem ,completion: @escaping (_ error: Error?) ->Void){
 //K.CategoryItemFStore.reviewsField : categoryItem.reviews ?? []
        getFirebaseReference(.OrderedCategoryItems).document(categoryItem.id).setData([K.OrderdCategoryItemFStore.categoryItemIdField :categoryItem.id ?? "" ,K.OrderdCategoryItemFStore.categoryIdField :categoryItem.categoryId ?? "" , K.OrderdCategoryItemFStore.categoryItemNameField : categoryItem.name ?? "" , K.OrderdCategoryItemFStore.description : categoryItem.description ?? "" ,K.OrderdCategoryItemFStore.timeField : categoryItem.time ?? "" ,K.OrderdCategoryItemFStore.priceField : categoryItem.price ?? 0.0 ,K.OrderdCategoryItemFStore.caloriesField : categoryItem.calories ?? 0 ,K.OrderdCategoryItemFStore.ordersNumber : categoryItem.numOfOrders ?? 0 ,
                                                                                K.CategoryItemFStore.imageLinksField : categoryItem.imageLinks ?? []]) { (error) in
            if let e = error {
                print("there is an error in saving data to fireStore \(e)")
                completion(e)
            }else {
                print("successifly saving data to fireStore")
                completion(nil)
            }
        }}
    func saveOrderedPopularMenuItemToFirestore(_ item : OrderedItem ,completion: @escaping (_ error: Error?) ->Void){
 
        getFirebaseReference(.OrderedPopularMenuItems).document(item.id).setData([K.OrderedItemFStore.itemIdField :item.id ?? "" , K.OrderedItemFStore.ItemNameField : item.name ?? "" , K.OrderedItemFStore.description : item.description ?? "" ,K.OrderedItemFStore.timeField : item.time ?? "" ,K.OrderedItemFStore.priceField : item.price ?? 0.0 ,K.OrderedItemFStore.caloriesField : item.calories ?? 0 ,K.OrderedItemFStore.ordersNumber : item.numOfOrders ?? 0 ,K.CategoryItemFStore.imageLinksField :item.imageLinks ?? []]) { (error) in
                                                             
            if let e = error {
                print("there is an error in saving data to fireStore \(e)")
                completion(e)
            }else {
                print("successifly saving data to fireStore")
                completion(nil)
            }
        }}
    func saveOrderedHealthyFoodItemToFirestore(_ item : OrderedItem ,completion: @escaping (_ error: Error?) ->Void){
 
        getFirebaseReference(.OrderedHealthyFoodItems).document(item.id).setData([K.OrderedItemFStore.itemIdField :item.id ?? "" , K.OrderedItemFStore.ItemNameField : item.name ?? "" , K.OrderedItemFStore.description : item.description ?? "" ,K.OrderedItemFStore.timeField : item.time ?? "" ,K.OrderedItemFStore.priceField : item.price ?? 0.0 ,K.OrderedItemFStore.caloriesField : item.calories ?? 0 ,K.OrderedItemFStore.ordersNumber : item.numOfOrders ?? 0 ,K.CategoryItemFStore.imageLinksField :item.imageLinks ?? []]) { (error) in
                                                             
            if let e = error {
                print("there is an error in saving data to fireStore \(e)")
                completion(e)
            }else {
                print("successifly saving data to fireStore")
                completion(nil)
            }
        }}
    func saveOrderedTodayOfferItemToFirestore(_ item : OrderedOffer ,completion: @escaping (_ error: Error?) ->Void){
 
        getFirebaseReference(.OrderedTodayOfferItems).document(item.id).setData([K.OrderedOfferFStore.itemIdField :item.id ?? "" , K.OrderedOfferFStore.ItemNameField : item.name ?? ""  ,K.OrderedOfferFStore.timeField : item.time ?? "" ,K.OrderedOfferFStore.priceField : item.price ?? 0.0 ,K.OrderedOfferFStore.ordersNumber : item.numOfOrders ?? 0 ,K.OrderedOfferFStore.imageLinksField :item.imageLinks ?? []]) { (error) in
                                                             
            if let e = error {
                print("there is an error in saving data to fireStore \(e)")
                completion(e)
            }else {
                print("successifly saving data to fireStore")
                completion(nil)
            }
        }}
    func saveOrderedfreeDeliveryItemToFirestore(_ item : OrderedOffer ,completion: @escaping (_ error: Error?) ->Void){
 
        getFirebaseReference(.OrderedFreeDeliveryItems).document(item.id).setData([K.OrderedOfferFStore.itemIdField :item.id ?? "" , K.OrderedOfferFStore.ItemNameField : item.name ?? ""  ,K.OrderedOfferFStore.timeField : item.time ?? "" ,K.OrderedOfferFStore.priceField : item.price ?? 0.0 ,K.OrderedOfferFStore.ordersNumber : item.numOfOrders ?? 0 ,K.OrderedOfferFStore.imageLinksField :item.imageLinks ?? []]) { (error) in
                                                             
            if let e = error {
                print("there is an error in saving data to fireStore \(e)")
                completion(e)
            }else {
                print("successifly saving data to fireStore")
                completion(nil)
            }
        }}
}


