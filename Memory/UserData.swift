//
//  UserData.swift
//  Memory
//
//  Created by Yuhyun Chung on 11/16/18.
//  Copyright © 2018 Yuhyun Chung. All rights reserved.
//

import Foundation

class UserData {
    
    //singleton.
    static let sharedInstance = UserData()
    
    //User's info
    private var firstName: String?
    private var lastName: String?
    
    // place Dictionary
    private var placesDictionary: [String:Place]
    
    init() {
        self.firstName = "Yuhyun"
        self.lastName = "Chung"
        
        placesDictionary = [String:Place]()
    }
    
    func addPlace(name: String, place: Place){
        placesDictionary[name] = place
    }
    
}
