//
//  TMDBMovie.swift
//  MovieManager
//
//  Created by Bernadett Kiss on 5/31/18.
//  Copyright © 2018 Bernadett Kiss. All rights reserved.
//

import Foundation

struct TMDBMovie: Equatable {
    
    let title: String
    let id: Int
    let posterPath: String?
    let releaseYear: String?
    
    init(dictionary: [String: AnyObject]) {
        title = dictionary[TMDBClient.JSONResponseKeys.MovieTitle] as! String
        id = dictionary[TMDBClient.JSONResponseKeys.MovieID] as! Int
        posterPath = dictionary[TMDBClient.JSONResponseKeys.MoviePosterPath] as? String
        if let releaseDateString = dictionary[TMDBClient.JSONResponseKeys.MovieReleaseDate] as? String, releaseDateString.isEmpty == false {
            releaseYear = String(releaseDateString[..<releaseDateString.index(releaseDateString.startIndex, offsetBy: 4)])
        } else {
            releaseYear = ""
        }
    }
    
    static func moviesFromResults(_ results: [[String: AnyObject]]) -> [TMDBMovie] {
        var movies = [TMDBMovie]()
        for result in results {
            movies.append(TMDBMovie(dictionary: result))
        }
        return movies
    }
    
    static func ==(lhs: TMDBMovie, rhs: TMDBMovie) -> Bool {
        return lhs.id == rhs.id
    }
}
