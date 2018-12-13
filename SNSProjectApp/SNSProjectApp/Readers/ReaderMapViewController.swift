//
//  ReaderMapViewController.swift
//  SNSProjectApp
//
//  Created by Yanran Qian on 12/8/18.
//

import Foundation
import UIKit
import MapKit

class ReaderMapViewController: UIViewController, UISearchBarDelegate{
    
    private let locationManager = CLLocationManager()
    public var currentCoordinate : CLLocationCoordinate2D?
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var searchBarMap: UISearchBar!
    
    var searchedLoc: CLLocationCoordinate2D = CLLocationCoordinate2D()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarMap.delegate = self
        configureLocationServices()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tripleTapped))
        tap.numberOfTapsRequired = 3
        mapView.addGestureRecognizer(tap)
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
                
                self.searchedLoc = annotation.coordinate
            }
            else {print (error?.localizedDescription ?? "error")}
        }
    }

    private func configureLocationServices() {
        locationManager.delegate = self as? CLLocationManagerDelegate
        
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
    
    @IBAction func send_loc(_ sender: Any) {
        let t = storyboard?.instantiateViewController(withIdentifier: "CustomLocationMessages") as! CustomLocationMessages
        
        t.searchedLoc = searchedLoc
        navigationController?.pushViewController(t, animated: true)
    }
    
    @objc func tripleTapped(gestureReconizer: UITapGestureRecognizer) {
        let annotation = MKPointAnnotation()
        let touchLocation = gestureReconizer.location(in: mapView)
        let locationCoordinate = mapView.convert(touchLocation,toCoordinateFrom: mapView)
        annotation.coordinate = locationCoordinate
        annotation.title = "Lat: \(locationCoordinate.latitude),   Long: \(locationCoordinate.longitude)"
        print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
        
        self.mapView.addAnnotation(annotation)
        self.mapView.selectAnnotation(annotation, animated: true)
        
        self.searchedLoc = annotation.coordinate
        
        return
    }
    
    public func buttonPress(){
//        let loc = storyboard?.instantiateViewController(withIdentifier: "CustomLocationMessages") as! CustomLocationMessages
//        
//        loc.lat = annotation.coordinate.lat
//        loc.long = annotation.coordinate.long
//        
//        navigationController?.pushViewController(message, animated: true)
    }
}
