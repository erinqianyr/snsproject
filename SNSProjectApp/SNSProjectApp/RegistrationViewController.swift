//
//  RegistrationViewController.swift
//  SNSProjectApp
//
//  Created by sphinx on 11/14/18.
//

import UIKit
import MessageUI
import Alamofire


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
        if(Name_Field != nil){
            let parameters: [String: Any] = [
                "name": Name_Field.text!,
                "address": Address_Field.text!,
                "email": Email_Field.text!,
                "password": [Password_Field.text!,"jdskfjakls","kjsdakf"]
            ]
        
            Alamofire.request(MyVariables.url + "/new_reader", method: .post, parameters: parameters as Parameters).responseJSON{
                response in
                switch response.result {
                case .success:
                    print(response)
                case .failure(let error):
                    print("fail")
                    print(error)
                    //failure(0,"Error")
                }
            }
        }
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
