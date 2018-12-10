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
    
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var addSubCategory: UITextField!
    @IBOutlet weak var addSubCategoryButton: UIButton!
    

    @IBOutlet weak var Category_for_Sub: UITextField!
    @IBOutlet weak var Label_New_Cat: UILabel!
    @IBOutlet weak var Label_New_Sub: UILabel!
    
    var categories: [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addCategory.delegate = self
        self.addSubCategory.delegate = self
        
        Label_New_Cat.text = ""
        Label_New_Sub.text = ""
        
        addCategoryButton.addTarget(self, action: #selector(NewCategoryViewController.addCategory(sender:)), for: UIControl.Event.touchUpInside)
        
        addSubCategoryButton.addTarget(self, action: #selector(NewCategoryViewController.addSubCategory(sender:)), for: UIControl.Event.touchUpInside)
        
        
    }
    
        
    @objc func addCategory(sender: UIButton){
        //TODO check
        self.Label_New_Cat.text = ""
        Alamofire.request(MyVariables.url + "/categories", method: .get, encoding: URLEncoding.default)
            .responseData {
                response in
                do{
                    let json = try JSON(data: response.data!)
                    let cats = json["categories"].array!
                    for each in cats{
                        if(each["name"].stringValue == self.addCategory.text!){
                            self.Label_New_Cat.text = "Category already exists"
                            return
                        }
                    }
                }
                catch{
                    print("getCategory get JSON Failed")
                }
        
        
            let p: [String: Any] = [
                "new_category": self.addCategory.text!,
            ]
            
            Alamofire.request(MyVariables.url + "/new_category", method: .post, parameters: p, encoding: URLEncoding.default)
                .responseData { response in
                    print(response)
            }
        }
    }
    
    @objc func addSubCategory(sender: UIButton){
         //TODO check
        self.Label_New_Sub.text = ""
        var cat_id = "-1"
        Alamofire.request(MyVariables.url + "/categories", method: .get, encoding: URLEncoding.default)
            .responseData {
                response in
                do{
                    let json = try JSON(data: response.data!)
                    let cats = json["categories"].array!
                    for each in cats{
                        if(each["name"].stringValue == self.Category_for_Sub.text!){ //Change to selected Category
                            cat_id = each["cid"].stringValue
                            print(cat_id)
                        }
                    }
                    if(cat_id == "-1"){
                        self.Label_New_Sub.text = "Category does not exist"
                        return
                    }
                }
                catch{
                    print("addCategory get JSON Failed")
                }

        

            let p: [String: Any] = [
                "new_subcategory": self.addSubCategory.text!,
                "cid": cat_id,
            ]
            
            Alamofire.request(MyVariables.url + "/new_subcategory", method: .post, parameters: p, encoding: URLEncoding.default)
                .responseData { response in
                    print(response)
            }
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
