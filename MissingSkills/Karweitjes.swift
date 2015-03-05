//
//  Karweitjes.swift
//  HackdeOverheid
//
//  Created by Niels Pijpers on 26-01-15.
//  Copyright (c) 2015 UB-online. All rights reserved.
//

import Foundation

class Karweitjes
{
    var name = "Karweitje"
    var description = "Beschrijving"
    var deadline = ""
    var coins = ""
    var grade = ""
    
    init(name: String, description: String, coins: String, deadline: String, grade: String) {
        self.name = name;
        self.description = description;
        self.coins = coins;
        self.deadline = deadline;
        self.grade = grade
    }
}