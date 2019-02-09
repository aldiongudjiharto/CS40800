//
//  MapViewController.swift
//  Getaway
//
//  Created by Avinash Singh on 08/02/19.
//  Copyright © 2019 Avinash Singh. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapSelectionSegmentedControl: UISegmentedControl!
    @IBOutlet weak var mapView: MKMapView!
    
    
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        locationManager.delegate = self
        
        mapView.showsUserLocation = true
        
    if(locationManager.responds(to:#selector(CLLocationManager.requestAlwaysAuthorization))) {
            locationManager.requestAlwaysAuthorization()
            //or
            //locationManager.requestWhenInUseAuthorization()
        }
        updateAnnotations()
        
    }
    
    @IBAction func mapSelectionChanged(_ sender: Any) {
        updateAnnotations()
    }
    
    func updateAnnotations() {
        switch mapSelectionSegmentedControl.selectedSegmentIndex {
        case 0:
            displayGlobalAnnotations()
        case 1:
            displayFriendsAnnotations()
        case 2:
            displayPersonalAnnotations()
        default:
            break
        }
    }
    
    
    
    func displayGlobalAnnotations() {
        print("public")
    }
    
    func displayFriendsAnnotations() {
        print("friends")
    }
    
    func displayPersonalAnnotations() {
        print("mine")
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
