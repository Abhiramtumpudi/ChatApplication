//
//  ProfileViewController.swift
//  ChatApplication
//
//  Created by Abhiram Tumpudi on 17/08/24.
//

import UIKit
import Firebase
import FBSDKLoginKit
import FirebaseAuth
import GoogleSignIn

class ProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let logout = ["Logout"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

extension ProfileViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logout.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = logout[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .red
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let actionSheet = UIAlertController(title: "Logout",
                                            message: "are you sure want to logout",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            
            // MARK: - Signout Facebook
        
            FBSDKLoginKit.LoginManager().logOut()
            
            // MARK: - Signout GoogleSignIn
            GIDSignIn.sharedInstance().signOut()
            
            do {
                try  FirebaseAuth.Auth.auth().signOut()
                
                let vc = LoginViewController()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                strongSelf.present(nav, animated: true)
                
            } catch {
                print("Failed to logout")
            }
            
        }))
        present(actionSheet, animated: true)
    }
}
