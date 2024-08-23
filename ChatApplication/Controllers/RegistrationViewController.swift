//
//  RegistrationViewController.swift
//  ChatApplication
//
//  Created by Abhiram Tumpudi on 17/08/24.
//

import UIKit

class RegistrationViewController: UIViewController, UINavigationControllerDelegate {

    private let scrollView : UIScrollView = {
         let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
     }()
     
     private let imageView : UIImageView = {
         let imageView = UIImageView()
         imageView.image = UIImage(systemName: "person")
         imageView.tintColor = .gray
         imageView.contentMode = .scaleAspectFit
         imageView.layer.masksToBounds = true
         imageView.layer.borderWidth = 2
         imageView.layer.borderColor = UIColor.lightGray.cgColor
         return imageView
     }()
     
     private let firstNameField : UITextField = {
         let field = UITextField()
         field.autocapitalizationType = .none
         field.autocorrectionType = .no
         field.returnKeyType = .continue
         field.layer.cornerRadius = 12
         field.layer.borderWidth = 1
         field.layer.borderColor = UIColor.lightGray.cgColor
         field.placeholder = "Enter FirstName"
         field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
         field.backgroundColor = .white
         return field
     }()
    
    private let lastNameField : UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Enter LastName"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.backgroundColor = .white
        return field
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
     
     private let registerButton : UIButton = {
         let button = UIButton()
         button.setTitle("Create Account", for: .normal)
         button.backgroundColor = .systemGreen
         button.setTitleColor(.white, for: .normal)
         button.layer.cornerRadius = 12
         button.layer.masksToBounds = true
         button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
         button.addTarget(self, action: #selector(didTapregisterButton), for: .touchUpInside)
         return button
     }()
     
     
     
     @objc func didTapregisterButton() {
         firstNameField.becomeFirstResponder()
         lastNameField.becomeFirstResponder()
         emailTextField.becomeFirstResponder()
         passwordTextField.becomeFirstResponder()
         guard let email = emailTextField.text,
               let firstName = firstNameField.text,
               let lastName = lastNameField.text,
               let password = passwordTextField.text,
                !firstName.isEmpty,
                !lastName.isEmpty,
                !email.isEmpty ,
                !password.isEmpty,
                 password.count >= 6 else {
                alertUserLoginError()
                return
         }
     }
     
       func alertUserLoginError() {
         let controller = UIAlertController(title: "OOPS",
                                            message: "Please Enter Information to fill up for new Account",
                                            preferredStyle: .alert)
         controller.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
         present(controller, animated: true)
     }

     override func viewDidLoad() {
         super.viewDidLoad()

         view.backgroundColor = .white
         title = "Create Account"
         navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
                                                             style: .done,
                                                             target: self,
                                                             action: #selector(didTapRegister))
        
         emailTextField.delegate = self
         passwordTextField.delegate = self
         
         // add subviews
         view.addSubview(scrollView)
         scrollView.addSubview(imageView)
         scrollView.addSubview(firstNameField)
         scrollView.addSubview(lastNameField)
         scrollView.addSubview(emailTextField)
         scrollView.addSubview(passwordTextField)
         scrollView.addSubview(registerButton)
         
         let gesture = UITapGestureRecognizer(target: self, action: #selector(didTaptoChangeProfilePic))
         imageView.addGestureRecognizer(gesture)
         imageView.isUserInteractionEnabled = true
         scrollView.isUserInteractionEnabled = true
         
     }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.rightBarButtonItem?.isHidden = true
    }
    
    
    @objc func didTaptoChangeProfilePic() {
        presentSheets()
    }
     
     override func viewDidLayoutSubviews() {
         super.viewDidLayoutSubviews()
         
         scrollView.frame = view.bounds
         let size = scrollView.width / 3
         imageView.frame = CGRect(x: (scrollView.width-size)/2,
                                       y: 20,
                                       width: size,
                                       height: size)
         imageView.layer.cornerRadius = imageView.width / 2.0
         firstNameField.frame = CGRect(x: 30,
                                       y: imageView.bottom+10,
                                       width: scrollView.width-60,
                                       height: 52)
         lastNameField.frame = CGRect(x: 30,
                                       y: firstNameField.bottom+10,
                                       width: scrollView.width-60,
                                       height: 52)
         emailTextField.frame = CGRect(x: 30,
                                       y: lastNameField.bottom+10,
                                       width: scrollView.width-60,
                                       height: 52)
         passwordTextField.frame = CGRect(x: 30,
                                       y: emailTextField.bottom+10,
                                       width: scrollView.width-60,
                                       height: 52)
         registerButton.frame = CGRect(x: 30,
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


 extension RegistrationViewController : UITextFieldDelegate {
     
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         if textField == firstNameField {
             lastNameField.becomeFirstResponder()
         } else if textField == lastNameField {
             emailTextField.becomeFirstResponder()
         } else if textField == emailTextField {
             passwordTextField.becomeFirstResponder()
         }else if textField == emailTextField {
             didTapregisterButton()
         }
         return true
     }
     
 }


extension RegistrationViewController : UIImagePickerControllerDelegate {
    
    func presentSheets() {
        let actionSheet = UIAlertController(title: "Take Picture",
                                            message: "How would you like to capture picture",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                                         style: .cancel,
                                                         handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo",
                                                         style: .default,
                                            handler: { [weak self] _ in
            
                          self?.selectPhoto()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo",
                                                         style: .default,
                                            handler: { [weak self] _ in
            
            self?.selectPhotoFromLibrary()
            
        }))
        present(actionSheet, animated: true)
    }
    
    func selectPhoto() {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.sourceType = .camera
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func selectPhotoFromLibrary() {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
        imageView.image = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
