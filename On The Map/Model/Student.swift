//
//  Student.swift
//  On The Map
//
//  Created by Ravikiran Pathade on 3/7/18.
//  Copyright © 2018 Ravikiran Pathade. All rights reserved.
//

import Foundation

class Student{
    var objectID = ""
    var mapString = ""
    var uniqueKey = ""
    var firstName = ""
    var lastName = ""
    var mediaUrl = ""
    var lattitude : Float = 0
    var longitude : Float = 0
    
    init(dictionary: [String:AnyObject]) {
        mapString = dictionary["mapString"] as! String
        firstName = dictionary["firstName"] as! String
        lastName = dictionary["lastName"] as! String
        mediaUrl = dictionary["mediaURL"] as! String
        lattitude = dictionary["latitude"] as! Float
        longitude = dictionary["longitude"] as! Float
        objectID = dictionary["objectId"] as! String
        uniqueKey = dictionary["uniqueKey"] as! String
        mapString = dictionary["mapString"] as! String
    }
    static func studentFromResults(_ results:[[String:AnyObject]])->[Student]{
        var student = [Student]()
        for result in results{
            student.append(Student(dictionary: result))
        }
        return student
    }
}
