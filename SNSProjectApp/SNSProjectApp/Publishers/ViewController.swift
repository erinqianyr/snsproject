//
//  ViewController.swift
//  SNSProjectApp
//
//  Created by Yanran Qian on 9/29/18.
//
//

import UIKit
import MapKit

class ViewController: UIViewController, UISearchBarDelegate,UIGestureRecognizerDelegate {
    
    private let locationManager = CLLocationManager()
    public var currentCoordinate : CLLocationCoordinate2D?

    @IBOutlet var searchBarMap: UISearchBar!
        
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarMap.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        configureLocationServices()
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBarMap.resignFirstResponder()
        let geocoder = CLGeocoder()
        let annotation = MKPointAnnotation()
        geocoder.geocodeAddressString(searchBarMap.text!) { (placemarks:[CLPlacemark]?,error:Error?) in
            if error == nil{
                let placemark = placemarks?.first
                annotation.coordinate = (placemark?.location?.coordinate)!
                annotation.title = self.searchBarMap.text!
                
                let span = MKCoordinateSpan.init(latitudeDelta: 0.075, longitudeDelta: 0.075)
                let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
                
                self.mapView.setRegion(region, animated: true)
                self.mapView.addAnnotation(annotation)
                self.mapView.selectAnnotation(annotation, animated: true)
            }
            else {print (error?.localizedDescription ?? "error")}
        }
    }
    
    private func configureLocationServices() {
        locationManager.delegate = self
        
        let status = CLLocationManager.authorizationStatus()
        
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if status == .authorizedAlways || status == .authorizedWhenInUse {
            beginLocationUpdates(locationManager: locationManager)
        }
    }
    
    public func beginLocationUpdates (locationManager:CLLocationManager) {
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    public func zoomToLatestLocation(with coordinate: CLLocationCoordinate2D) {
        
        let zoomRegion = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(zoomRegion, animated: true)
    }
    
    /*
    func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        let annotation = MKPointAnnotation()
        if gestureReconizer.state != UIGestureRecognizerState.ended {
            let touchLocation = gestureReconizer.location(in: mapView)
            let locationCoordinate = mapView.convert(touchLocation,toCoordinateFrom: mapView)
            annotation.coordinate = locationCoordinate
            annotation.title = "\(locationCoordinate.latitude) long: \(locationCoordinate.longitude)"
            print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
            return
        }
        if gestureReconizer.state != UIGestureRecognizerState.began {
            return
        }
    }
    */
    
    
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else {return}
        
        if currentCoordinate == nil {
            zoomToLatestLocation(with:latestLocation.coordinate)
        }
        currentCoordinate = latestLocation.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            beginLocationUpdates(locationManager: manager)
        }
    }
    
}

