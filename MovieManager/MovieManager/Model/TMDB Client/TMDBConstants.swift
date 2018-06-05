//
//  TMDBConstants.swift
//  MovieManager
//
//  Created by Bernadett Kiss on 5/30/18.
//  Copyright © 2018 Bernadett Kiss. All rights reserved.
//

import Foundation

extension TMDBClient {
    
    struct Constants {
        static let ApiScheme = "https"
        static let ApiHost = "api.themoviedb.org"
        static let ApiPath = "/3"
        static let AuthorizationURL = "https://www.themoviedb.org/authenticate/"
        static let AccountURL = "https://www.themoviedb.org/account/"
    }
    
    struct Methods {
        static let Account = "/account"
        static let AccountIDFavoriteMovies = "/account/{id}/favorite/movies"
        static let AccountIDFavorite = "/account/{id}/favorite"
        static let AccountIDWatchlistMovies = "/account/{id}/watchlist/movies"
        static let AccountIDWatchlist = "/account/{id}/watchlist"
        static let AuthenticationTokenNew = "/authentication/token/new"
        static let AuthenticationSessionNew = "/authentication/session/new"
    }
    
    struct URLKeys {
        static let UserID = "id"
    }
    
    struct ParameterKeys {
        static let ApiKey = "api_key"
        static let RequestToken = "request_token"
        static let SessionID = "session_id"
    }
    
    struct ParameterValues{
        static let ApiKey = myTMDBApiKey
    }
    
    struct JSONBodyKeys {
        static let MediaType = "media_type"
        static let MediaID = "media_id"
        static let Favorite = "favorite"
        static let Watchlist = "watchlist"
    }
    
    struct JSONResponseKeys {
        static let RequestToken = "request_token"
        static let SessionID = "session_id"
        static let UserID = "id"
        static let MovieID = "id"
        static let MovieTitle = "title"
        static let MoviePosterPath = "poster_path"
        static let MovieReleaseDate = "release_date"
        static let MovieReleaseYear = "release_year"
        static let MovieResults = "results"
        static let StatusMessage = "status_message"
        static let StatusCode = "status_code"
    }
    
    struct PosterSizes {
        static let RowPoster = TMDBClient.Config.posterSizes[2]
        static let DetailPoster = TMDBClient.Config.posterSizes[4]
    }
    
    struct Config {
        static let baseImageURLString = "http://image.tmdb.org/t/p/"
        static let secureBaseImageURLString =  "https://image.tmdb.org/t/p/"
        static let posterSizes = ["w92", "w154", "w185", "w342", "w500", "w780", "original"]
        static let profileSizes = ["w45", "w185", "h632", "original"]
    }
}
