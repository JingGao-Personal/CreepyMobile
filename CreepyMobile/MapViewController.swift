//
//  MapViewController.swift
//  CreepyMobile
//
//  Created by Jing Gao on 16/09/2015.
//  Copyright (c) 2015 Jing Gao. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        
        let cameraAllendale = GMSCameraPosition.cameraWithLatitude(42.96356, longitude: -85.8899, zoom: 14.7)
        
        let mapView = GMSMapView.mapWithFrame(CGRectZero, camera: cameraAllendale)
        mapView.settings.compassButton = true
        self.view = mapView
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(42.96356, -85.8899)
        marker.title = "GVSU"
        marker.snippet = "Allendale, MI"
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.map = mapView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateLocation(true)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        updateLocation(false)
        updateLocation(true)
        
    }
    
    func updateLocation(running: Bool){
        let mapView = self.view as! GMSMapView
        let status = CLLocationManager.authorizationStatus()
        if running {
            if (CLAuthorizationStatus.AuthorizedWhenInUse == status){
            locationManager.startUpdatingLocation()
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
            }
        } else{
            locationManager.stopUpdatingLocation()
            mapView.settings.myLocationButton = false
            mapView.myLocationEnabled = false
        }
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
