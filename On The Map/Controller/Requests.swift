//
//  Requests.swift
//  On The Map
//
//  Created by Ravikiran Pathade on 3/5/18.
//  Copyright © 2018 Ravikiran Pathade. All rights reserved.
//

import Foundation

func loginFunction(username: String, password: String, completionHandler:@escaping(_ success:Bool,_ key:String,_ conError:Bool)->Void){
    var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
   
    request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
    let session = URLSession.shared
    let task = session.dataTask(with: request) { data, response, error in
        if error != nil { // Handle error…
            completionHandler(false,"nil",true)
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
            let key = accountResult["key"] as? String
            let registered = accountResult["registered"] as? Bool
            completionHandler(registered!,key!,false)
        }else{
            completionHandler(false,"nil",false)
        }
    }
    task.resume()
}

func logOutFunction(){
    var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
    request.httpMethod = "DELETE"
    var xsrfCookie: HTTPCookie? = nil
    let sharedCookieStorage = HTTPCookieStorage.shared
    for cookie in sharedCookieStorage.cookies! {
        if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
    }
    if let xsrfCookie = xsrfCookie {
        request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
    }
    let session = URLSession.shared
    let task = session.dataTask(with: request) { data, response, error in
        if error != nil { // Handle error…
            return
        }
        let range = Range(5..<data!.count)
        let newData = data?.subdata(in: range) /* subset response data! */
        print(String(data: newData!, encoding: .utf8)!)
    }
    task.resume()
}

func listAllStudents(completionHandler:@escaping(_ students:[Student])->Void){
    var allStudents = [Student]()
    var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
    request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
    request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
    let session = URLSession.shared
    let task = session.dataTask(with: request) { data, response, error in
        if error != nil { // Handle error...
            return
        }
       // print(String(data: data!, encoding: .utf8)!)
        var parsedResult: AnyObject!
        do{
            parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as AnyObject
            //allStudents = Student.studentFromResults(parsedResult as! [[String : AnyObject]])
            if let p1 = parsedResult["results"] as? [[String:AnyObject]]{
                allStudents = Student.studentFromResults(p1)
                completionHandler(allStudents)
            }else{
                print("Unable to print")
            }
       
        }catch{
            print("Cannot Serialize")
            return
        }
    
    }
    task.resume()

}
func postStudentLocation(key:String,fname:String,lname:String,mapString:String,mediaUrl:String,latt:Double,long:Double,completionHandler:@escaping(_ success:Bool)->Void){
    //let defaults = UserDefaults.standard
//    let fname = defaults.string(forKey: "fname")!
//    let lname = defaults.string(forKey: "lname")!
    
    var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
    request.httpMethod = "POST"
    request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
    request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = "{\"uniqueKey\": \"\(key)\", \"firstName\": \"\(fname)\", \"lastName\": \"\(lname)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaUrl)\",\"latitude\": \(latt), \"longitude\": \(long)}".data(using: .utf8)
    
    let session = URLSession.shared
    //key, fname,lname, mapString-location, mediaUrl, latt, long
    let task = session.dataTask(with: request) { data, response, error in
        if error != nil { // Handle error…
            completionHandler(false)
            return
        }else{
            var parsedResult: AnyObject!
            do{
                parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as AnyObject
                //allStudents = Student.studentFromResults(parsedResult as! [[String : AnyObject]])
                if let p1 = parsedResult["objectId"] as? String{
                    print("success Post")
                   completionHandler(true)
                }else{
                    completionHandler(false)
                    print("Unable to print")
                }
                
            }catch{
                completionHandler(false)
            }
        }
        print(String(data: data!, encoding: .utf8)!)
    }
    task.resume()
}
func getUserDetails(){
    let defaults = UserDefaults.standard
    let key = defaults.string(forKey: "key")!
    let request = URLRequest(url: URL(string: "https://www.udacity.com/api/users/\(key)")!)
    let session = URLSession.shared
    let task = session.dataTask(with: request) { data, response, error in
        if error != nil { // Handle error...
            return
        }else{
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range)
           
            var parsedResult: AnyObject!
            do{
                parsedResult = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as AnyObject
                
            }catch{
                print("Cannot Serialize")
                return
            }
            
            if let accountResult = parsedResult["user"] as? [String:AnyObject]{
                let fname = accountResult["first_name"] as? String
                let lname = accountResult["last_name"] as? String
                let defaults = UserDefaults.standard
                defaults.set(fname, forKey: "fname")
                defaults.set(lname, forKey: "lname")
            }
        }
     /* subset response data! */
        
    }
    task.resume()
}
