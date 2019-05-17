//
//  MovieListTableViewController.swift
//  MovieSearch
//
//  Created by Haley Jones on 5/17/19.
//  Copyright © 2019 HaleyJones. All rights reserved.
//

import UIKit

class MovieListTableViewController: UITableViewController {

    
    //set up the ⚔️𝔖𝔬𝔲𝔯𝔠𝔢 𝔬𝔣 𝔗𝔯𝔲𝔱𝔥⚔️
    var movies: [Movie] = []{
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set a title card cuz why not
        let imageView = UIImageView(image: UIImage(named: "notflix"))
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //we want a custom cell or NOTHING(or a basic cell)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MovieTableViewCell else {return UITableViewCell()}
        //this should make it real simple to read
        cell.updateViews(withInfoFrom: movies[indexPath.row])
        MovieController.shared.fetchPosters(for: movies[indexPath.row]) { (image) in
            DispatchQueue.main.async {
                cell.moviePosterView.image = image
            }
        }
        return cell
    }
    
    // MARK: - Navigation
    //segue 🛴
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //make sure its the right segue
        if segue.identifier == "toMovieDetail"{
            //where we goin
            guard let destinVC = segue.destination as? MovieDetailViewController else {return}
            //who sent us
            guard let index = tableView.indexPathForSelectedRow else {return}
            //what r we sending
            let sendMovie = movies[index.row]
            //send it!
            destinVC.movie = sendMovie
        }
    }
}
//we need this to be able to use the search bar's delegate functions and those are nice to have when u wanna search
extension MovieListTableViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //first we make sure we can get text from the bar. also if it's empty just don't search i guess.
        guard let searchTerm = searchBar.text else {return}
        MovieController.shared.fetchMovies(searchTerm: searchTerm) { (movies) in
            self.movies = movies
        }
    }
}
