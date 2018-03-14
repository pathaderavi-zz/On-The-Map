//
//  StudentsDatasource.swift
//  On The Map
//
//  Created by Ravikiran Pathade on 3/14/18.
//  Copyright © 2018 Ravikiran Pathade. All rights reserved.
//

import Foundation

class StudentDataSource:NSObject{
    var allStudents = [Student]()
    
    class func sharedInstance() -> StudentDataSource {
        struct Singleton {
            static var sharedInstance = StudentDataSource()
        }
        return Singleton.sharedInstance
    }
}
