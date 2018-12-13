//
//  CustomLocationMessages.swift
//  SNSProjectApp
//
//  Created by Yanran Qian on 12/8/18.
//

import Foundation
import UIKit
import Alamofire
import MapKit

var messageTitles2: [String] = []
var messageContents2: [String] = []
var messageMID2: [String] = []
var myIndex2 = 0
var gotData2 = false

class CustomLocationMessages: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var printButton: UIButton!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageTitles2.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = messageTitles2[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex2 = indexPath.row
        performSegue(withIdentifier: "segue", sender: self)
    }
    
    @objc func printMessages(sender: UIButton) {
        getData()
        tableView.reloadData()
    }
    
    var searchedLoc: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        printButton.addTarget(self, action: #selector(CustomLocationMessages.printMessages(sender:)), for: UIControl.Event.touchUpInside)
        //sends them the specified location??idk how to do that
        //make a request
    }
    
    func getData(){
        let p: [String: Any] = [
            "lat": Float(searchedLoc.latitude),
            "lon": Float(searchedLoc.longitude),
            "rid": Login_vars.id,
            "custom_location": "1"
        ]
        Alamofire.request(MyVariables.url + "/at_location", method: .post, parameters:p, encoding: URLEncoding.default)
            .responseData{ response in
                do{
                    messageTitles2 = []
                    messageContents2 = []
                    messageMID2 = []
                    
                    let json = try JSON(data: response.data!)
                    let messages = json.array!
                    for each in messages{
                        messageMID2.append(each["mid"].stringValue)
                        messageTitles2.append(each["title"].stringValue)
                        messageContents2.append(each["content"].stringValue)
                        print(each["title"].stringValue)
                    }
                }
                catch{
                    print("Loc meassages get JSON Failed")
                }
                //Figure out how to set up table view
        }
    }
}
