//
//  MyData.swift
//  Me&Map
//
//  Created by TA Trung Thanh on 26/12/2018.
//  Copyright © 2018 TA Trung Thanh. All rights reserved.
//

import UIKit

class MyData: NSObject {
    /*
    private let rep = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    private var thePath : String
    
    private var content = [OneCell]()
    private var index : Int
    private var size : Int
    enum Keys: String {
        case address = "address"
        case lattitude = "lattitude"
        case longitude = "longitude"
    }
    override init() {
        thePath = rep[0] + "/meAndMapLocations"
        content = [OneCell]()
        index = 0
        size = 0
    }
    
    func saveData() {
        let coder = NSKeyedArchiver(requiringSecureCoding: false)
        coder.encode(content, forKey: NSKeyedArchiveRootObjectKey)
        FileManager.default.createFile(atPath: thePath, contents: coder.encodedData, attributes: [:])
        
    }
    
    func loadCells() {
        
        
        guard let cellsData = UserDefaults.standard.object(forKey: "cells") as? NSData else {
            print("'cells' not found in UserDefaults")
            return
        }
        
        guard let cellsArray = NSKeyedUnarchiver.unarchivedObject(ofClass: <#T##NSCoding.Protocol#>, from: cellsData)
 
        /*
        guard let cellsArray = NSKeyedUnarchiver.unarchiveObject(with: cellsData as Data) as? [OneCell] else {
            print("Could not unarchive from cellsData")
            return
        }*/
        
        for place in placesArray {
            print("")
            print("place.latitude: \(place.latitude)")
            print("place.longitude: \(place.longitude)")
            print("place.name: \(place.name)")
        }
        
        
        
        
        //Fetch data
        if FileManager.default.fileExists(atPath: thePath) {
            let data = FileManager.default.contents(atPath: thePath)
            if data != nil {
                do {
                    let decoder = try NSKeyedUnarchiver(forReadingFrom: data!)
                    decoder.requiresSecureCoding = false
                    let d = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data!) as?
                } catch {
                    print("Decoding failed!!!")
                }
            }
        }
    }
 */
}
