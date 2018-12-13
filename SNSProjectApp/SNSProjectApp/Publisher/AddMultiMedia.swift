//
//  AddMultiMedia.swift
//  SNSProjectApp
//
//  Created by Yanran Qian on 12/10/18.
//

import UIKit
import MediaPlayer

class AddMultiMedia: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate, MPMediaPickerControllerDelegate  {

    var subjectField: String = ""
    var messageField: String = ""
    var longField: String = ""
    var latField: String = ""
    var rangeField: String = ""
    var startTimeField: Date = Date.init()
    var endTimeField: Date = Date.init()
    var image: UIImage = UIImage.init()
    var imageData: [String] = []
    var mediaPicker: MPMediaPickerController = MPMediaPickerController.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //@IBOutlet var imageView: UIImageView!
    @IBOutlet var chooseBuuton: UIButton!
    var imagePicker = UIImagePickerController()
    

    @IBAction func btnClicked() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
            
        }
    }

    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        image = chosenImage
        
        let imageData1 = image.pngData()
        let stringBase64: String = (imageData1?.base64EncodedString(options: .lineLength64Characters))!
        imageData.append(stringBase64)
        picker.dismiss(animated: true, completion: nil)
    }
    
    var mediaPicker1: MPMediaPickerController!

//    @IBAction func addAudio(_ sender: Any) {
//        let mediaPicker: MPMediaPickerController = MPMediaPickerController.self(mediaTypes: MPMediaType.music)
//        mediaPicker.allowsPickingMultipleItems = false
//        mediaPicker1 = mediaPicker
//        mediaPicker.delegate = self
//        self.present(mediaPicker1, animated: true, completion: nil)
//    }
    /*
    func presentPicker() {
        mediaPicker = MPMediaPickerController(mediaTypes: .music)
        if let picker = mediaPicker {
            picker.delegate = self
            picker.allowsPickingMultipleItems = false
            picker.showsCloudItems = false
            picker.prompt = "Please Pick a Song"
            present(picker, animated: false, completion: nil)
        }
    }*/
    
    @IBAction func saveInfoEntered(_ sender: Any) {
        let message = storyboard?.instantiateViewController(withIdentifier: "CategorySelectorViewController") as! CategorySelectorViewController
    
        message.subjectField = self.subjectField
        message.messageField = self.messageField
        message.longField = self.longField
        message.latField = self.latField
        message.rangeField = self.rangeField
        message.endTimeField = endTimeField
        message.startTimeField = startTimeField
        
        let jsonData = try! JSONSerialization.data(withJSONObject: imageData)
        let JSONString = String(data: jsonData, encoding: String.Encoding.utf8)
        //print(JSONString!)
        
        message.imageData = JSONString!
        
        
        navigationController?.pushViewController(message, animated: true)
    }
    
}
