//
//  Colors.swift
//  HackdeOverheid
//
//  Created by Niels Pijpers on 01-02-15.
//  Copyright (c) 2015 UB-online. All rights reserved.
//

import UIKit

class Colors {
    let colorTop = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0).CGColor
    let colorBottom = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0).CGColor
    
    let gl: CAGradientLayer
    
    init() {
        gl = CAGradientLayer()
        gl.colors = [ colorTop, colorBottom]
        gl.locations = [ 0.0, 1.0]
    }
}