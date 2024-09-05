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
    
   
}

extension DatabaseManager {
    
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

    func insertUser(with User : ChatAppUser) {
        databse.child(User.safeEmail).setValue([
            "firstName" : User.fistName,
            "LastName"  : User.lastName,
        ])
    }
    
}
