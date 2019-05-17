//
//  MovieTableViewCell.swift
//  MovieSearch
//
//  Created by Haley Jones on 5/17/19.
//  Copyright © 2019 HaleyJones. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    //MARK: Outlets
    @IBOutlet weak var moviePosterView: UIImageView!
    @IBOutlet weak var filmTitleLabel: UILabel!
    @IBOutlet weak var filmRatingLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    //update views cuz we will need that. I think this is a different way than we did it before?
    func updateViews(withInfoFrom movie: Movie){
        filmTitleLabel.text = movie.title
        filmRatingLabel.text = "Rating: \(movie.rating)"
        descriptionTextView.text = movie.description
    }
}
