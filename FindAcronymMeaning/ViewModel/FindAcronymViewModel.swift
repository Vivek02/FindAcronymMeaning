//
//  FindAcronymViewModel.swift
//  FindAcronymMeaning
//
//  Created by TCS on 10/07/23.
//

import Foundation

protocol FindAcronymViewModelProtcol {
    var prodArray: [Product] { get }
    func getListOfAcronymMeaning(searchString: String, _ completion: @escaping (_ result:Bool) -> Void)
}

class FindAcronymViewModel: FindAcronymViewModelProtcol {
    
    let networkManager = WebServiceManager.shared
    var resourceName: String = "" /// for handling error scenrio in mock response
    var prodArray: [Product] = [Product]()
    
    func getListOfAcronymMeaning(searchString: String, _ completion: @escaping (_ result:Bool) -> Void) {
        prodArray.removeAll()
        if searchString.count > 3 {
            resourceName = "Products"
        } else {
            resourceName = "Error"
        }
        
        guard let requestURL = URL(string: "https://dummyjson.com/products/search?q=\(searchString)") else {
            return
        }
        
        networkManager.webServiceRequest(resourceName: resourceName, fromURL: requestURL) { (result: Result<ProductList?, Error>) in
            switch result {
            case .success(let productList):
                self.prodArray.append(contentsOf: productList?.products ?? [Product]())
                completion(true)
            case .failure(let error):
                debugPrint("The error is: \(error.localizedDescription)")
                completion(false)
            }
        }
    }
}
