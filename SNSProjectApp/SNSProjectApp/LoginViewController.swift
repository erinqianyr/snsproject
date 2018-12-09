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
    
    // fix this init????????
    var type:String!
    var id:String!
    //var delegate: AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Label.text = ""
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
         view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func loginButtonPress(_ sender: Any) {

        let parameters: [String: Any] = [
            "name": User_Name.text!,
            "password": Login_Password.text!
            
        ]

        Alamofire.request(MyVariables.url + "/login", method: .post, parameters: parameters).responseData{
            response in
            
            
            //TODO check failcase
            //switch response.result {
            //case .success:
            
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
                     let next = self.storyboard?.instantiateViewController(withIdentifier: "AllMessagesTableViewController") as! AllMessagesTableViewController
                    self.navigationController?.pushViewController(next, animated: true)
                }
            
            
            //case response.result == "501":
                self.Label.text = "incorrect username/password"
            
            
            //case .failure(Error):
            //    print("failed")
            //}
            
            // open next view controller with parameters
            
            
        }
            
            
            
//            response in
//
//            print("request")
//            print(response.request)
//            print("response")
//            print(response.response)
//            print("data")
//            print(response.data)
//            print("result")
//            print(response.result)
//
//            //debugPrint(response)
//            do{
//                var json = try JSON(data: response.data!)
//                print(json["id"][0])
//                print(json["type"][0])
//
//                self.id = json["id"][0].int
//                self.type = json["type"][0].string
//            }
//            catch{
//                print("JSON broken")
//            }
//
//        }
    }
    
    @IBAction func Send_Cat(_ sender: Any) {
       
        /*let parameters: [String: Any] = [
            "map":[
                "beach": ["fun", "sand", "wet"],
                "snow": ["winter","Xmas","white"],
                "TV": ["shows","bad", "great","critic"]
            ]
        ]
        
        do {
            
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
            print(jsonData)
            print(decoded)
        }
        catch{
            print(error.localizedDescription)
        }
        
        
        
       Alamofire.request(MyVariables.url + "/test_input", method: .post, parameters: parameters as Parameters).responseJSON{
            response in
            switch response.result {
            case .success:
                print(response)
                break
            case .failure(let error):
                print("fail")
                print(error)
                //failure(0,"Error")
            }
        }*/
        let new_map: [String:Any] = [
            "cat1": ["IdQuestion", "IdProposition", "Time"]
        ]
        let int_map: [Int:Any] = [
            1: [1,2,3,4,5,6]
        ]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: new_map)
        let JSONString = String(data: jsonData, encoding: String.Encoding.utf8)
        print(JSONString!)
        let p: [String: Any] = [
            "categories": JSONString!,
            "anything_in_the_world": "happy"
        ]
        
        
        
        Alamofire.request(MyVariables.url + "/test_input", method: .post, parameters: p, encoding: URLEncoding.default)
            .responseData { response in
                print(response)
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        //or
        //self.view.endEditing(true)
        return true
    }

}
