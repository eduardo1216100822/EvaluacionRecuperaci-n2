//
//  CompanyModel.swift
//  MyStoreMusic
//
//  Created by Jose Carlos Rodriguez on 5/1/19.
//  Copyright © 2019 Jose Carlos Rodriguez. All rights reserved.
//

class CompanyModel{
    var id: String?
    var name: String?
    var city: String?
    var popularity: String?
    
    init(id: String?, name: String?, city: String?, popularity: String?) {
        self.id = id
        self.name = name
        self.city = city
        self.popularity = popularity
    }
}
