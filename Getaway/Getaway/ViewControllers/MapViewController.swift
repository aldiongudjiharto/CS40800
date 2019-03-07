//
//  MapViewController.swift
//  Getaway
//
//  Created by Avinash Singh on 08/02/19.
//  Copyright © 2019 Avinash Singh. All rights reserved.
//

import UIKit
import MapKit
import GooglePlaces


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
	
	override func viewDidAppear(_ animated: Bool) {
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
    
	@IBAction func addPlaceButtonClicked(_ sender: Any) {
		let autocompleteController = GMSAutocompleteViewController()
		autocompleteController.delegate = self
		
		// Specify the place data types to return.
		let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
			UInt(GMSPlaceField.placeID.rawValue) | UInt(GMSPlaceField.coordinate.rawValue) )!
		autocompleteController.placeFields = fields
		
		
		// Specify a filter.
		let filter = GMSAutocompleteFilter()
		filter.type = .city
		filter.type = .region
		
		autocompleteController.autocompleteFilter = filter
		
		// Display the autocomplete view controller.
		present(autocompleteController, animated: true, completion: nil)
	}
	
    
    func displayGlobalAnnotations() {
        print("public")
		FirebaseClient().retrieveAllUsersVisitedPlaces { (usersVisitedPlaces) in
			print("done with global users request")
			for visitedPlace in usersVisitedPlaces {
				print(visitedPlace)
				var place = visitedPlace.key
				var coordinate = visitedPlace.value
				self.addAnnotationUsingCoordinate(lat: coordinate.latitude, long: coordinate.longitude, title: place, subtitle: "Global User")
			}
		}
    }
    
    func displayFriendsAnnotations() {
        print("friends")
		FirebaseClient().retrieveCurrentUsersFriendsVisitedPlaces { (friendsVisitedPlaces) in
			
			print("done with friends request")
			for visitedPlace in friendsVisitedPlaces {
				print(visitedPlace)
				var place = visitedPlace.key
				var coordinate = visitedPlace.value
				self.addAnnotationUsingCoordinate(lat: coordinate.latitude, long: coordinate.longitude, title: place, subtitle: "Friend")
			}
		}
    }
    
    func displayPersonalAnnotations() {
        print("mine")
		
		FirebaseClient().retrieveCurrentUsersVisitedPlaces() { (visitedPlaces) in
			
				
				print("comes here for places")
				
				for visitedPlace in visitedPlaces {
					
					
					print(visitedPlace)
					var place = visitedPlace.key
					var coordinate = visitedPlace.value
					self.addAnnotationUsingCoordinate(lat: coordinate.latitude, long: coordinate.longitude, title: place, subtitle: "Mine")
				}
		}
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

extension MapViewController: GMSAutocompleteViewControllerDelegate {
	
	// Handle the user's selection.
	func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace){
		print("Place name: \(place.name)")
		print("Place ID: \(place.placeID)")
		print("Place attributions: \(place.attributions)")
		print("Place Coordinates \(place.coordinate)")
		
		
		
		
		FirebaseClient().addVisitedPlace(placeName: place.name!, coordinate: place.coordinate)
		
		mapView.setCenter(place.coordinate, animated: true)
		dismiss(animated: true, completion: nil)
	}
	
	func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
		// TODO: handle the error.
		print("Error: ", error.localizedDescription)
	}
	
	// User canceled the operation.
	func wasCancelled(_ viewController: GMSAutocompleteViewController) {
		dismiss(animated: true, completion: nil)
	}
	
	// Turn the network activity indicator on and off again.
	func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
	}
	
	func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = false
	}
	
}
