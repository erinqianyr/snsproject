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
    
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var publishButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //this section will be requesting the categories and setup each of them individually
        SetupCategory(cat: "Myface")
        SetupCategory(cat: "Mybody")
        SetupCategory(cat: "This String")
        SetupSubCategory(cat: "Myface")
        SetupSubCategory(cat: "Mybody")
        SetupSubCategory(cat: "This String")
        SetupCategory(cat: "Myface")
        SetupCategory(cat: "Mybody")
        SetupCategory(cat: "This String")
        for cat in categories{
            self.myView.addSubview(cat)
        }
        
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
    
    //use this to manually add category buttons
    func SetupCategory(cat: String){
        let category = UIButton(frame: CGRect(x: 5, y: 100 + (categories.count) * 55, width:100 , height:50))
        category.setTitle(cat, for: .normal)
        category.backgroundColor = UIColor.blue
        category.addTarget(self, action: #selector(CategorySelectorViewController.isSelected(sender:)), for: UIControl.Event.touchUpInside)
        category.isSelected = false
        categories.append(category)
        
    }
    
    func SetupSubCategory(cat: String){
        let category = UIButton(frame: CGRect(x: 30, y: 100 + (categories.count) * 55, width:100 , height:50))
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
    
    @objc func publish(sender: UIButton) {
        //publish to database
    }
}
