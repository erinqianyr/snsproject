//
//  CategorySelectorViewController.swift
//  SNSProjectApp
//
//  Created by Yanran Qian on 11/28/18.
//
import UIKit
import Foundation

class CategorySelectorViewController: UIViewController, UITextFieldDelegate {
    
    var categories: [UIButton] = []
    
    @IBOutlet weak var addField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var publishButton: UIButton!
    //var addButton: UIButton!
    //var addField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addField.delegate = self
        
        SetupCategory(cat: "Myface")
        SetupCategory(cat: "Mybody")
        SetupCategory(cat: "This String")
        for cat in categories{
            self.view.addSubview(cat)
        }
        //addField = UITextField(frame: CGRect(x: 5, y: 100 + (categories.count) * 55, width: 100, height: 50))
        //self.view.addSubview(addField)
        //addButton = UIButton(frame: CGRect(x: 120, y: 100 + (categories.count) * 55, width: 100, height: 50))
        //addButton.setTitle("add", for: .normal)
        addButton.addTarget(self, action: #selector(CategorySelectorViewController.addCategory(sender:)), for: UIControl.Event.touchUpInside)
        publishButton.addTarget(self, action: #selector(CategorySelectorViewController.publish(sender:)), for: UIControl.Event.touchUpInside)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //hide keyboard when touch outside of keybar
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func SetupCategory(cat: String){
        let category = UIButton(frame: CGRect(x: 5, y: 100 + (categories.count) * 55, width:100 , height:50))
        category.setTitle(cat, for: .normal)
        category.backgroundColor = UIColor.blue
        category.addTarget(self, action: #selector(CategorySelectorViewController.isSelected(sender:)), for: UIControl.Event.touchUpInside)
        category.isSelected = false
        categories.append(category)
        
    }
    
    @objc func addCategory(sender: UIButton){
        SetupCategory(cat: addField.text!)
        self.view.addSubview(categories.last!)
        //also needa add to database
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
        //publish to database
    }
}
