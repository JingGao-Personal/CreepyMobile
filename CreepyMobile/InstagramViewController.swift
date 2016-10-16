//
//  InstagramViewController.swift
//  CreepyMobile
//
//  Created by Jing Gao on 15/09/2015.
//  Copyright (c) 2015 Jing Gao. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Foundation

class InstagramViewController: UIViewController {
    
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    var insUserID:String!
    var insText:String!
    var insLati:Double!
    var insLongi:Double!
    
    
    let accessToken = "2067138643.1fb234f.cdc2603d7d164efa8b6d468269dd59bb"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if (segue.identifier == "btnSubmitSegue") {
            var svc = segue.destinationViewController as! InstagramMapViewController
            var username:String = usernameField.text
            
            svc.username = usernameField.text
            svc.text = self.insText
            
            svc.lati = self.insLati
            svc.longti = self.insLongi
            
            
        }
    }

    
    func urlToImageView(imageString: String){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            dispatch_async(dispatch_get_main_queue(), {
                let url = NSURL(string: imageString)
                let imageData = NSData(contentsOfURL: url!)
                if(imageData != nil){
                    self.imageView.image = UIImage(data: imageData!)
                    
                } else {
                    self.urlToImageView(imageString)
                }
                
            });
        });
        
    }

    
    func loadData(username:String) {
        let url = "https://api.instagram.com/v1/users/search?q=\(username)&access_token=2067138643.1fb234f.cdc2603d7d164efa8b6d468269dd59bb"
        
        Alamofire.request(.GET, url).responseJSON {
            (request, response, data, error) in
            if data != nil {
                var innerJson:JSON = JSON(data!)
                var userID:String = innerJson["data"][0]["id"].stringValue
                self.getRecent(userID)
                
            }
        }
    }
    
    func getRecent(userID:String) {
        let url = "https://api.instagram.com/v1/users/\(userID)/media/recent/?access_token=2067138643.1fb234f.cdc2603d7d164efa8b6d468269dd59bb"
        
        Alamofire.request(.GET, url).responseJSON {
            (request, response, data, error) -> Void in
            //            println(json)
            if data != nil {
                var innerJson:JSON = JSON(data!)
                var text:String = innerJson["data"][0]["caption"]["text"].stringValue
                var time:String = innerJson["data"][0]["caption"]["created_time"].stringValue
                var imageString:String = innerJson["data"][0]["images"]["standard_resolution"]["url"].stringValue
                self.urlToImageView(imageString)
                self.textLabel.text = text
                self.timeLabel.text = time
            }
        }
 
        
    }
    
    func getUserID(username:String, completionHandler:(String ->Void)){
        let url = "https://api.instagram.com/v1/users/search?q=\(username)&access_token=2067138643.1fb234f.cdc2603d7d164efa8b6d468269dd59bb"
        
        Alamofire.request(.GET, url).responseJSON {
            (request, response, data, error) in
            if data != nil {
                var innerJson:JSON = JSON(data!)
                var userID:String = innerJson["data"][0]["id"].stringValue
                completionHandler(userID)
            }
        }

    }
    
    func getText(userID:String, completionHandler:(String ->Void)){
        let url = "https://api.instagram.com/v1/users/\(userID)/media/recent/?access_token=2067138643.1fb234f.cdc2603d7d164efa8b6d468269dd59bb"
        
        Alamofire.request(.GET, url).responseJSON {
            (request, response, data, error) -> Void in
            //            println(json)
            if data != nil {
                var innerJson:JSON = JSON(data!)
                var text:String = innerJson["data"][0]["caption"]["text"].stringValue
                completionHandler(text)
            }
        }

    }
    
    func getLati(userID:String, completionHandler:(Double ->Void)){
        let url = "https://api.instagram.com/v1/users/\(userID)/media/recent/?access_token=2067138643.1fb234f.cdc2603d7d164efa8b6d468269dd59bb"
        
        Alamofire.request(.GET, url).responseJSON {
            (request, response, data, error) -> Void in
            //            println(json)
            if data != nil {
                var innerJson:JSON = JSON(data!)
                var latitude:Double = innerJson["data"][0]["location"]["latitude"].doubleValue
                completionHandler(latitude)
            }
        }

    }
    
    func getLongti(userID:String, completionHandler:(Double ->Void)){
        let url = "https://api.instagram.com/v1/users/\(userID)/media/recent/?access_token=2067138643.1fb234f.cdc2603d7d164efa8b6d468269dd59bb"
        
        Alamofire.request(.GET, url).responseJSON {
            (request, response, data, error) -> Void in
            //            println(json)
            if data != nil {
                var innerJson:JSON = JSON(data!)
                var longitude:Double = innerJson["data"][0]["location"]["longitude"].doubleValue
                completionHandler(longitude)
            }
        }
        
    }


    
    @IBAction func searchTapped(sender: AnyObject) {
        var username:String = usernameField.text
        loadData(username)
        getUserID(username, completionHandler:{
            userID in
            self.getText(userID, completionHandler: {
                text in
                self.insText = text
                
            })
            self.getLati(userID, completionHandler: {
                latitude in
                self.insLati = latitude
                })
            self.getLongti(userID, completionHandler: {
                longitude in
                self.insLongi = longitude
                    
            })
                
                
            
        })

        
        

    
    }

    @IBAction func btnSubmit(sender: AnyObject) {
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
