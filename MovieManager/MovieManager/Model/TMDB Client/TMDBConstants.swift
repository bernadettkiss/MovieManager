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
        static let AuthenticationTokenNew = "/authentication/token/new"
        static let AuthenticationSessionNew = "/authentication/session/new"
    }
    
    struct ParameterKeys {
        static let ApiKey = "api_key"
        static let RequestToken = "request_token"
        static let SessionID = "session_id"
    }
    
    struct ParameterValues{
        static let ApiKey = myTMDBApiKey
    }
    
    struct JSONResponseKeys {
        static let RequestToken = "request_token"
        static let SessionID = "session_id"
        static let UserID = "id"
    }
}
