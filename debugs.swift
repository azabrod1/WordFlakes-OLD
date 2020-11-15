//
//  debugs.swift
//  Word Flakes
//
//  Created by Tatyana kudryavtseva on 01/08/16.
//  Copyright © 2016 Organized Chaos. All rights reserved.
//

import Foundation


func p<T>(toPrint : T, description : String? = nil ){
    
    if description == nil{
        print("\(toPrint)")
    }
        
    else{
        print("\(String(description)):  \(toPrint)")
        
    }
}