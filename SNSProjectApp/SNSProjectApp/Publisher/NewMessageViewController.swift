//
//  NewMessageViewController.swift
//  SNSProjectApp
//
//  Created by Yanran Qian on 11/28/18.
//

import UIKit


class NewMessageViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    @IBOutlet weak var subjectField: UITextField!
    @IBOutlet weak var messageField: UITextView!
    
    @IBOutlet weak var rangeField: UITextField!
    @IBOutlet weak var startTimeField: UIDatePicker!
    @IBOutlet weak var endTimeField: UIDatePicker!
    @IBOutlet weak var nextButton: UIButton!
    
    var longField: String = ""
    var latField: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.subjectField.delegate = self
        self.messageField.delegate = self
        //self.longField.delegate = self
        //self.latField.delegate = self
        self.rangeField.delegate = self
        
        nextButton.addTarget(self, action: #selector(NewMessageViewController.saveInfoEntered(sender:)), for: UIControl.Event.touchUpInside)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textViewShouldReturn(_ textView: UITextView) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //hide keyboard when touch outside of keybar
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func saveInfoEntered(sender:UIButton) {
        let message = storyboard?.instantiateViewController(withIdentifier: "AddMultiMedia") as! AddMultiMedia
        
        var start = startTimeField.calendar!
        var end = endTimeField.calendar!
        
        start.timeZone = TimeZone(abbreviation: "EST")!
        end.timeZone = TimeZone(abbreviation: "EST")!
        
        message.subjectField = self.subjectField.text!
        message.messageField = self.messageField.text!
        message.longField = self.longField
        message.latField = self.latField
        message.rangeField = self.rangeField.text!
        message.endTimeField = endTimeField.date
        message.startTimeField = startTimeField.date
       
        navigationController?.pushViewController(message, animated: true)
        
    }
    
}
