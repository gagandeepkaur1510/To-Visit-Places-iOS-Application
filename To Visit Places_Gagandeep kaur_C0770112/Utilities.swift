//
//  Utilities.swift
//  To Visit Places_Gagandeep kaur_C0770112
//
//  Created by Mac on 6/15/20.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation
import MapKit

class Utilities
{
    private static var mLongitudes: [CLLocationDegrees] = []
    private static var mLatitudes: [CLLocationDegrees] = []
    private static var mNames: [String] = []
    
    static func add(latitude: CLLocationDegrees, longitude: CLLocationDegrees, name: String)
    {
        mLatitudes.append(latitude)
        mLongitudes.append(longitude)
        mNames.append(name)
        print(latitude)
    }
    
    static func get(index: Int) -> (CLLocationDegrees, CLLocationDegrees, String)
    {
        return (mLatitudes[index],mLongitudes[index], mNames[index])
    }
    
    
    
    static func remove(index: Int)
    {
        mLatitudes.remove(at: index)
        mLongitudes.remove(at: index)
        mNames.remove(at: index)
    }
    
    static func getNumber() -> Int
    {
        return mLongitudes.count
    }
}
