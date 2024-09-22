
// AppDelegate.swift
import UIKit
import Firebase
import FacebookCore
import GoogleSignIn
import FirebaseAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , GIDSignInDelegate   {
    
    
    func application(
        _ application: UIApplication,didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            
            FirebaseApp.configure()
            ApplicationDelegate.shared.application(application,didFinishLaunchingWithOptions: launchOptions)
            
            GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
            GIDSignIn.sharedInstance().delegate = self
            
             return true
        }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: (any Error)!)  {
        
          guard  error == nil else {
            if let error = error {
                print("Failed Error Sign in google user \(error)")
            }
            return
        }
        
        print("Did sign with Google user :\(String(describing: user))")
        
          guard let email = user.profile.email ,
                let firstName = user.profile.givenName ,
                let lastName = user.profile.familyName else {
              return
          }
        
        DatabaseManager.shared.userExists(with: email) { exists in
            if !exists {
                // inserts to database
                let chatUser = ChatAppUser(fistName: firstName,
                                           lastName: lastName,
                                           emailAddress: email)
                DatabaseManager.shared.insertUser(with: chatUser , completion: { success in
                    if success {
                        // upload picture
                        
                        guard let url = user.profile.imageURL(withDimension: 200) else { return }
                        URLSession.shared.dataTask(with: url, completionHandler: { data , _ , _ in
                            guard let data = data else {return}
                            let fileName = chatUser.profilePictureUrl
                            StorageManager.shared.uploadProfilePicture(with: data , fileName: fileName , completion: { results in
                                switch results {
                                case .success(let downLoadUrl) :
                                    UserDefaults.standard.set(downLoadUrl, forKey: "profile_Picture_url")
                                    print(downLoadUrl)
                                case .failure(let error) :
                                    print("Storage Manager error : \(error)")
                                }
                            })
                        }).resume()
                        
                    }
                })
            }
        }
        
        guard let authentication = user.authentication else { return }
        let credentials = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                        accessToken: authentication.accessToken)
        
        FirebaseAuth.Auth.auth().signIn(with: credentials) { authResults, error in
            guard authResults != nil , error == nil else {
                print("failed to login with google credentails")
                return
            }
            print("Succesfully signed with google creds.")
            NotificationCenter.default.post(name: .didloginNotification, object: nil)
        }
        
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: (any Error)!) {
        
    }
    
}
