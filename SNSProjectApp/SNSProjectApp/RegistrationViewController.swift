//
//  RegistrationViewController.swift
//  SNSProjectApp
//
//  Created by sphinx on 11/14/18.
//

import UIKit
import MessageUI

class RegistrationViewController: UIViewController, MFMailComposeViewControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var Name_Field: UITextField!
    @IBOutlet weak var Address_Field: UITextField!
    @IBOutlet weak var Email_Field: UITextField!
    @IBOutlet weak var Password_Field: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.Name_Field.delegate = self
        self.Address_Field.delegate = self
        self.Email_Field.delegate = self
        self.Password_Field.delegate = self
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    

    @IBAction func buttonPressed(_ sender: Any) {
        print("You clicked the button")
        
        //checkFields
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
        sendEmail()
        
    }
    
    
    func sendEmail() {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        // Configure the fields of the interface.
        composeVC.setToRecipients([Email_Field.text!])
        composeVC.setSubject("SNSProject testing")
        composeVC.setMessageBody("Hello this is my message body! \n The message was sent", isHTML: false)
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check the result or perform other tasks.
        
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
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
