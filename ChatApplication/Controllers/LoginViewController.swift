//
//  LoginViewController.swift
//  ChatApplication
//
//  Created by Abhiram Tumpudi on 17/08/24.
//

import UIKit

class LoginViewController: UIViewController {
    
   private let scrollView : UIScrollView = {
        let scrollView = UIScrollView()
       scrollView.clipsToBounds = true
       return scrollView
    }()
    
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
        field.placeholder = "Enter Email Address"
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
        field.placeholder = "Enter Password"
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
    }
    
      func alertUserLoginError() {
        let controller = UIAlertController(title: "oops", message: "Please Enter Information", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(controller, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
