//
//  AllMessagesTableViewController.swift
//  SNSProjectApp
//
//  Created by sphinx on 12/8/18.
//

import UIKit
import Alamofire

class AllMessagesTableViewController: UITableViewController {

    @IBOutlet weak var Table: UITableView!
    
    var data = ["1","2","3","4"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = data as? UITableViewDataSource
        tableView.delegate = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        //get data
        
        
    }

    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Default cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as UITableViewCell
        let pp = "haaaa"
        cell.textLabel!.text = data[indexPath.row]
        
        return cell;
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }
    
    func getData (){
        Alamofire.request(MyVariables.url + "/publishers_messages?pid=" + Login_vars.id, method: .get, encoding: URLEncoding.default)
            .responseData{ response in
                print(response)
                print(response.data!)
                
                do{
                    let json = try JSON(data: response.data!)
                    let messages = json.array!
                    for each in messages{
                        print(each["title"].stringValue)
                    }
                }
                catch{
                    print("addCategory get JSON Failed")
                }
                
        }
    }

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
