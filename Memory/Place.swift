//
//  Place.swift
//  Memory
//
//  Created by Yuhyun Chung on 11/16/18.
//  Copyright © 2018 Yuhyun Chung. All rights reserved.
//

import Foundation
import MapKit

class Place{
    
    private var name: String?
    private var subtitle: String?
    private var latitude: String?
    private var longitude: String?
    private var songs: Array<Song> = Array();
    
    init(name: String, subtitle: String, latitude: String, longitude: String){
        self.name = name
        self.subtitle = subtitle
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func addSong(song: Song){
        songs.append(song)
    }
    
    func removeSong(song: Song){
       
        for i in 0..<songs.count{
            
            // if we find the target song.
            if(songs[i].getTitle() == song.getTitle()){
                songs.remove(at: i)
            }
            
        }
        
    }
    
    
    
}
