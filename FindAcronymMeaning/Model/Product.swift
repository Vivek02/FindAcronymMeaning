//
//  Product.swift
//  FindAcronymMeaning
//
//  Created by TCS on 11/07/23.
//

import Foundation
import UIKit


//// MARK: - json data 
struct ProductList: Codable {
    let products: [Product]
    let total, skip, limit: Int
}


// MARK: - Product
struct Product: Codable {
    let id: Int
    let title, description: String
    let price: Int
    let discountPercentage, rating: Double
    let stock: Int
    let brand, category: String
    let thumbnail: String
    let images: [String]
}
