//
//  Movie.swift
//  MovieSearch
//
//  Created by Haley Jones on 5/17/19.
//  Copyright © 2019 HaleyJones. All rights reserved.
//
//uikit includes foundation so we can just replace foundation; Also, we might want a movie image.
import UIKit
//we make it a struct cuz it's lighter and we dont really care about initializing

struct Movie: Codable{
    
    let title: String
    let description: String
    let rating: Double
    let imageLink: String?
    //release date is a string so im grabbing it because i can and it's easy.
    let releaseDate: String
    
    //because this API uses underscore naming we gotta make coding keys. Also i like "description" more than "overview"
    enum CodingKeys: String, CodingKey{
        case title = "original_title"
        case description = "overview"
        case rating = "vote_average"
        case imageLink = "poster_path"
        case releaseDate = "release_date"
    }
}
//making it an extension so it's more readable. We need this to be able to use .contains for the way im handling locally persistet favorites.
extension Movie: Equatable{
}

//so also, all of these things are one level down so we need a top level dictionary struct.
struct MovieTLD: Codable{
    let results: [Movie]
}
