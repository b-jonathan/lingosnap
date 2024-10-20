//
//  Model.swift
//  uikitpager
//
//  Created by User on 10/19/24.
//

import Foundation

struct APIResponse: Decodable {
    let page: Int
    let perPage: Int
    let totalItems: Int
    let totalPages: Int
    let items: [SlideData]
}

struct SlideData: Decodable {
    let collectionId: String
    let collectionName: String
    let created: String
    let id: String
    let image: String
    let translation: String
    let updated: String
    let word: String
}
