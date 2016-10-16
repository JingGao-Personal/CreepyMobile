//
//  TwitterViewController.swift
//  CreepyMobile
//
//  Created by Jing Gao on 18/09/2015.
//  Copyright (c) 2015 Jing Gao. All rights reserved.
//

import UIKit
import Accounts
import Social
import SwifteriOS
//import SwiftyJSON


class TwitterViewController: UIViewController {
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    var swifter: Swifter
    let useACAccount = true
    
    var twiText:String!
    var twiLati:Double!
    var twiLongi:Double!
    var twiTime:String!
    var twiImage:String!
    
    required init(coder aDecoder: NSCoder) {
        self.swifter = Swifter(consumerKey: "RErEmzj7ijDkJr60ayE2gjSHT", consumerSecret: "SbS0CHk11oJdALARa7NDik0nty4pXvAxdt7aj0R5y1gNzWaNEx")
        super.init(coder: aDecoder)
    }

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
            var svc = segue.destinationViewController as! TwitterMapViewController
            var username:String = usernameField.text
            
            svc.username = usernameField.text
            svc.text = self.twiText
            
            svc.lati = self.twiLati
            svc.longti = self.twiLongi
            svc.time = self.twiTime
            svc.imageValue = self.twiImage
            
            
        }
    }

    @IBAction func btnSubmit(sender: AnyObject) {
    }
    
    @IBAction func searchTapped(sender: AnyObject) {
        var username:String = usernameField.text
        
        
        let failureHandler: ((NSError) -> Void) = {
            error in
            
            self.alertWithTitle("Error", message: error.localizedDescription)
        }
        
        if useACAccount {
            let accountStore = ACAccountStore()
            let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
            
            // Prompt the user for permission to their twitter account stored in the phone's settings
            accountStore.requestAccessToAccountsWithType(accountType, options: nil) {
                granted, error in
                
                if granted {
                    let twitterAccounts = accountStore.accountsWithAccountType(accountType)
                    
                    if twitterAccounts?.count == 0
                    {
                        self.alertWithTitle("Error", message: "There are no Twitter accounts configured. You can add or create a Twitter account in Settings.")
                    }
                    else {
                        let twitterAccount = twitterAccounts[0] as! ACAccount
                        self.swifter = Swifter(account: twitterAccount)
                        self.fetchUserShow(username)
                        self.getUserText(username, completionHandler: {
                            text in
                            self.twiText = text
                        })
                        self.getUserTime(username, completionHandler: {
                            time in
                            self.twiTime = time
                        })
                        self.getImage(username, completionHandler: {
                            imageString in
                            self.twiImage = imageString
                        })
                        self.getLatitude(username, completionHandler: {
                            latitude in
                            self.twiLati = latitude
                        })
                        self.getLongitude(username, completionHandler: {
                            longitude in
                            self.twiLongi = longitude
                        })
                        
                        
                        
                    }
                }
                else {
                    self.alertWithTitle("Error", message: error.localizedDescription)
                }
            }
        }
        else {
            swifter.authorizeWithCallbackURL(NSURL(string: "swifter://success")!, success: {
                accessToken, response in
                
                self.fetchUserShow(username)
                
                },failure: failureHandler
            )
        }
    }
    
    func fetchUserShow(username:String){
        let failureHandler: ((NSError) -> Void) = {
            error in
            self.alertWithTitle("Error", message: error.localizedDescription)
        }
        
        
        self.swifter.getUsersShowWithScreenName(username, includeEntities: true, success: {
            (user: Dictionary<String, JSONValue>?) in
            
            if let user = user {
                if let userStatus = user["status"]{
                    var text = userStatus["text"].string
                    var time = userStatus["created_at"].string
                    self.textLabel.text = text!
                    self.timeLabel.text = time!

                    var imageString = userStatus["entities"]["media"][0]["media_url"].string
                    self.urlToImageView(imageString!)
                    
                    
                
                }
                
                
            }
            
            }, failure: failureHandler)

    }
    
    func getUserText(username:String, completionHandler:(String ->Void) ){
        let failureHandler: ((NSError) -> Void) = {
            error in
            self.alertWithTitle("Error", message: error.localizedDescription)
        }
        
        self.swifter.getUsersShowWithScreenName(username, includeEntities: true, success: {
            (user: Dictionary<String, JSONValue>?) in
            
            if let user = user {
                if let userStatus = user["status"]{
                    var text = userStatus["text"].string
                    completionHandler(text!)

                    
                    
                }
                
                
            }
            
            }, failure: failureHandler)


    }
    
    func getUserTime(username:String, completionHandler:(String ->Void) ){
        let failureHandler: ((NSError) -> Void) = {
            error in
            self.alertWithTitle("Error", message: error.localizedDescription)
        }
        
        self.swifter.getUsersShowWithScreenName(username, includeEntities: true, success: {
            (user: Dictionary<String, JSONValue>?) in
            
            if let user = user {
                if let userStatus = user["status"]{
                    var time = userStatus["created_at"].string
                    completionHandler(time!)
                    
                    
                    
                }
                
                
            }
            
            }, failure: failureHandler)
        
        
    }
    
    func getImage(username:String, completionHandler:(String ->Void) ){
        let failureHandler: ((NSError) -> Void) = {
            error in
            self.alertWithTitle("Error", message: error.localizedDescription)
        }
        
        self.swifter.getUsersShowWithScreenName(username, includeEntities: true, success: {
            (user: Dictionary<String, JSONValue>?) in
            
            if let user = user {
                if let userStatus = user["status"]{
                    var imageString = userStatus["entities"]["media"][0]["media_url"].string
                    completionHandler(imageString!)
                    
                    
                    
                }
                
                
            }
            
            }, failure: failureHandler)
        
        
    }
    
    func getLatitude(username:String, completionHandler:(Double ->Void) ){
        let failureHandler: ((NSError) -> Void) = {
            error in
            self.alertWithTitle("Error", message: error.localizedDescription)
        }
        
        self.swifter.getUsersShowWithScreenName(username, includeEntities: true, success: {
            (user: Dictionary<String, JSONValue>?) in
            
            if let user = user {
                if let userStatus = user["status"]{
                    var latitude:Double! = userStatus["geo"]["coordinates"][0].double
                    completionHandler(latitude!)
                    
                    
                    
                }
                
                
            }
            
            }, failure: failureHandler)
        
        
    }
    
    func getLongitude(username:String, completionHandler:(Double ->Void) ){
        let failureHandler: ((NSError) -> Void) = {
            error in
            self.alertWithTitle("Error", message: error.localizedDescription)
        }
        
        self.swifter.getUsersShowWithScreenName(username, includeEntities: true, success: {
            (user: Dictionary<String, JSONValue>?) in
            
            if let user = user {
                if let userStatus = user["status"]{
                    var longitude:Double! = userStatus["geo"]["coordinates"][1].double
                    completionHandler(longitude!)
                    
                    
                    
                }
                
                
            }
            
            }, failure: failureHandler)
        
        
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

    
    func alertWithTitle(title: String, message: String) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }



    }



