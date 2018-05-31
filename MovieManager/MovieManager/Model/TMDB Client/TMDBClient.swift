//
//  TMDBClient.swift
//  MovieManager
//
//  Created by Bernadett Kiss on 5/30/18.
//  Copyright © 2018 Bernadett Kiss. All rights reserved.
//

import UIKit

class TMDBClient {
    
    static let instance = TMDBClient()
    var session = URLSession.shared
    var requestToken: String?
    var sessionID: String?
    var userID: Int?
    
    func authenticate(withViewController hostViewController: UIViewController, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?)  -> Void) {
        getRequestToken() { (success, requestToken, errorString) in
            if success {
                self.requestToken = requestToken
                self.loginWithToken(requestToken, hostViewController: hostViewController) { (success, errorString) in
                    if success {
                        self.getSessionID(requestToken) { (success, sessionID, errorString) in
                            if success {
                                self.sessionID = sessionID
                                self.getUserID() { (success, userID, errorString) in
                                    if success {
                                        if let userID = userID {
                                            self.userID = userID
                                        }
                                    }
                                    completionHandlerForAuth(success, errorString)
                                }
                            } else {
                                completionHandlerForAuth(success, errorString)
                            }
                        }
                    } else {
                        completionHandlerForAuth(success, errorString)
                    }
                }
            } else {
                completionHandlerForAuth(success, errorString)
            }
        }
    }
    
    
    func getRequestToken(_ completionHandlerForToken: @escaping (_ success: Bool, _ requestToken: String?, _ errorString: String?) -> Void) {
        let parameters = [String: AnyObject]()
        
        let _ = taskForGET(method: Methods.AuthenticationTokenNew, parameters: parameters) { (results, error) in
            if let error = error {
                print(error)
                completionHandlerForToken(false, nil, "Login Failed (Request Token).")
            } else {
                if let requestToken = results?[TMDBClient.JSONResponseKeys.RequestToken] as? String {
                    completionHandlerForToken(true, requestToken, nil)
                } else {
                    print("Could not find \(TMDBClient.JSONResponseKeys.RequestToken) in \(results!)")
                    completionHandlerForToken(false, nil, "Login Failed (Request Token).")
                }
            }
        }
    }
    
    func loginWithToken(_ requestToken: String?, hostViewController: UIViewController, completionHandlerForLogin: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        let authorizationURL = URL(string: "\(TMDBClient.Constants.AuthorizationURL)\(requestToken!)")
        let request = URLRequest(url: authorizationURL!)
        let webAuthViewController = hostViewController.storyboard!.instantiateViewController(withIdentifier: "TMDBAuthViewController") as! TMDBAuthViewController
        webAuthViewController.urlRequest = request
        webAuthViewController.requestToken = requestToken
        webAuthViewController.completionHandlerForView = completionHandlerForLogin
        
        let webAuthNavigationController = UINavigationController()
        webAuthNavigationController.pushViewController(webAuthViewController, animated: false)
        
        DispatchQueue.main.async {
            hostViewController.present(webAuthNavigationController, animated: true, completion: nil)
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }
    
    private func getSessionID(_ requestToken: String?, completionHandlerForSession: @escaping (_ success: Bool, _ sessionID: String?, _ errorString: String?) -> Void) {
        let parameters = [TMDBClient.ParameterKeys.RequestToken: requestToken!]
        
        let _ = taskForGET(method: Methods.AuthenticationSessionNew, parameters: parameters as [String: AnyObject]) { (results, error) in
            if let error = error {
                print(error)
                completionHandlerForSession(false, nil, "Login Failed (Session ID).")
            } else {
                if let sessionID = results?[TMDBClient.JSONResponseKeys.SessionID] as? String {
                    completionHandlerForSession(true, sessionID, nil)
                } else {
                    print("Could not find \(TMDBClient.JSONResponseKeys.SessionID) in \(results!)")
                    completionHandlerForSession(false, nil, "Login Failed (Session ID).")
                }
            }
        }
    }
    
    private func getUserID(_ completionHandlerForUserID: @escaping (_ success: Bool, _ userID: Int?, _ errorString: String?) -> Void) {
        let parameters = [TMDBClient.ParameterKeys.SessionID: TMDBClient.instance.sessionID!]
        
        let _ = taskForGET(method: Methods.Account, parameters: parameters as [String: AnyObject]) { (results, error) in
            if let error = error {
                print(error)
                completionHandlerForUserID(false, nil, "Login Failed (User ID).")
            } else {
                if let userID = results?[TMDBClient.JSONResponseKeys.UserID] as? Int {
                    completionHandlerForUserID(true, userID, nil)
                } else {
                    print("Could not find \(TMDBClient.JSONResponseKeys.UserID) in \(results!)")
                    completionHandlerForUserID(false, nil, "Login Failed (User ID).")
                }
            }
        }
    }
    
    func taskForGET(method: String, parameters: [String: AnyObject], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        var parametersWithApiKey = parameters
        parametersWithApiKey[ParameterKeys.ApiKey] = ParameterValues.ApiKey as AnyObject
        
        let request = URLRequest(url: tmdbURL(fromParameters: parametersWithApiKey, withPathExtension: method))
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }
        task.resume()
        return task
    }
    
    func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey: "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    func tmdbURL(fromParameters parameters: [String: AnyObject], withPathExtension pathExtension: String?) -> URL {
        var components = URLComponents()
        components.scheme = TMDBClient.Constants.ApiScheme
        components.host = TMDBClient.Constants.ApiHost
        components.path = TMDBClient.Constants.ApiPath + (pathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems?.append(queryItem)
        }
        return components.url!
    }
}
