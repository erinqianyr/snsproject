//
//  NewCategoryViewController.swift
//  SNSProjectApp
//
//  Created by Yanran Qian on 12/6/18.
//

import Foundation
import UIKit
import Alamofire

class NewCategoryViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    @IBOutlet weak var addCategory: UITextField!
    @IBOutlet weak var addCategoryButton: UIButton!
    @IBOutlet weak var viewCategory: UIButton!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var addSubCategory: UITextField!
    @IBOutlet weak var addSubCategoryButton: UIButton!
    

    
    var categories: [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addCategory.delegate = self
        self.addSubCategory.delegate = self
        
        addCategoryButton.addTarget(self, action: #selector(NewCategoryViewController.addCategory(sender:)), for: UIControl.Event.touchUpInside)
        
        addSubCategoryButton.addTarget(self, action: #selector(NewCategoryViewController.addSubCategory(sender:)), for: UIControl.Event.touchUpInside)
        
        viewCategory.addTarget(self, action: #selector(NewCategoryViewController.showCategory(sender:)), for: UIControl.Event.touchUpInside)
    }
    
        
    @objc func addCategory(sender: UIButton){
        //TODO check
        Alamofire.request(MyVariables.url + "/categories", method: .get, encoding: URLEncoding.default)
            .responseData {
                response in
                do{
                    let json = try JSON(data: response.data!)
                    let cats = json["categories"].array!
                    for each in cats{
                        if(each["name"].stringValue == self.addCategory.text!){
                            return;
                        }
                    }
                }
                catch{
                    print("addCategory get JSON Failed")
                }
        }
                        
        
        let parameters: [String:Any] = [
            "New_Cat": addCategory.text!
        ]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters)
        let JSONString = String(data: jsonData, encoding: String.Encoding.utf8)
        print(JSONString!)
        let p: [String: Any] = [
            "categories": JSONString!,
        ]
        
        Alamofire.request(MyVariables.url + "/new_cat", method: .post, parameters: p, encoding: URLEncoding.default)
            .responseData { response in
                print(response)
        }
    }
    
    @objc func addSubCategory(sender: UIButton){
         //TODO check
        Alamofire.request(MyVariables.url + "/categories", method: .get, encoding: URLEncoding.default)
            .responseData {
                response in
                do{
                    let json = try JSON(data: response.data!)
                    let cats = json["categories"].array!
                    for each in cats{
                        if(each["name"].stringValue == self.addCategory.text!){ //Change to selected Category
                            break;
                        }
                        return;
                    }
                }
                catch{
                    print("addCategory get JSON Failed")
                }
                
        }
        
        
        let parameters: [String:Any] = [
            "New_Sub": addSubCategory.text!
        ]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters)
        let JSONString = String(data: jsonData, encoding: String.Encoding.utf8)
        print(JSONString!)
        let p: [String: Any] = [
            "Subcategories": JSONString!,
        ]
        
        Alamofire.request(MyVariables.url + "/new_sub", method: .post, parameters: p, encoding: URLEncoding.default)
            .responseData { response in
                print(response)
        }
    }
    
    @objc func showCategory(sender: UIButton){
        //request and show all subcategories in scroll view
        //this section will be requesting the categories and setup each of them individually
        SetupCategory(cat: "Myface")
        SetupCategory(cat: "Mybody")
        SetupCategory(cat: "This String")
        SetupCategory(cat: "Myface")
        SetupCategory(cat: "Mybody")
        SetupCategory(cat: "This String")
        SetupCategory(cat: "Myface")
        SetupCategory(cat: "Mybody")
        SetupCategory(cat: "This String")
        for cat in categories{
            self.myView.addSubview(cat)
        }
        
    }
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
        
        //hide keyboard when touch outside of keybar
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //use this to manually add category buttons
    func SetupCategory(cat: String){
        let category = UIButton(frame: CGRect(x: 5, y: 100 + (categories.count) * 55, width:100 , height:50))
        category.setTitle(cat, for: .normal)
        category.backgroundColor = UIColor.blue
        category.addTarget(self, action: #selector(CategorySelectorViewController.isSelected(sender:)), for: UIControl.Event.touchUpInside)
        category.isSelected = false
        categories.append(category)
        
    }
    
    @objc func isSelected(sender: UIButton){
        sender.isSelected = !sender.isSelected
        if(sender.isSelected){
            sender.backgroundColor = UIColor.green
        }else{
            sender.backgroundColor = UIColor.blue
        }
    }
    
    
}
