//
//  MoviePickerViewController.swift
//  MovieManager
//
//  Created by Bernadett Kiss on 6/7/18.
//  Copyright © 2018 Bernadett Kiss. All rights reserved.
//

import UIKit

class MoviePickerViewController: MovieManagerViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var movieTableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    var movies = [TMDBMovie]()
    var searchTask: URLSessionDataTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTableView.dataSource = self
        movieTableView.delegate = self
        movieTableView.tableHeaderView = searchController.searchBar
        
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.dismiss(animated: false, completion: nil)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let task = searchTask {
            task.cancel()
        }
        
        if searchBarIsEmpty() {
            movies = [TMDBMovie]()
            movieTableView.reloadData()
        }
        
        let searchText = searchController.searchBar.text!
        searchTask = TMDBClient.instance.getMovies(forSearchString: searchText) { (movies, error) in
            self.searchTask = nil
            if let movies = movies {
                self.movies = movies
                DispatchQueue.main.async {
                    self.movieTableView.reloadData()
                }
            }
        }
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieSearchCell", for: indexPath) as UITableViewCell?
        let movie = movies[indexPath.row]
        if let releaseYear = movie.releaseYear {
            cell?.textLabel!.text = "\(movie.title) (\(releaseYear))"
        } else {
            cell?.textLabel!.text = "\(movie.title)"
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = storyboard!.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        controller.movie = movies[indexPath.row]
        navigationController!.pushViewController(controller, animated: true)
    }
}
