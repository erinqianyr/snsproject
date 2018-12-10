//
//  LoginViewController.swift
//  SNSProjectApp
//
//  Created by sphinx on 11/14/18.
//

import UIKit
import Alamofire

struct Login_vars {
    static var id = ""
    static var type = ""
}

class LoginViewController: UIViewController {

    @IBOutlet weak var User_Name: UITextField!
    @IBOutlet weak var Login_Password: UITextField!
    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var Login_Button: UIButton!
    
    // fix this init????????
    var type:String!
    var id:String!
    //var delegate: AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Label.text = ""
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
         view.addGestureRecognizer(tap)
        
         setupAddTargetIsNotEmptyTextFields()
        
        // Do any additional setup after loading the view.
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func setupAddTargetIsNotEmptyTextFields() {
        Login_Button.isHidden = true //hidden okButton
        User_Name.addTarget(self, action: #selector(textFieldsIsNotEmpty),
                                    for: .editingChanged)
        Login_Password.addTarget(self, action: #selector(textFieldsIsNotEmpty),
                                     for: .editingChanged)
    }
    
    @objc func textFieldsIsNotEmpty(sender: UITextField) {
        
        sender.text = sender.text?.trimmingCharacters(in: .whitespaces)
        
        guard
            let name = User_Name.text, !name.isEmpty,
            let password = Login_Password.text, !password.isEmpty
        else
        {
            self.Login_Button.isHidden = true
            return
        }
        
        // enable okButton if all conditions are met
        Login_Button.isHidden = false
    }
    
    @IBAction func loginButtonPress(_ sender: Any) {

        let parameters: [String: Any] = [
            "name": User_Name.text!,
            "password": Login_Password.text!.sha256()
            
        ]

        Alamofire.request(MyVariables.url + "/login", method: .post, parameters: parameters).responseData{
            response in
            
            print(response)
            print(response.request)
            print(response.value)
            print(response.result)
            print(response.response?.allHeaderFields)
            print(String(data: response.data!, encoding: String.Encoding.utf8)!)
            
            //TODO check failcase
            switch response.result {
            case .success:
                if(String(data: response.data!, encoding: String.Encoding.utf8)! == "Unauthorized"){
                    self.Label.text = "incorrect username/password"
                }
                else{
                    let id1 = response.response?.allHeaderFields["id"] as! String
                    let type1 = response.response?.allHeaderFields["type"] as! String

                    print("id1:" + id1)
                    print("type1:" + type1)

                    self.id = id1
                    self.type = type1

                    print("self.id:"+self.id)
                    print("self.type:"+self.type)

                    Login_vars.id = id1
                    Login_vars.type = type1

                    if(type1 == "reader"){
                        let next = self.storyboard?.instantiateViewController(withIdentifier: "ReaderViewController") as! ReaderViewController
                        self.navigationController?.pushViewController(next, animated: true)
                    }
                    if(type1 == "publisher"){
//                         let next = self.storyboard?.instantiateViewController(withIdentifier: "AllMessagesTableViewController") as! AllMessagesTableViewController
                        let next = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                        self.navigationController?.pushViewController(next, animated: true)
                    }
                }
                
            
            case .failure(_):
                print("failed")
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        //or
        //self.view.endEditing(true)
        return true
    }

}
