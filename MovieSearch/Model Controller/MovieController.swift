//
//  MovieController.swift
//  MovieSearch
//
//  Created by Haley Jones on 5/17/19.
//  Copyright © 2019 HaleyJones. All rights reserved.
//
//gonna need UIKit when i go to do images
import UIKit

//this one is a class cuz we're actually gonna initialize it
class MovieController{
    
    //singleton? It' either this or instantiate it on the viewcontroller and i feel like this is the way
    static var shared = MovieController()
    private init(){}
    //and this is here so i have a shorthand for my api key. Don't worry, it's private. Extremely secure.
    private let apiKey = "d7b164c4ba538d2cb40823a7a1472e3b"
    //MARK: - CRUD
    //complete with an array of movies, let that completion run asynchronously because network calls take time.
    func fetchMovies(searchTerm: String, completion: @escaping ([Movie]) -> Void){
        //firstly we're gonna make ourelves a URL. Because we're ONLY fetchin movies, i feel pretty ok making it pretty specific.
        let baseURL = "https://api.themoviedb.org/3/search/movie"
        //now we're gonna make our query items. First comes the API key and THEN comes search terms. Thats just how moviedb works.
        let apiQuery = URLQueryItem(name: "api_key", value: apiKey)
        let searchQuery = URLQueryItem(name: "query", value: searchTerm)
        //now we disassemble the url, add our query items to it, then stitch it back together
        guard var components = URLComponents(string: baseURL) else{
            print("There was an issue creating URL components from the base url.")
            completion([])
            return
        }
        components.queryItems = [apiQuery, searchQuery]
        guard let finalURL = components.url else {
            print("Could not assemble a URL from components.")
            completion([])
            return
            //im being super explicit with these errors just in case even if it makes my code blocks heftier
        }
        print(finalURL)
        //we have a URL now so let's send it out into the wild to hunt for movies
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            //check for errors
            if let anError = error{
                print("there was an error fetching the data. \(anError.localizedDescription)")
                completion([])
                return
            }
            //now we know we have data so lets unwrap it
            guard let unwrappedData = data else {completion([]); return}
            //and do-try-catch the decode
            do{
                let results = try JSONDecoder().decode(MovieTLD.self, from: unwrappedData)
                let movies = results.results
                //pass the movies into the completion handler
                completion(movies)
                //i have typo'd "mobies" like 28 times so far
            }catch{
                print("there was an error decoding the data. \(error.localizedDescription)")
            }
        }.resume()
    }
    //It workssssss, onto images. Making image an optional here just in case something has no poster?
    func fetchPosters(for movie: Movie, completion: @escaping (UIImage?) -> Void){
        //setting up the baseURL to just grab the 500 size for now
        guard let baseURL = URL(string: "https://image.tmdb.org/t/p/w500") else {completion (nil); return}
        //the api hands back a path to an image for movies so we can just use that here.
        guard let imagePath = movie.imageLink else {completion(nil); return}
        let finalURL = baseURL.appendingPathComponent(imagePath)
        print("image URL: \(finalURL)")
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let anError = error{
                print("There was an error fetching the image. \(anError.localizedDescription)")
                completion(nil)
                return
            }
            //unwrap data
            guard let unwrappedData = data else {completion(nil); return}
            let image = UIImage(data: unwrappedData)
            completion(image)
        }.resume()
    }
    
}
