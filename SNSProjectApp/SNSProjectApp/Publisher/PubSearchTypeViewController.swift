//
//  PubSearchTypeViewController.swift
//  SNSProjectApp
//
//  Created by sphinx on 12/10/18.
//

import UIKit
import MapKit
import Alamofire

var messageTitles5: [String] = []
var messageContents5: [String] = []
var messageMID5: [String] = []
var myIndex5 = 0

class PubSearchTypeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var showActive: UIButton!
    @IBOutlet weak var showArchived: UIButton!
    
    @objc func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageTitles5.count
    }
    
    @objc func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = messageTitles5[indexPath.row]
        return cell
    }
    
    @objc func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex5 = indexPath.row
        performSegue(withIdentifier: "segue", sender: self)
    }
    
    @objc func printMessages(sender: UIButton) {
        tableView.reloadData()
    }
    
    var selectedCategories: [UIButton] = []
    var startTime: String = ""
    var endTime: String = ""
    var json: [String: JSON] = [:]
    var searchedLoc: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showActive.addTarget(self, action: #selector(CustomTypeSelector.printMessages(sender:)), for: UIControl.Event.touchUpInside)
        showArchived.addTarget(self, action: #selector(CustomTypeSelector.printMessages(sender:)), for: UIControl.Event.touchUpInside)
        
        //when they click button, need to check if i have data for either categories or times
    }
    
    @IBAction func active_button(_ sender: Any) {
        print("acti")
        print(selectedCategories)
        print(json)
        print(startTime)
        print(endTime)
        if(json == [:] && startTime != ""){
            let p: [String: Any] = [
                "type": "active",
                "rid":Login_vars.id,
                "start_time": startTime,
                "end_time": endTime,
                "lat": Float(searchedLoc.latitude),
                "lon": Float(searchedLoc.longitude)
            ]
            Alamofire.request(MyVariables.url + "/get_messages", method: .post, parameters:p, encoding: URLEncoding.default)
                .responseData{ response in
                    print(response)
                    do{
                        messageTitles5 = []
                        messageContents5 = []
                        messageMID5 = []
                        
                        let json = try JSON(data: response.data!)
                        let messages = json.array!
                        for each in messages{
                            print(each["mid"])
                            messageMID5.append(each["mid"].stringValue)
                            messageTitles5.append(each["title"].stringValue)
                            messageContents5.append(each["content"].stringValue)
                            print(each["title"].stringValue)
                        }
                    }
                    catch{
                        print("addCategory get JSON Failed")
                    }
            }
        }
        else if(json != [:] && startTime == ""){
            let p: [String: Any] = [
                "type": "active",
                "rid":Login_vars.id,
                "categories": getCat(),
                "lat": Float(searchedLoc.latitude),
                "lon": Float(searchedLoc.longitude)
            ]
            Alamofire.request(MyVariables.url + "/get_messages", method: .post, parameters:p, encoding: URLEncoding.default)
                .responseData{ response in
                    print(response)
                    do{
                        messageTitles5 = []
                        messageContents5 = []
                        messageMID5 = []
                        
                        let json = try JSON(data: response.data!)
                        let messages = json.array!
                        for each in messages{
                            messageMID5.append(each["mid"].stringValue)
                            messageTitles5.append(each["title"].stringValue)
                            messageContents5.append(each["content"].stringValue)
                            print(each["title"].stringValue)
                        }
                    }
                    catch{
                        print("addCategory get JSON Failed")
                    }
            }
        }
        else if(json != [:] && startTime != ""){
            let p: [String: Any] = [
                "type": "active",
                "rid":Login_vars.id,
                "categories": getCat(),
                "start_time": startTime,
                "end_time": endTime,
                "lat": Float(searchedLoc.latitude),
                "lon": Float(searchedLoc.longitude)
            ]
            Alamofire.request(MyVariables.url + "/get_messages", method: .post, parameters:p, encoding: URLEncoding.default)
                .responseData{ response in
                    print(response)
                    do{
                        messageTitles5 = []
                        messageContents5 = []
                        messageMID5 = []
                        
                        let json = try JSON(data: response.data!)
                        let messages = json.array!
                        for each in messages{
                            messageMID5.append(each["mid"].stringValue)
                            messageTitles5.append(each["title"].stringValue)
                            messageContents5.append(each["content"].stringValue)
                            print(each["title"].stringValue)
                        }
                    }
                    catch{
                        print("addCategory get JSON Failed")
                    }
            }
        }
        
    }
    
    @IBAction func achived_button(_ sender: Any) {
        
        if(json == [:] && startTime != ""){
            let p: [String: Any] = [
                "type": "archived",
                "rid":Login_vars.id,
                "start_time": startTime,
                "end_time": endTime,
                "lat": Float(searchedLoc.latitude),
                "lon": Float(searchedLoc.longitude)
            ]
            Alamofire.request(MyVariables.url + "/get_messages", method: .post, parameters:p, encoding: URLEncoding.default)
                .responseData{ response in
                    print(response)
                    do{
                        messageTitles5 = []
                        messageContents5 = []
                        messageMID5 = []
                        
                        let json = try JSON(data: response.data!)
                        let messages = json.array!
                        for each in messages{
                            messageMID5.append(each["mid"].stringValue)
                            messageTitles5.append(each["title"].stringValue)
                            messageContents5.append(each["content"].stringValue)
                            print(each["title"].stringValue)
                        }
                    }
                    catch{
                        print("addCategory get JSON Failed")
                    }
            }
        }
        else if(json != [:] && startTime == ""){
            let p: [String: Any] = [
                "type": "archived",
                "rid":Login_vars.id,
                "categories": getCat(),
                "lat": Float(searchedLoc.latitude),
                "lon": Float(searchedLoc.longitude)
            ]
            Alamofire.request(MyVariables.url + "/get_messages", method: .post, parameters:p, encoding: URLEncoding.default)
                .responseData{ response in
                    print(response)
                    do{
                        messageTitles5 = []
                        messageContents5 = []
                        messageMID5 = []
                        
                        let json = try JSON(data: response.data!)
                        let messages = json.array!
                        for each in messages{
                            messageMID5.append(each["mid"].stringValue)
                            messageTitles5.append(each["title"].stringValue)
                            messageContents5.append(each["content"].stringValue)
                            print(each["title"].stringValue)
                        }
                    }
                    catch{
                        print("addCategory get JSON Failed")
                    }
            }
        }
        else if(json != [:] && startTime != ""){
            let p: [String: Any] = [
                "type": "archived",
                "rid":Login_vars.id,
                "categories": getCat(),
                "start_time": startTime,
                "end_time": endTime,
                "lat": Float(searchedLoc.latitude),
                "lon": Float(searchedLoc.longitude)
            ]
            Alamofire.request(MyVariables.url + "/get_messages", method: .post, parameters:p, encoding: URLEncoding.default)
                .responseData{ response in
                    print(response)
                    do{
                        messageTitles5 = []
                        messageContents5 = []
                        messageMID5 = []
                        
                        let json = try JSON(data: response.data!)
                        let messages = json.array!
                        for each in messages{
                            messageMID5.append(each["mid"].stringValue)
                            messageTitles5.append(each["title"].stringValue)
                            messageContents5.append(each["content"].stringValue)
                            print(each["title"].stringValue)
                        }
                    }
                    catch{
                        print("addCategory get JSON Failed")
                    }
            }
        }
    }
    
    public func getCat() -> String{
        var parameters: [String : Array<String>] = [:]
        
        print("in getCat")
        for each in selectedCategories{
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
        
        return(JSONString!)
        
    }
}
