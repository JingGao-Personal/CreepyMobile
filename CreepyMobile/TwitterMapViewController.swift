//
//  TwitterMapViewController.swift
//  CreepyMobile
//
//  Created by Jing Gao on 27/09/2015.
//  Copyright (c) 2015 Jing Gao. All rights reserved.
//

import UIKit
import GoogleMaps

class TwitterMapViewController: UIViewController, GMSMapViewDelegate {
    
    var lati:Double!
    var longti:Double!
    var text:String!
    var time:String!
    var username:String!
    var imageValue:String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var camera = GMSCameraPosition.cameraWithLatitude(lati,
            longitude: longti, zoom: 14.7)
        var mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.myLocationEnabled = true
        mapView.delegate = self
        self.view = mapView
        
        
        var marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(lati, longti)
//        marker.title = username
//        marker.snippet = "Australia"
        marker.map = mapView


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(mapView: GMSMapView!, markerInfoWindow marker: GMSMarker!) -> UIView! {
        var infoWindow = NSBundle.mainBundle().loadNibNamed("CustomInfoWindow", owner: self, options: nil).first! as! CustomInfoWindow
        infoWindow.twitterTime.text = time
        infoWindow.twitterText.text = text
        infoWindow.image.text = imageValue
        self.urlToImageView(imageValue)
        return infoWindow
    }
    
    func getDistanceMetresBetweenLocationCoordinates(coord1: CLLocationCoordinate2D, coord2: CLLocationCoordinate2D) -> Double {
        var location1 = CLLocation(latitude: coord1.latitude, longitude: coord1.longitude)
        var location2 = CLLocation(latitude: coord2.latitude, longitude: coord2.longitude)
        return location1.distanceFromLocation(location2)
    }
    
    func urlToImageView(imageString: String){
        var info = NSBundle.mainBundle().loadNibNamed("CustomInfoWindow", owner: self, options: nil).first! as! CustomInfoWindow
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            dispatch_async(dispatch_get_main_queue(), {
                let url = NSURL(string: imageString)
                let imageData = NSData(contentsOfURL: url!)
                if(imageData != nil){
                    info.twitterImage.image = UIImage(data: imageData!)
                    
                } else {
                    self.urlToImageView(imageString)
                }
                
            });
        });
        
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
