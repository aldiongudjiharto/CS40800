//
//  MapViewController.swift
//  Getaway
//
//  Created by Avinash Singh on 08/02/19.
//  Copyright © 2019 Avinash Singh. All rights reserved.
//

import UIKit
import MapKit


final class LocationAnnotation: NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}

class MapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapSelectionSegmentedControl: UISegmentedControl!
    @IBOutlet weak var mapView: MKMapView!
    
    
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        locationManager.delegate = self
        
        mapView.showsUserLocation = true
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
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
        removeAllAnnotations()
        switch mapSelectionSegmentedControl.selectedSegmentIndex {
        case 0:
            displayGlobalAnnotations()
            displayFriendsAnnotations()
            displayPersonalAnnotations()
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
        addAnnotationUsingCoordinate(lat: 22.5726, long: 88.3639, title: "Kolkata", subtitle: "GlobalUser1")
        addAnnotationUsingCoordinate(lat: 28.7041, long: 77.1025, title: "Delhi", subtitle: "GlobalUser2")
    }
    
    func displayFriendsAnnotations() {
        print("friends")
        addAnnotationUsingCoordinate(lat: 40.4637, long: 3.7492, title: "Spain", subtitle: "FriendUser1")
        addAnnotationUsingCoordinate(lat: 40.2672, long: -86.1349, title: "Indiana", subtitle: "FriendUser2")
    }
    
    func displayPersonalAnnotations() {
        print("mine")
        
        addAnnotationUsingCoordinate(lat: 37.3688, long: -122.0363, title: "Sunnyvale", subtitle: "Personal")

    }
    
    func removeAllAnnotations() {
        let annotations = mapView.annotations.filter {
            $0 !== self.mapView.userLocation
        }
        mapView.removeAnnotations(annotations)
    }
    
    
    func addAnnotationUsingCoordinate(lat : CLLocationDegrees, long : CLLocationDegrees, title: String?, subtitle: String?){
        
  
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let annotation = LocationAnnotation(coordinate: coordinate, title: title, subtitle: subtitle)
        
        mapView.addAnnotation(annotation)
        
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

extension MapViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let locationAnnotation = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) as? MKMarkerAnnotationView{
            locationAnnotation.animatesWhenAdded = true
            locationAnnotation.titleVisibility = .adaptive
            locationAnnotation.subtitleVisibility = .adaptive
       
            return locationAnnotation
        }
        
        return nil
    }
}

