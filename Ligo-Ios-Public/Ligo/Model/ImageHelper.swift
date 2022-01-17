//
//  ImageHelper.swift
//  Ligo
//
//  Created by Cyrus Illick on 15/07/2020.
//  Copyright © 2020 Ligo. All rights reserved.
//

import Foundation
import UIKit

class ImageHelper{
    
    
    static func loadImage(urlString:String, withCache:Bool = true,  completion:@escaping (String,UIImage)->Void) -> URLSessionDataTask?{
    
            guard let url = URL(string: urlString) else{
                print("INVALID URL")
                return nil
            }
            
        if withCache, let cachedImage = try? ImageHelper.getData(key: url.lastPathComponent){
                     //print("Got data")
                     if let image = UIImage(data: cachedImage){
                       //  print("Loaded from cache")
                         completion(urlString,image)
                         return nil
                     }
                 }
            
            
            let urlRequest = URLRequest(url: url)
            
            
            
         let task =   URLSession.shared.dataTask(with: urlRequest) {(data, response, error) in
                
                ///print("Downloaded \(urlString)")
                
                if error != nil  || data == nil{
                   // print(error ?? "Data is null")
                    //TODO: Add error handling
                    print("ERROR \(error)")
                    return
                }
                if let image = UIImage(data: data!) {
                    try? ImageHelper.saveData(key: url.lastPathComponent, data: data!)
                    
                    //self?.imageCache.setObject(image, forKey: urlString as NSString)
                    DispatchQueue.main.async {
                        
                        
                        completion(urlString,image)
                    }
                }
                
                
            }
         task.resume()
        return task
        }
    
    
    
   static func getData(key:String) throws  -> Data? {
           
           //print("Finding data for \(key)")
    let filename = ImageHelper.getDir().appendingPathComponent(key)
           return try Data(contentsOf: filename)
           
           
       }
       
     static  func saveData(key:String,data:Data) throws {
          //print("Saving data for \(key)")
        let filename = ImageHelper.getDir().appendingPathComponent(key)
           do {
               try data.write(to: filename)
               
           }catch{
              // print("Couldn't save")
           }
       }
       
     static fileprivate func getDir() -> URL{
           let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
               return path
       }
}
