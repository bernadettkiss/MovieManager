//
//  WatchlistViewController.swift
//  MovieManager
//
//  Created by Bernadett Kiss on 6/4/18.
//  Copyright © 2018 Bernadett Kiss. All rights reserved.
//

import UIKit

class WatchlistViewController: MovieManagerViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var watchlistTableView: UITableView!
    
    var movies = [TMDBMovie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        watchlistTableView.dataSource = self
        watchlistTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        TMDBClient.instance.getWatchlistMovies { (movies, error) in
            if let movies = movies {
                self.movies = movies
                DispatchQueue.main.async {
                    self.watchlistTableView.reloadData()
                }
            } else {
                print(error ?? "error")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WatchlistTableViewCell", for: indexPath) as UITableViewCell?
        let movie = movies[indexPath.row]
        
        cell?.textLabel?.text = movie.title
        cell?.imageView?.image = UIImage(named: "Film")
        cell?.imageView!.contentMode = UIViewContentMode.scaleAspectFit
        
        if let posterPath = movie.posterPath {
            let _ = TMDBClient.instance.taskForGETImage(TMDBClient.PosterSizes.RowPoster, filePath: posterPath, completionHandlerForImage: { (imageData, error) in
                if let image = UIImage(data: imageData!) {
                    DispatchQueue.main.async {
                        cell?.imageView!.image = image
                    }
                } else {
                    print(error ?? "error")
                }
            })
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = storyboard!.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        controller.movie = movies[indexPath.row]
        navigationController!.pushViewController(controller, animated: true)
    }
}
