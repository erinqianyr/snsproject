//
//  ReaderViewController.swift
//  SNSProjectApp
//
//  Created by Yanran Qian on 12/8/18.
//

import Foundation
import UIKit
import MapKit
import Alamofire

var messageTitles: [String] = []
var messageContents: [String] = []
var messageMID: [String] = []
var myIndex = 0
var gotData = false

class ReaderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var printButton: UIButton!
    @IBOutlet weak var deleteAccountButton: UIButton!
    
    //var mapView: MKMapView
    
    private let locationManager = CLLocationManager()
    public var currentCoordinate : CLLocationCoordinate2D?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        configureLocationServices()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            //mapView.showsUserLocation = true
        }
        else{
            print("Location NOT ON!!!")
        }
        
        print(locationManager.requestLocation())
        
        currentCoordinate = locationManager.location?.coordinate
        print(currentCoordinate)
        
        if (gotData == false) {
            getData()
            gotData = true
        }
        
        printButton.addTarget(self, action: #selector(ReaderViewController.printMessages(sender:)), for: UIControl.Event.touchUpInside)
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Swift.Error) {
        print("error:: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("didChangeAuthorization")
        if status == CLAuthorizationStatus.authorizedWhenInUse
            || status == CLAuthorizationStatus.authorizedAlways {
            locationManager.requestLocation()
        }
        else{
            //other procedures when location service is not permitted.
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Did update location called")
        //        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        //        print("locations = \(locValue.latitude) \(locValue.longitude)")
        if locations.first != nil {
            print("location:: (location)")
        }
    }

    func getData (){
        let p: [String:Any] = [
            "lat": Float(currentCoordinate!.latitude),
            "lon": Float(currentCoordinate!.longitude),
            "rid": Login_vars.id
        ]
        
        
        Alamofire.request(MyVariables.url + "/at_location", method: .post, parameters:p, encoding: URLEncoding.default)
            .responseData{ response in
                messageTitles = []
                messageContents = []
                messageMID =  []
                
                print(response)
                print(response.data!)
                
                do{
                    let json = try JSON(data: response.data!)
                    let messages = json.array!
                    for each in messages{
                            messageMID.append(each["mid"].stringValue)
                        messageTitles.append(each["title"].stringValue)
                        messageContents.append(each["content"].stringValue)
                        print(each["title"].stringValue)
                    }
                }
                catch{
                    print("getData get JSON Failed")
                }
                
                self.tableView.reloadData()
        }
    }
    
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageTitles.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = messageTitles[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        performSegue(withIdentifier: "segue", sender: self)
    }
    
    private func configureLocationServices() {
        //locationManager.delegate = self as? CLLocationManagerDelegate
        
        let status = CLLocationManager.authorizationStatus()
        
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if status == .authorizedAlways || status == .authorizedWhenInUse {
            beginLocationUpdates(locationManager: locationManager)
        }
        
    }
    
    public func beginLocationUpdates (locationManager:CLLocationManager) {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    @objc func printMessages(sender: UIButton) {
        //messageTitles = []
        //messageContents = []
        //messageMID = []
        
        //myIndex = 0
        
        getData()
        print("messageTitles")
        print(messageTitles)
        tableView.reloadData()
        
    }
    
    @IBAction func showPopUp(_ sender: Any) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpID") as! PopUpViewController
        self.addChild(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }
    
}

