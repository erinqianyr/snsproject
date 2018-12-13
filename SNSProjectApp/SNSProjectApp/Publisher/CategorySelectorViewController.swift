//
//  CategorySelectorViewController.swift
//  SNSProjectApp
//
//  Created by Yanran Qian on 11/28/18.
//
import UIKit
import Foundation
import Alamofire

class CategorySelectorViewController: UIViewController, UITextFieldDelegate {
    
    var subjectField: String = ""
    var messageField: String = ""
    var longField: String = ""
    var latField: String = ""
    var rangeField: String = ""
    var startTimeField: Date = Date.init()
    var endTimeField: Date = Date.init()
    var imageData: String = ""
    
    
    var categories: [UIButton] = []
    var json: [String: JSON] = [:]
    

    @IBOutlet weak var publishButton: UIButton!
    @IBOutlet weak var myView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        get_Categories()
        
        //this section will be requesting the categories and setup each of them individually
//        SetupCategory(cat: "Myface")
//        SetupCategory(cat: "Mybody")
//        SetupCategory(cat: "This String")
//        SetupSubCategory(cat: "Myface")
//        SetupSubCategory(cat: "Mybody")
//        SetupSubCategory(cat: "This String")
//        SetupCategory(cat: "Myface")
//        SetupCategory(cat: "Mybody")
//        SetupCategory(cat: "This String")

        
        publishButton.addTarget(self, action: #selector(CategorySelectorViewController.publish(sender:)), for: UIControl.Event.touchUpInside)
    }
    
    @IBAction func refresh(_ sender: Any) {
        categories = []
        get_Categories()
    }
    func get_Categories(){
        Alamofire.request(MyVariables.url + "/categories", method: .get, encoding: URLEncoding.default)
            .responseData{ response in
            
                do{
                    let json = try JSON(data: response.data!)
                    print(json)
                    print(json["categories"])
                    print(json["subcategories"])
                    print(json["categories"].array!)
                    print(json["subcategories"].array!)
                    let cats = json["categories"].array!
                    let subs = json["subcategories"].array!
                    
                    for each in cats{
                        print(each["name"].stringValue)
                        self.SetupCategory(cat: each["name"].stringValue, tag1:-1)
                        for sub in subs{
                            if sub["cid"] == each["cid"] {
                                print(sub["name"].stringValue)
                                self.SetupSubCategory(cat: sub["name"].stringValue, tag1:sub["sid"].intValue)
                            }
                        }
                    }
                    
                    for cat in self.categories{
                        self.myView.addSubview(cat)
                    }
                    
                    self.json = json.dictionaryValue
                    
                }
                catch{
                    print("JSON broken")
                }
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
    func SetupCategory(cat: String, tag1: Int){
        let category = UIButton(frame: CGRect(x: 5, y: 100 + (categories.count) * 55, width:100 , height:50))
        category.setTitle(cat, for: .normal)
        category.backgroundColor = UIColor.blue
        category.addTarget(self, action: #selector(CategorySelectorViewController.isSelected(sender:)), for: UIControl.Event.touchUpInside)
        category.isSelected = false
        category.tag = tag1
        categories.append(category)
        
    }
    
    func SetupSubCategory(cat: String, tag1: Int){
        let category = UIButton(frame: CGRect(x: 30, y: 100 + (categories.count) * 55, width:100 , height:50))
        category.setTitle(cat, for: .normal)
        category.backgroundColor = UIColor.blue
        category.addTarget(self, action: #selector(CategorySelectorViewController.isSelected(sender:)), for: UIControl.Event.touchUpInside)
        category.isSelected = false
        category.tag = tag1
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
    
    @objc func publish(sender: UIButton) {
        var parameters: [String : Array<String>] = [:]
        
        print("in publish")
        for each in categories{
            if each.isSelected == true {
                
                for cat in (json["categories"]?.array!)!{
                    if cat["name"].stringValue == each.titleLabel!.text && parameters[cat["cid"].stringValue] == nil {
                        parameters[cat["cid"].stringValue] = []
                    }
                }
                
                for sub in (json["subcategories"]?.array)!{
                    //print(sub["name"])
                    if sub["sid"].intValue == each.tag && parameters[sub["cid"].stringValue] == nil {
                        parameters[sub["cid"].stringValue] = [sub["sid"].stringValue]
                    }
                    else if sub["sid"].stringValue == String(each.tag) && parameters[sub["cid"].stringValue] != nil {
                        parameters[sub["cid"].stringValue]!.append(sub["sid"].stringValue)
                    }
                }
            }
        }
        
        print(parameters)
        
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters)
        let JSONString = String(data: jsonData, encoding: String.Encoding.utf8)
        print(JSONString!)
        
        
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        
        print(subjectField)
        print(messageField)
        print(latField)
        print(longField)
        print(rangeField)
        print(fmt.string(from: startTimeField))
        print(fmt.string(from: endTimeField))
        
        // format: yyyy-mm-dd hh:mm:ss 24 hour format
        
        let p: [String: Any] = [
            "categories": JSONString!,
            "title":subjectField,
            "content":messageField,
            "pid": Login_vars.id,
            "lat":latField,
            "lon":longField,
            "mes_range":rangeField,
            "start_time": fmt.string(from: startTimeField),
            "end_time": fmt.string(from: endTimeField),
            "images":imageData
        ]
        
        //send with message.
        
        Alamofire.request(MyVariables.url + "/new_message", method: .post, parameters:p, encoding: URLEncoding.default)
            .responseData{ response in
                print(response)
        }
        
        
        
    }
    
    
    
}
