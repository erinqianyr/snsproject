//
//  RegistrationViewController.swift
//  SNSProjectApp
//
//  Created by sphinx on 11/14/18.
//

import UIKit
import MessageUI
import Alamofire


class RegistrationViewController: UIViewController, MFMailComposeViewControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var Name_Field: UITextField!
    @IBOutlet weak var Address_Field: UITextField!
    @IBOutlet weak var Email_Field: UITextField!
    @IBOutlet weak var Password_Field: UITextField!
    
    @IBOutlet weak var User_Type: UIPickerView!
    @IBOutlet weak var next_button: UIButton!
    
    var pickerData: [String] = [String]()
    var selected = 0;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        self.User_Type.delegate = self
        self.User_Type.dataSource = self
        
        pickerData = ["Reader", "Publisher"]
    
        
        // Do any additional setup after loading the view.
        
        self.Name_Field.delegate = self
        self.Address_Field.delegate = self
        self.Email_Field.delegate = self
        self.Password_Field.delegate = self
        
        setupAddTargetIsNotEmptyTextFields()
        
    }
    
    func setupAddTargetIsNotEmptyTextFields() {
        next_button.isHidden = true //hidden okButton
        Name_Field.addTarget(self, action: #selector(textFieldsIsNotEmpty),
                                    for: .editingChanged)
        Email_Field.addTarget(self, action: #selector(textFieldsIsNotEmpty),
                                     for: .editingChanged)
        Address_Field.addTarget(self, action: #selector(textFieldsIsNotEmpty),
                                        for: .editingChanged)
        Password_Field.addTarget(self, action: #selector(textFieldsIsNotEmpty),
                                              for: .editingChanged)
    }
    
    @objc func textFieldsIsNotEmpty(sender: UITextField) {
        
        sender.text = sender.text?.trimmingCharacters(in: .whitespaces)
        
        guard
            let name = Name_Field.text, !name.isEmpty,
            let email = Email_Field.text, !email.isEmpty,
            let address = Address_Field.text, !address.isEmpty,
            let password = Password_Field.text, !password.isEmpty
            else
        {
            self.next_button.isHidden = true
            return
        }
        // enable okButton if all conditions are met
        next_button.isHidden = false
    }

    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    

    @IBAction func buttonPressed(_ sender: Any) {
        print("You clicked the button")
        
        let parameters: [String: Any] = [
            "name": Name_Field.text!,
            "address": Address_Field.text!,
            "email": Email_Field.text!,
            "password": Password_Field.text!.sha256()
        ]
        
        print(selected)
        
        if(selected == 0){
            Alamofire.request(MyVariables.url + "/new_reader", method: .post, parameters: parameters as Parameters).responseData{
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
        if(selected == 1){
            Alamofire.request(MyVariables.url + "/new_publisher", method: .post, parameters: parameters as Parameters).responseData{
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int)-> Int {
        return pickerData.count
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int)-> String? {
        return pickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        selected = row
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


