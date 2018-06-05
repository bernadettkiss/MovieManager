//
//  MovieDetailViewController.swift
//  MovieManager
//
//  Created by Bernadett Kiss on 6/4/18.
//  Copyright © 2018 Bernadett Kiss. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var favoriteBarButton: UIBarButtonItem!
    @IBOutlet weak var watchlistBarButton: UIBarButtonItem!
    
    var movie: TMDBMovie?
    var isFavorite = false
    var isWatchlist = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.navigationBar.isTranslucent = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.alpha = 1.0
        activityIndicator.startAnimating()
        
        if let movie = movie {
            if let releaseYear = movie.releaseYear {
                navigationItem.title = "\(movie.title) (\(releaseYear))"
            } else {
                navigationItem.title = "\(movie.title)"
            }
            
            TMDBClient.instance.getFavoriteMovies { (movies, error) in
                if let movies = movies {
                    for movie in movies {
                        if movie == self.movie! {
                            self.isFavorite = true
                        }
                    }
                    DispatchQueue.main.async {
                        if self.isFavorite {
                            self.favoriteBarButton.tintColor = .red
                        } else {
                            self.favoriteBarButton.tintColor = nil
                        }
                    }
                } else {
                    print(error ?? "error")
                }
            }
            
            TMDBClient.instance.getWatchlistMovies { (movies, error) in
                if let movies = movies {
                    for movie in movies {
                        if movie == self.movie! {
                            self.isWatchlist = true
                        }
                    }
                    DispatchQueue.main.async {
                        if self.isWatchlist {
                            self.watchlistBarButton.tintColor = .red
                        } else {
                            self.watchlistBarButton.tintColor = nil
                        }
                    }
                } else {
                    print(error ?? "error")
                }
            }
            
            posterImageView.image = UIImage(named: "MissingPoster")
            
            if let posterPath = movie.posterPath {
                let _ = TMDBClient.instance.taskForGETImage(TMDBClient.PosterSizes.DetailPoster, filePath: posterPath, completionHandlerForImage: { (imageData, error) in
                    if let image = UIImage(data: imageData!) {
                        DispatchQueue.main.async {
                            self.activityIndicator.alpha = 0.0
                            self.activityIndicator.stopAnimating()
                            self.posterImageView.image = image
                        }
                    }
                })
            } else {
                activityIndicator.alpha = 0.0
                activityIndicator.stopAnimating()
            }
            
        }
    }
    
    @IBAction func toggleFavorite(_ sender: UIBarButtonItem) {
        let shouldFavorite = !isFavorite
        
        TMDBClient.instance.postToFavorites(movie!, favorite: shouldFavorite) { (statusCode, error) in
            if let error = error {
                print(error)
            } else {
                if statusCode == 1 || statusCode == 12 || statusCode == 13 {
                    self.isFavorite = shouldFavorite
                    DispatchQueue.main.async {
                        self.favoriteBarButton.tintColor = (shouldFavorite) ? .red : nil
                    }
                } else {
                    print("Unexpected status code \(statusCode!)")
                }
            }
        }
    }
    
    @IBAction func toggleWatchlist(_ sender: UIBarButtonItem) {
        let shouldWatchlist = !isWatchlist
        
        TMDBClient.instance.postToWatchlist(movie!, watchlist: shouldWatchlist) { (statusCode, error) in
            if let error = error {
                print(error)
            } else {
                if statusCode == 1 || statusCode == 12 || statusCode == 13 {
                    self.isWatchlist = shouldWatchlist
                    DispatchQueue.main.async {
                        self.watchlistBarButton.tintColor = (shouldWatchlist) ? .red : nil
                    }
                } else {
                    print("Unexpected status code \(statusCode!)")
                }
            }
        }
    }
}
