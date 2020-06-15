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
    private static var mLongitudes: [CLLocationCoordinate2D] = []
    private static var mLatitudes: [CLLocationCoordinate2D] = []
    
    static func add(latitude: CLLocationCoordinate2D, longitude: CLLocationCoordinate2D)
    {
        mLatitudes.append(latitude)
        mLongitudes.append(longitude)
    }
    
    static func get(index: Int) -> (CLLocationCoordinate2D, CLLocationCoordinate2D)
    {
        return (mLatitudes[index],mLongitudes[index])
    }
    
    static func save()
    {
        let user_defaults = UserDefaults.standard
        user_defaults.set(mLongitudes, forKey: "longitudes")
        user_defaults.set(mLatitudes, forKey: "latitudes")
    }
}
