//
//  MovieManagerViewController.swift
//  MovieManager
//
//  Created by Bernadett Kiss on 6/7/18.
//  Copyright © 2018 Bernadett Kiss. All rights reserved.
//

import UIKit

class MovieManagerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        parent!.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
    }
    
    @objc func logout() {
        dismiss(animated: true, completion: nil)
    }
}
