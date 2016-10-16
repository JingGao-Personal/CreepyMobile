//
//  NearbyMapViewController.swift
//  CreepyMobile
//
//  Created by Jing Gao on 1/10/2015.
//  Copyright (c) 2015 Jing Gao. All rights reserved.
//

import UIKit
import GoogleMaps

class NearbyMapViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var nearbyMapView: GMSMapView!
    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        let camera: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(48.859025596, longitude: 2.298117144, zoom: 14.7)
        nearbyMapView.camera = camera
        
        var marker = GMSMarker()
        marker.position = camera.target
        marker.title = "JingGao1"
        marker.snippet = "test1"
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.map = nearbyMapView
        
        let test: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(48.858844, longitude: 2.294351, zoom: 14.7)
        nearbyMapView.camera = test
        
        var marker1 = GMSMarker()
        marker1.position = test.target
        marker1.title = "JingGao1"
        marker1.snippet = "test2"
        marker1.appearAnimation = kGMSMarkerAnimationPop
        marker1.map = nearbyMapView

        // Do any additional setup after loading the view.
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
