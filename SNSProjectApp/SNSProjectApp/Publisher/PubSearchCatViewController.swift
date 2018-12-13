//
//  PubSearchCatViewController.swift
//  SNSProjectApp
//
//  Created by sphinx on 12/10/18.
//

import UIKit
import MapKit
import Alamofire

class PubSearchCatViewController: UIViewController {

    var categories: [UIButton] = []
    var json: [String: JSON] = [:]
    var selectedCategories: [UIButton] = []
    var searchedLoc: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(searchedLoc)
        
        //this section will be requesting the categories and setup each of them individually
        get_Categories()
        for cat in categories{
            self.myView.addSubview(cat)
        }
        
    }
    
    func get_Categories(){
        Alamofire.request(MyVariables.url + "/categories", method: .get, encoding: URLEncoding.default)
            .responseData{ response in
                
                do{
                    let json = try JSON(data: response.data!)
                    
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
    
    @IBAction func next(_ sender: Any) {
        getSelected()
        let t = storyboard?.instantiateViewController(withIdentifier: "PubSearchTimeViewController") as! PubSearchTimeViewController
        
        t.selectedCategories = self.selectedCategories
        t.json = self.json
        t.searchedLoc = searchedLoc
        
        navigationController?.pushViewController(t, animated: true)
        
    }
    
    func getSelected(){
        var parameters: [String : Array<String>] = [:]
        
        for each in categories{
            if each.isSelected == true {
                selectedCategories.append(each)
                
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
    }

}
