//
//  Song.swift
//  Memory
//
//  Created by Yuhyun Chung on 12/3/18.
//  Copyright © 2018 Yuhyun Chung. All rights reserved.
//

import Foundation


class Song{
    
    private var title: String?
    private var artist: String?
    
    init(title: String, artist: String){
        self.title = title
        self.artist = artist
    }
    
    func getTitle() -> String{
        return self.title!
    }
    
    func getArtist() -> String{
        return self.artist!
    }
    
}
