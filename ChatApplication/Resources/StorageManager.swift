//
//  StorageManager.swift
//  ChatApplication
//
//  Created by Abhiram Tumpudi on 19/09/24.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    
    static let shared = StorageManager()
    
    private let storage = Storage.storage().reference()
    
    public typealias UploadPictureCompletion = (Result<String, Error>)-> Void
    
    public func uploadProfilePicture(with data : Data ,
                                     fileName : String ,
                                     completion: @escaping UploadPictureCompletion ) {
        
        storage.child("images\(fileName)").putData(data, metadata: nil , completion: { metaData , error in
            guard error == nil else {
                print("failed to upload a firebase to  picture")
                completion(.failure(StoargeError.failedToUpload))
                return
            }
            self.storage.child("images\(fileName)").downloadURL(completion: { url , error in
                guard let url = url else {
                    print("failed to upload a download to url")
                    completion(.failure(StoargeError.failedToLoadurl))
                    return
                }
                
                let Urlstring = url.absoluteString
                print("Please downloaded url :\(Urlstring)")
                completion(.success(Urlstring))
            })
        })
        
    }
    
    public enum StoargeError : Error {
        case failedToUpload
        case failedToLoadurl
    }
}
