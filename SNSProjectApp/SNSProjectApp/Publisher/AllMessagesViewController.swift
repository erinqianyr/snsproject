//
//  AllMessagesTableViewController.swift
//  SNSProjectApp
//
//  Created by sphinx on 12/8/18.
//

import UIKit
import Alamofire

var messageTitles3: [String] = []
var messageContents3: [String] = []
var messageMID3: [String] = []

var myIndex3 = 0
var gotData3 = false

class AllMessagesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var printButton: UIButton!
    
    func getData (){
        Alamofire.request(MyVariables.url + "/publishers_messages?pid=" + Login_vars.id, method: .get, encoding: URLEncoding.default)
            .responseData{ response in
                print(response)
                print(response.data!)
                
                messageTitles3 = []
                messageContents3 = []
                messageMID3 = []
                
                do{
                    let json = try JSON(data: response.data!)
                    let messages = json.array!
                    for each in messages{
                        messageMID3.append(each["mid"].stringValue)
                        messageTitles3.append(each["title"].stringValue)
                        messageContents3.append(each["content"].stringValue)
                        
                        print(each["title"].stringValue)
                    }
                }
                catch{
                    print("getData get JSON Failed")
                }
        }
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageTitles3.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = messageTitles3[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex3 = indexPath.row
        
        performSegue(withIdentifier: "segue", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if (gotData3 == false) {
            getData()
            gotData3 = true
        }
        printButton.addTarget(self, action: #selector(AllMessagesViewController.printMessages(sender:)), for: UIControl.Event.touchUpInside)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        //get data
    }
    
    
    @objc func printMessages(sender: UIButton) {
        getData();
        tableView.reloadData()
    }

    // MARK: - Table view data source
    
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
