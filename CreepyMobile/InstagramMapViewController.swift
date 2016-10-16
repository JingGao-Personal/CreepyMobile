//
//  InstagramMapViewController.swift
//  
//
//  Created by Jing Gao on 30/09/2015.
//
//

import UIKit

class InstagramMapViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var mapView: GMSMapView!
    
    

    var locationManager = CLLocationManager()
    var username:String!
    var lati:Double!
    var longti:Double!
    var text:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        let camera: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(lati, longitude: longti, zoom: 14.7)
        mapView.camera = camera
        
        var marker = GMSMarker()
        marker.position = camera.target
        marker.title = username
        marker.snippet = text
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.map = mapView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
