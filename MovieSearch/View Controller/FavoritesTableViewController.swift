//
//  FavoritesTableViewController.swift
//  MovieSearch
//
//  Created by Haley Jones on 5/17/19.
//  Copyright © 2019 HaleyJones. All rights reserved.
//

import UIKit
//i wanted to learn to use a tab bar for this so bad but apparently i cant add a tab bar to a table view controller and its WAY too late to go back and use a viewcontroller with a table in it instead. Alas!
class FavoritesTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //consistency with the header.
        let imageView = UIImageView(image: UIImage(named: "notflix"))
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MovieController.shared.favorites.count
    }
    //in case the user un-faves a movie while in the detail view
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //this is gonna be a lot like our main tableview but using the favorites array instead
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MovieTableViewCell else {return UITableViewCell()}
        cell.updateViews(withInfoFrom: MovieController.shared.favorites[indexPath.row])
        MovieController.shared.fetchPosters(for: MovieController.shared.favorites[indexPath.row]) { (image) in
            DispatchQueue.main.async {
                cell.moviePosterView.image = image
            }
        }
        return cell
    }
    
    
    // let them remove favorites by deleting a row, too.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // delete the movie from the favorites array
            let targetMovie = MovieController.shared.favorites[indexPath.row]
            guard let targetIndex = MovieController.shared.favorites.firstIndex(of: targetMovie) else {return}
            MovieController.shared.favorites.remove(at: targetIndex)
            tableView.deleteRows(at: [indexPath], with: .fade)
            //save. and reload the tableview.
            MovieController.shared.saveToPersistentStore()
            tableView.reloadData()
        }
    }
    
    // MARK: - Navigation
    //a very similar segue to the one from the search view.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailFromFave"{
            guard let destinVC = segue.destination as? MovieDetailViewController else {return}
            guard let targetIndex = tableView.indexPathForSelectedRow else {return} //honestly yeah if this segue goes off with no selected row, dip
            destinVC.movie = MovieController.shared.favorites[targetIndex.row]
        }
    }
}
