//
//  MessageContents1.swift
//  SNSProjectApp
//
//  Created by Yanran Qian on 12/9/18.
//

import UIKit
import Alamofire


class MessageContents1: UIViewController {
    @IBOutlet weak var messageTitle: UILabel!
    @IBOutlet weak var messageContent: UITextView!
    @IBOutlet weak var myImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTitle.text = messageTitles1[myIndex1]
        messageContent.text = messageContents1[myIndex1]
        messageContent.isEditable = false
        Alamofire.request(MyVariables.url + "/message_media?mid=" + messageMID1[myIndex1], method: .get, encoding: URLEncoding.default)
            .responseData{ response in
                
                print(response)
                print(response.data!)
                
                do{
                    let json = try JSON(data: response.data!)
                    let messages = json.array!
                    if(messages != []){
                        print("messages != []")
                        for each in messages{
                            print("in each")
                            if let decodedData = Data(base64Encoded: each["media"].stringValue, options: .ignoreUnknownCharacters) {
                                let image1 = UIImage(data: decodedData)
                                let test1:UIImageView = UIImageView(image: image1)
                                //self.myImageView = test1
                                test1.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
                                self.myImageView.addSubview(test1)
                            }
                        }
                    }
                }
                catch{
                    print("getData get JSON Failed")
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

}
