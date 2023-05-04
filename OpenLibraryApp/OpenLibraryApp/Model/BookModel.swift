//
//  BookModel.swift
//  OpenLibraryApp
//
//  Created by Artyom Butorin on 15.04.23.
//

import Foundation

struct BookData: Decodable, Encodable {
    let works: [Book]
}

struct Book: Codable {
    let title: String
    let publishDate: Int?
    let coverURL: Int?
    let key: String // уникальный идентификатор книги в Open Library
    let averageRating: Double?

    enum CodingKeys: String, CodingKey {
        case title
        case publishDate = "first_publish_year"
        case coverURL = "cover_i"
        case key
        case averageRating = "average_rating"
    }
}

struct BookDetail: Decodable {
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case description
    }
}

struct AnotherBookDetail: Decodable {
    let description: Description
    
    enum CodingKeys: String, CodingKey {
        case description
    }
}

struct Description: Codable {
    let value: String
}

