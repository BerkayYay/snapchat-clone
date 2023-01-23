//
//  UserSingleton.swift
//  SnapchatClone
//
//  Created by Berkay YAY on 24.12.2022.
//

import Foundation

class UserSingleton {
    
    
    static let sharedUserInfo = UserSingleton()
    
    var email = ""
    var username = ""
    
    private init(){
        
    }
}
