//
//  ReaderViewController.swift
//  SNSProjectApp
//
//  Created by Yanran Qian on 12/8/18.
//

import Foundation
import UIKit
import MapKit

class ReaderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var deleteAccountButton: UIButton!
    
    private let locationManager = CLLocationManager()
    public var currentCoordinate : CLLocationCoordinate2D?
    
    let data = ["1", "2", "3", "4"]
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //get current location--todo
        //make a request
        configureLocationServices()
        
        deleteAccountButton.addTarget(self, action: #selector(ReaderViewController.alert(sender:)), for: UIControl.Event.touchUpInside)
        
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
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    @objc func alert(sender: UIButton) {
        
    }
    
    @IBAction func showPopUp(_ sender: Any) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpID") as! PopUpViewController
        self.addChild(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }
    
}

