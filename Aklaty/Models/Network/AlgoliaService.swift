//
//  AlgoliaService.swift
//  Aklaty
//
//  Created by Macbook on 10/09/2021.
//

import Foundation
import InstantSearchClient //Algolia
class AlgoliaService {
    
    // let shared = AlgoliaService()
    
    let client = Client(appID: K.Algolia.APP_ID, apiKey: K.Algolia.ADMIN_KEY)
    let categoryIndex = Client(appID: K.Algolia.APP_ID, apiKey:  K.Algolia.ADMIN_KEY).index(withName: "category_Name")
     init() {}
    
    //MARK: - Algolia Funcs
    //when create new item in firestore we want also save it in Algolia
    func saveCategoryToAlgolia(category: Category) {
        
        let index = categoryIndex
        
        let categoryToSave = categoryDictionaryFrom(category) as! [String : Any]
        
        index.addObject(categoryToSave, withID: category.id, requestOptions: nil) { (content, error) in
            
            if error != nil {
                print("error saving to algolia", error!.localizedDescription)
            } else {
                print("added to algolia")
            }
        }
    }

    func searchCategoryInAlgolia(searchString: String, completion: @escaping (_ itemArray: [String]) -> Void) {

        let index = categoryIndex
        var resultIds: [String] = []
        
        let query = Query(query: searchString)
        
        query.attributesToRetrieve = ["category_Name"]
        
        index.search(query) { (content, error) in
            
            if error == nil {
                let cont = content!["hits"] as! [[String : Any]]
                
                resultIds = []
                
                for result in cont {
                    resultIds.append(result["objectID"] as! String)
                }
                
                completion(resultIds)
            } else {
                print("Error algolia search ", error!.localizedDescription)
                completion(resultIds)
            }
        }
    }



}


