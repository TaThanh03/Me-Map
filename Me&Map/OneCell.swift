//
//  OneCell.swift
//  Me&Map
//
//  Created by TA Trung Thanh on 20/12/2018.
//  Copyright © 2018 TA Trung Thanh. All rights reserved.
//
import UIKit

class OneCell: NSObject , NSCoding {
    enum Keys: String {
        case address = "address"
        case lattitude = "lattitude"
        case longitude = "longitude"
    }
    var address = ""
    var lattitude = 0.0
    var longitude = 0.0
    
    init(add: String, lat: Double, lng: Double) {
        super.init()
        address = add
        lattitude = lat
        longitude = lng
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        address = aDecoder.decodeObject(forKey: Keys.address.rawValue) as! String
        lattitude = aDecoder.decodeObject(forKey: Keys.lattitude.rawValue) as! Double
        longitude = aDecoder.decodeObject(forKey: Keys.longitude.rawValue) as! Double
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(address, forKey: Keys.address.rawValue)
        aCoder.encode(lattitude, forKey: Keys.lattitude.rawValue)
        aCoder.encode(longitude, forKey: Keys.longitude.rawValue)
    }
}
