//
//  CustomTimeSelector.swift
//  SNSProjectApp
//
//  Created by Yanran Qian on 12/8/18.
//

import Foundation
import UIKit

class CustomTimeSelector: UIViewController{
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    var selectedCategories: [UIButton] = []
    var json: [String: JSON] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nextButton.addTarget(self, action: #selector(CustomTimeSelector.save(sender:)), for: UIControl.Event.touchUpInside)
    }
    
    @objc func save(sender: UIButton) {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        
        
        let t = storyboard?.instantiateViewController(withIdentifier: "CustomTypeSelector") as! CustomTypeSelector
        
        t.startTime = fmt.string(from: self.startTimePicker.date)
        t.endTime = fmt.string(from: self.endTimePicker.date)
        t.selectedCategories = self.selectedCategories
        t.json = self.json
        
        
        navigationController?.pushViewController(t, animated: true)
    }
    @IBAction func skip(_ sender: Any) {
        let t = storyboard?.instantiateViewController(withIdentifier: "CustomTypeSelector") as! CustomTypeSelector
        
        t.startTime = ""
        t.endTime = ""
        t.selectedCategories = self.selectedCategories
        t.json = self.json
        
        print(self.selectedCategories)
        print(self.json)
        
        
        navigationController?.pushViewController(t, animated: true)
    }
    
    
}
