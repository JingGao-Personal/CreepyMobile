//
//  FlickrViewController.swift
//  CreepyMobile
//
//  Created by Jing Gao on 17/09/2015.
//  Copyright (c) 2015 Jing Gao. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class FlickrViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    let FLICKR_API_KEY:String = "cb255dc9e715caf48129bd3fd8f0e8ad"
    let FLICKR_URL:String = "https://api.flickr.com/services/rest/"
    let SEARCH_METHOD:String = "flickr.photos.search"
    let FORMAT_TYPE:String = "json"
    let JSON_CALLBACK:Int = 1
    let PRIVACY_FILTER:Int = 1
    
    let SEARCHID_METHOD:String = "flickr.people.findByUsername"
    let SEARCHPUBLIC_METHOD:String = "flickr.people.getPublicPhotos"
    let SEARCHGEO_METHOD:String = "flickr.photos.geo.getLocation"
    
    let PER_PAGE:Int = 1
    let PAGE:Int = 1
    let SAFE_SEARCH: Int = 1
    
    var flickerUserID:String!
    var flickerPhotoID:String!
    var flickerText:String!
    var flickerLati:Double!
    var flickerLongti:Double!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernameField.delegate = self
       

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnSubmit(sender: AnyObject) {
    
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if (segue.identifier == "btnSubmitSegue") {
            var svc = segue.destinationViewController as! FlickrMapViewController
            var username:String = usernameField.text
            
            svc.username = usernameField.text
            svc.text = self.flickerText
            
            svc.lati = self.flickerLati
            svc.longti = self.flickerLongti
            
            
        }
    }
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
    
    
    func displayPublic(userID:String){
        
        Alamofire.request(.GET, FLICKR_URL, parameters: ["method": SEARCHPUBLIC_METHOD, "api_key": FLICKR_API_KEY, "user_id":userID, "extras":"date_upload", "per_page":PER_PAGE , "page":PAGE, "format":FORMAT_TYPE, "nojsoncallback": JSON_CALLBACK])
            .responseJSON { (request, response, data, error) in
                
                if(data != nil){
                    
                    
                    var innerJson:JSON = JSON(data!)
                    
                    var farm:String = innerJson["photos"]["photo"][0]["farm"].stringValue
                    var server:String = innerJson["photos"]["photo"][0]["server"].stringValue
                    var photoID:String = innerJson["photos"]["photo"][0]["id"].stringValue
                    
                    var secret:String = innerJson["photos"]["photo"][0]["secret"].stringValue
                    
                    var imageString:String = "http://farm\(farm).staticflickr.com/\(server)/\(photoID)_\(secret)_n.jpg/"
                    var text:String = innerJson["photos"]["photo"][0]["title"].stringValue
                    var time:String = innerJson["photos"]["photo"][0]["dateupload"].stringValue
                    
                    
                    self.urlToImageView(imageString)
                    self.textLabel.text = text
                    self.timeLabel.text = time
                    
                    
                }
        }

        
    }
    
    
    
    func displayUserID(){
        
        Alamofire.request(.GET, FLICKR_URL, parameters: ["method": SEARCHID_METHOD, "api_key": FLICKR_API_KEY, "username":usernameField.text,"privacy_filter":PRIVACY_FILTER, "format":FORMAT_TYPE, "nojsoncallback": JSON_CALLBACK])
            .responseJSON { (request, response, data, error) in
                
                if(data != nil){
                
                    var innerJson:JSON = JSON(data!)
                    
                    var userID:String = innerJson["user"]["id"].stringValue
                    
                    self.displayPublic(userID)
                    
                    
                }
                
        }
    }
    
    func getUserID(username:String, completionHandler:(String ->Void)){
        
        Alamofire.request(.GET, FLICKR_URL, parameters: ["method": SEARCHID_METHOD, "api_key": FLICKR_API_KEY, "username":username,"privacy_filter":PRIVACY_FILTER, "format":FORMAT_TYPE, "nojsoncallback": JSON_CALLBACK])
            .responseJSON { (request, response, data, error) in
                
                if(data != nil){
                    
                    var innerJson:JSON = JSON(data!)
                    
                    var userID:String = innerJson["user"]["id"].stringValue
                    completionHandler(userID)
                    
                }
                
        }

    }
    
    func getPhotoInfo(userID:String, completionHandler:(String ->Void)) {
        
        Alamofire.request(.GET, FLICKR_URL, parameters: ["method": SEARCHPUBLIC_METHOD, "api_key": FLICKR_API_KEY, "user_id":userID, "extras":"date_upload", "per_page":PER_PAGE , "page":PAGE, "format":FORMAT_TYPE, "nojsoncallback": JSON_CALLBACK])
            .responseJSON { (request, response, data, error) in
                
                if(data != nil){
                
                    var innerJson:JSON = JSON(data!)
                    
                    var photoID:String = innerJson["photos"]["photo"][0]["id"].stringValue
                    completionHandler(photoID)
                }
        }

    }
    
    func getText(userID:String, completionHandler:(String ->Void)) {
        
        Alamofire.request(.GET, FLICKR_URL, parameters: ["method": SEARCHPUBLIC_METHOD, "api_key": FLICKR_API_KEY, "user_id":userID, "extras":"date_upload", "per_page":PER_PAGE , "page":PAGE, "format":FORMAT_TYPE, "nojsoncallback": JSON_CALLBACK])
            .responseJSON { (request, response, data, error) in
                
                if(data != nil){
                    
                    var innerJson:JSON = JSON(data!)
                    var text:String = innerJson["photos"]["photo"][0]["title"].stringValue
                    completionHandler(text)
                }
        }

    }
    
    func getLati(photoID:String, completionHandler:(Double ->Void)){
        Alamofire.request(.GET, FLICKR_URL, parameters: ["method": SEARCHGEO_METHOD, "api_key": FLICKR_API_KEY, "photo_id":photoID, "format":FORMAT_TYPE, "nojsoncallback": JSON_CALLBACK])
            .responseJSON { (request, response, data, error) in
                
                if(data != nil){
                    
                    var innerJson:JSON = JSON(data!)
                    
                    var latitude:Double = innerJson["photo"]["location"]["latitude"].doubleValue
                    println(innerJson)
                    completionHandler(latitude)
                    
                }
                
        }

    
    }
    
    func getlongti(photoID:String, completionHandler:(Double ->Void)){
        Alamofire.request(.GET, FLICKR_URL, parameters: ["method": SEARCHGEO_METHOD, "api_key": FLICKR_API_KEY, "photo_id":photoID, "format":FORMAT_TYPE, "nojsoncallback": JSON_CALLBACK])
            .responseJSON { (request, response, data, error) in
                
                if(data != nil){
                    
                    var innerJson:JSON = JSON(data!)
                    
                    var longtitude:Double = innerJson["photo"]["location"]["longitude"].doubleValue
                    completionHandler(longtitude)
                    
                }
                
        }

    }

    
    @IBAction func searchUserID(sender: UIButton) {
        displayUserID()
        var username:String = usernameField.text
        getUserID(username, completionHandler:{
            userID in
            self.getText(userID, completionHandler: {
                text in
                self.flickerText = text
                
            })
            
            self.getPhotoInfo(userID, completionHandler: {
                photoID in
                
                self.getLati(photoID, completionHandler: {
                    latitude in
                    self.flickerLati = latitude
                })
                self.getlongti(photoID, completionHandler: {
                    longtitude in
                    self.flickerLongti = longtitude
                    
                })
                
                
            })
            
        })

    }
    
    
    
    
    
}