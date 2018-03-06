//
//  Requests.swift
//  On The Map
//
//  Created by Ravikiran Pathade on 3/5/18.
//  Copyright © 2018 Ravikiran Pathade. All rights reserved.
//

import Foundation

func loginFunction(username: String, password: String, completionHandler:@escaping(_ success:Bool)->Void){
    var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    var retValue: Bool = false
    request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
    let session = URLSession.shared
    let task = session.dataTask(with: request) { data, response, error in
        if error != nil { // Handle error…
            print(error as Any)
            return
        }
        let range = Range(5..<data!.count)
        let newData = data?.subdata(in: range) /* subset response data! */
        
        var parsedResult: AnyObject!
        do{
            parsedResult = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as AnyObject
            
        }catch{
            print("Cannot Serialize")
            return
        }
        
        if let accountResult = parsedResult["account"] as? [String:AnyObject]{
            let key = accountResult["registered"] as? String
        
            completionHandler(true)
        }else{
            completionHandler(false)
        }
    }
    task.resume()
}
