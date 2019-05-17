//
//  MovieDetailViewController.swift
//  MovieSearch
//
//  Created by Haley Jones on 5/17/19.
//  Copyright © 2019 HaleyJones. All rights reserved.
//

import UIKit

//honestly my ui design on this view is pretty subpar but i wanted to do all the black diamonds and submit on time!
class MovieDetailViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var faveButton: UIButton!
    @IBOutlet weak var synopsisView: UITextView!
    @IBOutlet weak var ratingLabel: UILabel!
    
    //MARK: Landing pads
    var movie: Movie?
    var poster: UIImage?{
        didSet{
            //update the UI on the main thread whenever the image is ready.
            DispatchQueue.main.async {
                self.posterView.image = self.poster
            }
        }
    }
    
    //handle favoritism, will be updated to reflect the incoming movie when you segue here from the favorites table.
    var isFavorite = false{
        didSet{
            faveButton.setImage(UIImage(named: isFavorite ? "ICC_filledStar_2x": "ICC_emptyStar_2x"), for: .normal)
            //we save 1 writing of this function by saving up here. 🧠
            MovieController.shared.saveToPersistentStore()
        }
    }
    
    //on load, fetch the image.  Assign that image to the page's poster, which triggers its didset.
    //also update the labels.
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let movie = movie else{return}
        MovieController.shared.fetchPosters(for: movie) { (image) in
            self.poster = image
        }
        updateViews()
        //this will basically let the page know this movie is a favorite if it in the favorites array.
        isFavorite = MovieController.shared.favorites.contains(movie)
    }
    //put all the data where it needs to be.
    func updateViews(){
        guard let pageMovie = movie else {return}
        titleLabel.text = pageMovie.title
        yearLabel.text = pageMovie.releaseDate
        ratingLabel.text = "Rating: \(pageMovie.rating)"
        synopsisView.text = pageMovie.description
    }
    
    //MARK: Favorite Button
    @IBAction func faveButtonPressed(_ sender: UIButton) {
        guard let pageMovie = movie else {return}
        if isFavorite == true{
            //find this movie in the favorites array and take it out.
            guard let targetIndex = MovieController.shared.favorites.firstIndex(of: pageMovie) else {return}
            MovieController.shared.favorites.remove(at: targetIndex)
            //then set isFavorite to false.
            isFavorite = false
            //and return.
            return
        } else {
            //add this movie to the favorites array
            MovieController.shared.favorites.append(pageMovie)
            isFavorite = true
            return
        }
    }
}
