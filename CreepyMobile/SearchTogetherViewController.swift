//
//  SearchTogetherViewController.swift
//  CreepyMobile
//
//  Created by Jing Gao on 18/10/2015.
//  Copyright (c) 2015 Jing Gao. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SearchTogetherViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var username: UITextField!
    @IBOutlet var mapView: GMSMapView!
    var locationManager = CLLocationManager()
    
    let accessToken = "2067138643.1fb234f.cdc2603d7d164efa8b6d468269dd59bb"

    override func viewDidLoad() {
        super.viewDidLoad()
        


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                var latitude:Double = innerJson["data"][0]["location"]["latitude"].doubleValue
                var longitude:Double = innerJson["data"][0]["location"]["longitude"].doubleValue
                var text:String = innerJson["data"][0]["caption"]["text"].stringValue
                
                var secLatitude:Double = innerJson["data"][1]["location"]["latitude"].doubleValue
                var secLongitude:Double = innerJson["data"][1]["location"]["longitude"].doubleValue
                var secText:String = innerJson["data"][1]["caption"]["text"].stringValue
                
                var thirLatitude:Double = innerJson["data"][2]["location"]["latitude"].doubleValue
                var thirLongitude:Double = innerJson["data"][2]["location"]["longitude"].doubleValue
                var thirText:String = innerJson["data"][2]["caption"]["text"].stringValue
                
                
                
                self.locationManager.delegate = self
                self.locationManager.requestWhenInUseAuthorization()
                
                let camera: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(latitude, longitude: longitude, zoom: 14.7)
                self.mapView.camera = camera
                
                var marker = GMSMarker()
                marker.position = camera.target
                marker.title = text
                marker.appearAnimation = kGMSMarkerAnimationPop
                marker.map = self.mapView
                
                let test: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(secLatitude, longitude: secLongitude, zoom: 14.7)
                self.mapView.camera = test
                
                var marker1 = GMSMarker()
                marker1.position = test.target
                marker1.title = secText
                marker1.appearAnimation = kGMSMarkerAnimationPop
                marker1.map = self.mapView
                
                let test2: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(thirLatitude, longitude: thirLongitude, zoom: 14.7)
                self.mapView.camera = test2
                
                var marker2 = GMSMarker()
                marker2.position = test2.target
                marker2.title = thirText
                marker2.appearAnimation = kGMSMarkerAnimationPop
                marker2.map = self.mapView

                
                
            }
        }
        
        
    }
    
    @IBAction func searchTapped(sender: AnyObject) {
        var insUser:String = self.username.text
        loadData(insUser)
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
