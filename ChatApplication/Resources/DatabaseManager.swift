//
//  DatabaseManaager.swift
//  ChatApplication
//
//  Created by Abhiram Tumpudi on 28/08/24.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {

    static let shared = DatabaseManager()
    
    let databse = Database.database().reference()
    
    static func safeEmail(emailAddress : String)-> String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
    
}

extension DatabaseManager {
    // MARK: - Check if user exists in database 

    func userExists(with email : String , completion : @escaping((Bool)-> Void)) {
        
            var safeEmail = email.replacingOccurrences(of: ".", with: "-")
            safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
    
        databse.child(safeEmail).observeSingleEvent(of: .value , with : { snapshot in
            
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
            completion(true)
        })
        
    }
    // MARK: - Insert user to database

    func insertUser(with user : ChatAppUser , completion : @escaping (Bool)-> Void) {
        databse.child(user.safeEmail).setValue([
            "firstName" : user.fistName,
            "LastName"  : user.lastName,
        ] , withCompletionBlock: { error , _ in
            guard error == nil else {
                print("failed to write to database")
                completion(false)
                return
            }
            
            self.databse.child("users").observeSingleEvent(of: .value) { shapshot in
                if var userCollection = shapshot.value as? [[String : String]] {
                    // append to dictionary
                    let newElement = [
                        [
                            "name"  : user.fistName + " " + user.lastName,
                            "email" : user.safeEmail
                        ]
                    ]
                    userCollection.append(contentsOf: newElement)
                    self.databse.child("users").setValue(userCollection) { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    }
                } else {
                    // create the array
                    let newCollection : [[String: String]] = [
                        [
                            "name"  : user.fistName + " " + user.lastName,
                            "email" : user.safeEmail
                        ]
                    ]
                    self.databse.child("users").setValue(newCollection) { error, _ in
                        guard error == nil else {
                            return
                        }
                        completion(true)
                    }
                }
            }
            
            completion(true)
        })
    }
    
    
    // MARK: - GetAllUsers
    
    func getAllUsers(completion : @escaping(Result<[[String : String]],Error>)-> Void) {
        
        databse.child("users").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [[String: String]] else {
                completion(.failure(DataBaseErrorTypes.failedTofetchUsers))
                return
            }
            completion(.success(value))
        })
        
    }
    
    enum DataBaseErrorTypes : Error {
        case failedTofetchUsers
    }

}

extension DatabaseManager {
    
}
