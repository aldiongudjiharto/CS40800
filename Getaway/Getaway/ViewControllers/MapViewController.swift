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
	var color: UIColor
	init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, color: UIColor) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
		self.color = color
    }
}

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapSelectionSegmentedControl: UISegmentedControl!
    @IBOutlet weak var mapView: MKMapView!
    
    
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        locationManager.delegate = self
        mapView.delegate = self
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
	
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		
		var annotationView = MKMarkerAnnotationView()
		
		guard let annotation = annotation as? LocationAnnotation else {return nil}
		
		
		var color = annotation.color
		
		
		if let locationAnnotation = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) as? MKMarkerAnnotationView{
			locationAnnotation.animatesWhenAdded = true
			locationAnnotation.titleVisibility = .adaptive
			locationAnnotation.subtitleVisibility = .adaptive
			locationAnnotation.markerTintColor = color
			
			return locationAnnotation
		}
		
		return nil
	}
	
	
    
    func updateAnnotations() {
        removeAllAnnotations()
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
				var place = visitedPlace.placeName
				var coordinate = visitedPlace.coordinates
				
				FirebaseClient().userAreFriends(friendId: visitedPlace.userID, completion: { (isFriend) in
					
					if isFriend {
						self.addAnnotationUsingCoordinate(lat: coordinate.latitude, long: coordinate.longitude, title: place, subtitle: visitedPlace.userName, color: UIColor.yellow)
					}
					else{
						self.addAnnotationUsingCoordinate(lat: coordinate.latitude, long: coordinate.longitude, title: place, subtitle: visitedPlace.userName, color: UIColor.red)
					}
				})
				
				
			}
		}
    }
    
    func displayFriendsAnnotations() {
        print("friends")
		FirebaseClient().retrieveCurrentUsersFriendsVisitedPlaces { (friendsVisitedPlaces) in
			
			print("done with friends request")
			for visitedPlace in friendsVisitedPlaces {
				var place = visitedPlace.placeName
				var coordinate = visitedPlace.coordinates
				self.addAnnotationUsingCoordinate(lat: coordinate.latitude, long: coordinate.longitude, title: place, subtitle: visitedPlace.userName, color: UIColor.yellow)
			}
		}
    }
    
    func displayPersonalAnnotations() {
        print("mine")
		
		FirebaseClient().retrieveCurrentUsersVisitedPlaces() { (visitedPlaces) in
			
				
				print("comes here for places")
				
				for visitedPlace in visitedPlaces {

					print(visitedPlace)
					var place = visitedPlace.placeName
					var coordinate = visitedPlace.coordinates
					self.addAnnotationUsingCoordinate(lat: coordinate.latitude, long: coordinate.longitude, title: place, subtitle: visitedPlace.userName, color: UIColor.blue)
				}
		}
    }
    
    func removeAllAnnotations() {
        let annotations = mapView.annotations.filter {
            $0 !== self.mapView.userLocation
        }
        mapView.removeAnnotations(annotations)
    }
    
    
	func addAnnotationUsingCoordinate(lat : CLLocationDegrees, long : CLLocationDegrees, title: String?, subtitle: String?, color: UIColor){
        
  
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
		let annotation = LocationAnnotation(coordinate: coordinate, title: title, subtitle: subtitle, color: color)
		
        mapView.addAnnotation(annotation)
        
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
