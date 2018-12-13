//
//  PubSearchTimeViewController.swift
//  SNSProjectApp
//
//  Created by sphinx on 12/10/18.
//

import UIKit
import MapKit

class PubSearchTimeViewController: UIViewController {

    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    var selectedCategories: [UIButton] = []
    var json: [String: JSON] = [:]
    var searchedLoc: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("time")
        print(searchedLoc)
        
        nextButton.addTarget(self, action: #selector(CustomTimeSelector.save(sender:)), for: UIControl.Event.touchUpInside)
    }
    
    @objc func save(sender: UIButton) {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        
        
        let t = storyboard?.instantiateViewController(withIdentifier: "PubSearchTypeViewController") as! PubSearchTypeViewController
        
        t.startTime = fmt.string(from: self.startTimePicker.date)
        t.endTime = fmt.string(from: self.endTimePicker.date)
        t.selectedCategories = self.selectedCategories
        t.searchedLoc = searchedLoc
        t.json = self.json
        
        
        navigationController?.pushViewController(t, animated: true)
    }
    @IBAction func skip(_ sender: Any) {
        let t = storyboard?.instantiateViewController(withIdentifier: "PubSearchTypeViewController") as! PubSearchTypeViewController
        
        t.startTime = ""
        t.endTime = ""
        t.selectedCategories = self.selectedCategories
        t.json = self.json
        t.searchedLoc = searchedLoc
        
        print(self.selectedCategories)
        print(self.json)
        
        
        navigationController?.pushViewController(t, animated: true)
    }

}
