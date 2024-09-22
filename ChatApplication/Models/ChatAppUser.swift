//
//  ChatAppUser.swift
//  ChatApplication
//
//  Created by Abhiram Tumpudi on 29/08/24.
//

import Foundation


struct ChatAppUser {
    let fistName : String
    let lastName : String
    let emailAddress : String
//    let profileImageUrl : String
    
    var safeEmail : String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
    // profilePictureUrl
    
    var profilePictureUrl : String {
        //
        return "\(safeEmail)_profile_picture.png"
    }
}
