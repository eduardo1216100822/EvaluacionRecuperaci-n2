//
//  Mp3ListModel.swift
//  MyStoreMusic
//
//  Created by Jose Carlos Rodriguez on 5/1/19.
//  Copyright © 2019 Jose Carlos Rodriguez. All rights reserved.
//

class Mp3ListModel{
    var id: String?
    var song: String?
    var artist: String?
    var album: String?
    var year: String?
    var rating: String?
    
    init(id: String?, song: String?, artist: String?, album: String?, year: String?, rating: String?) {
        self.id = id
        self.song = song
        self.artist = artist
        self.album = album
        self.year = year
        self.rating = rating
    }
}
