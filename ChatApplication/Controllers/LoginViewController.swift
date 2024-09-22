//
//  LoginViewController.swift
//  ChatApplication
//
//  Created by Abhiram Tumpudi on 17/08/24.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn
import JGProgressHUD

class LoginViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private let scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let facebookLoginButton : FBLoginButton = {
        let button = FBLoginButton()
        button.permissions = ["email", "public_profile"]
        return button
    }()
    
    private let googleSignInbutton = GIDSignInButton()
    
    private let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .center
        return imageView
    }()
    
    private let emailTextField : UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = " Enter Email Address "
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.backgroundColor = .white
        return field
    }()
    
    private let passwordTextField : UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = " Enter Password "
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.backgroundColor = .white
        field.isSecureTextEntry = true
        return field
    }()
    
    private let loginButton : UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.addTarget(self, action: #selector(didTaploginButton), for: .touchUpInside)
        return button
    }()
    
    
    
    @objc func didTaploginButton() {
        
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        guard let email = emailTextField.text , let password = passwordTextField.text , !email.isEmpty , !password.isEmpty,
              password.count > 6 else {
            alertUserLoginError()
            return
        }
        
       
        spinner.show(in: view)
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) {[weak self] authResult , error in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }
            guard let results = authResult , error == nil else {
                print("SignIn Issue")
                return
            }
            let user = results.user
            print("Logged In User \(user)")
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        }
        
        
    }
    
    func alertUserLoginError() {
        let controller = UIAlertController(title: "oops", message: "Please Enter Information", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(controller, animated: true)
    }
    
    private var loginObserver : NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginObserver =  NotificationCenter.default.addObserver(forName: .didloginNotification,
                                                                object: nil,
                                                                queue: .main) {  [weak self] _ in
            
            guard let strongSelf = self else {return}
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        }
        
        GIDSignIn.sharedInstance().presentingViewController = self
        view.backgroundColor = .white
        title = "Log In"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapRegister))
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        // add subviews
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(passwordTextField)
        scrollView.addSubview(loginButton)
        scrollView.addSubview(facebookLoginButton)
        scrollView.addSubview(googleSignInbutton)
        
    }
    
    deinit {
        if let observer = loginObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = scrollView.width / 3
        imageView.frame = CGRect(x: (scrollView.width-size)/2,
                                 y: 20,
                                 width: size,
                                 height: size)
        emailTextField.frame = CGRect(x: 30,
                                      y: imageView.bottom+10,
                                      width: scrollView.width-60,
                                      height: 52)
        passwordTextField.frame = CGRect(x: 30,
                                         y: emailTextField.bottom+10,
                                         width: scrollView.width-60,
                                         height: 52)
        loginButton.frame = CGRect(x: 30,
                                   y: passwordTextField.bottom+10,
                                   width: scrollView.width-60,
                                   height: 52)
        facebookLoginButton.frame = CGRect(x: 30,
                                           y: loginButton.bottom+10,
                                           width: scrollView.width-60,
                                           height: 52)
        googleSignInbutton.frame = CGRect(x: 30,
                                          y: facebookLoginButton.bottom+20,
                                          width: scrollView.width-60,
                                          height: 52)
        
        facebookLoginButton.frame.origin.y = loginButton.bottom + 10
        facebookLoginButton.layer.cornerRadius = 12
        facebookLoginButton.layer.masksToBounds = true
        facebookLoginButton.delegate = self
        
        googleSignInbutton.layer.cornerRadius = 12
        googleSignInbutton.layer.masksToBounds = true
        
    }
    
    
    @objc func didTapRegister() {
        let vc = RegistrationViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}


extension LoginViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            didTaploginButton()
        }
        return true
    }
    
}


extension LoginViewController : LoginButtonDelegate {
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        // no result
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: (any Error)?) {
        
        guard let token = result?.token?.tokenString else {
            print("User failed to login with facebook")
            return
        }
        
        let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                         parameters: ["fields" : "email , first_name , last_name , picture.type(large)"],
                                                         tokenString: token,
                                                         version: nil,
                                                         httpMethod: .get)
        
        facebookRequest.start { _, result, error in
            guard let result = result as? [String : Any] , error == nil else {
                print("failed to make facebook graph request")
                return
            }
            
            print(result)
            guard let firstName =  result["first_name"] as? String ,
                  let lastName =  result["last_name"] as? String ,
                  let email = result["email"] as? String,
                  let picture = result["picture"] as? [String : Any],
                  let data = picture["data"] as? [String : Any] ,
                  let pictureUrl = data["url"] as? String else {
                print("Unable to get user details from facebook login")
                      return
            }
            
            DatabaseManager.shared.userExists(with: email) { exists in
                if !exists {
                    let ChatUser = ChatAppUser(fistName: firstName,
                                               lastName: lastName,
                                               emailAddress: email)
                    DatabaseManager.shared.insertUser(with: ChatUser) { success in
                        guard let url = URL(string: pictureUrl) else {
                            return
                        }
                        print("Downloading data from facebook image")
                        URLSession.shared.dataTask(with: url) { data , _ , error in
                            guard let data = data else {
                                print("failed to get data from facebook")
                                return
                            }
                            let fileName = ChatUser.profilePictureUrl
                            StorageManager.shared.uploadProfilePicture(with: data , fileName: fileName , completion: { results in
                                switch results {
                                case .success(let downLoadUrl) :
                                    UserDefaults.standard.set(downLoadUrl, forKey: "profile_Picture_url")
                                    print(downLoadUrl)
                                case .failure(let error) :
                                    print("Storage Manager error : \(error)")
                                }
                            })
                        }.resume()
                    }
                }
            }
            
            let credentails = FacebookAuthProvider.credential(withAccessToken: token)
        
            FirebaseAuth.Auth.auth().signIn(with: credentails, completion: {[weak self] authResults, error in
                
                guard let strongSelf = self else {
                    return
                }
                guard authResults != nil , error == nil else {
                    if let error = error {
                        print("facebook credentials login failed, MFA may be needed - \(error) ")
                    }
                    return
                }
                print("Successfully Logged in")
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            })
        }
        
    }
    
}
