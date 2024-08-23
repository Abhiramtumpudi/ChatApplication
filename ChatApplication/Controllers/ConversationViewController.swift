//
//  ViewController.swift
//  ChatApplication
//
//  Created by Abhiram Tumpudi on 17/08/24.
//

import UIKit

class ConversationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        
        let isLoggedIn = UserDefaults.standard.bool(forKey: "Logged_In")

        if !isLoggedIn {
            
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
            
        }
        
    }

}

