//
//  debugs.swift
//  Word Flakes
//
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
