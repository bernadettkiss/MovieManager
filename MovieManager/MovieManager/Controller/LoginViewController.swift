//
//  LoginViewController.swift
//  MovieManager
//
//  Created by Bernadett Kiss on 5/30/18.
//  Copyright © 2018 Bernadett Kiss. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: BorderedButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var session: URLSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        errorLabel.text = ""
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        TMDBClient.instance.authenticate(withViewController: self) { (success, errorString) in
            DispatchQueue.main.async {
                if success {
                    self.completeLogin()
                } else {
                    self.errorLabel.text = errorString
                }
            }
        }
    }
    
    private func completeLogin() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "ManagerNavigationController") as! UINavigationController
        present(controller, animated: true, completion: nil)
    }
}
