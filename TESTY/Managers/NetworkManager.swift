//
//  NetworkManager.swift
//  TESTY
//
//  Created by User on 04/04/2018.
//  Copyright © 2018 MPTechnologies. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class NetworkManager: NSObject {
    
    class func getUsers(_ userCount: Int, page: Int, completion: @escaping(_ dict: [String:[String]], _ errorMsg: String?)->Void) {
        
        var dictionary: [String:[String]] = [:]
        
        let url = URL(string: "https://randomuser.me/api/1.1/?page=\(page)&results=\(userCount)&seed=abc")!
        
        let session = URLSession.shared
        let request = URLRequest(url: url)
        //request.httpMethod = HTTPMethod.get.rawValue
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                //create json object from data
                
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] {
                    print(json["results"])
                    
                    var ret:[[String:Any]]?
                    var names:[String] = []
                    var phones:[String] = []
                    var images:[String] = []
                    var emails:[String] = []
                    
                    ret = json["results"] as? [[String : Any]]
                    
                    // handle json...
                    //dictionary = json["results"]
                    for x in ret ?? [] {
                        var name:[String:Any]?
                        var picture:[String:String]?
                        //print(x["phone"])
                        picture = x["picture"] as? [String : String]
                        name = x["name"] as! [String : String]
                        let pic = picture!["thumbnail"]
                        let first:String = name!["first"] as! String
                        let last:String = name!["last"] as! String
                        let phone = x["phone"] as! String
                        let email = x["email"] as! String
                        
                        
                        names.append("\(first) \(last)")
                        images.append(pic ?? "")
                        phones.append(phone)
                        emails.append(email)
                    }
                    dictionary["names"] = names
                    dictionary["images"] = images
                    dictionary["phones"] = phones
                    dictionary["emails"] = emails
                }
                completion(dictionary, nil)
            } catch let error {
                print(error.localizedDescription)
                completion([:], error.localizedDescription)
            }
            
            
        })
        task.resume()
    }
    
}
