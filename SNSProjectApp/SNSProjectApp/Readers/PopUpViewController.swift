//
//  PopUpViewController.swift
//  SNSProjectApp
//
//  Created by Yanran Qian on 12/8/18.
//

import UIKit
import Alamofire

class PopUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closePopUp(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    
    @IBAction func Delete(_ sender: Any) {
        if(Login_vars.type == "reader"){
            let p: [String:String] = [
                "rid":Login_vars.id
            ]
            
            Alamofire.request(MyVariables.url + "/delete_reader", method: .post, parameters:p, encoding: URLEncoding.default)
                .responseData{ response in
                    
                    //Figure out how to set up table view
            }
        }
        else if(Login_vars.type == "publisher"){
            let p: [String:String] = [
                "pid":Login_vars.id
            ]
            
            Alamofire.request(MyVariables.url + "/delete_publisher", method: .post, parameters:p, encoding: URLEncoding.default)
                .responseData{ response in
                    
                    //Figure out how to set up table view
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


