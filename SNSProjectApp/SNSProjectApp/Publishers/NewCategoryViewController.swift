//
//  NewCategoryViewController.swift
//  SNSProjectApp
//
//  Created by Yanran Qian on 12/6/18.
//

import Foundation
import UIKit

class NewCategoryViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var addCategory: UITextField!
    @IBOutlet weak var addCategoryButton: UIButton!
    @IBOutlet weak var addSubCategory: UITextField!
    @IBOutlet weak var addSubCategoryButton: UIButton!
    @IBOutlet weak var myView: UIView!
    var selectedCategory:String!
    
    var categories: [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addCategory.delegate = self
        self.addSubCategory.delegate = self
        
        addCategoryButton.addTarget(self, action: #selector(NewCategoryViewController.addCategory(sender:)), for: UIControl.Event.touchUpInside)
        
        addSubCategoryButton.addTarget(self, action: #selector(NewCategoryViewController.addSubCategory(sender:)), for: UIControl.Event.touchUpInside)
        
        SetupCategory(cat: "Myface")
        SetupCategory(cat: "Mybody")
        SetupCategory(cat: "This String")
        SetupCategory(cat: "Myface")
        SetupCategory(cat: "Mybody")
        SetupCategory(cat: "This String")
        SetupCategory(cat: "Myface")
        SetupCategory(cat: "Mybody")
        SetupCategory(cat: "This String")
        for cat in categories{
            self.myView.addSubview(cat)
        }
    }
    
        
    @objc func addCategory(sender: UIButton){
        SetupCategory(cat: addCategory.text!)
        self.myView.addSubview(categories.last!)
        //add to database
    }
    
    @objc func addSubCategory(sender: UIButton){
        //add to database
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
        let category = UIButton(frame: CGRect(x: 50, y: 0 + (categories.count) * 55, width:100 , height:50))
        category.setTitle(cat, for: .normal)
        category.backgroundColor = UIColor.blue
        category.addTarget(self, action: #selector(NewCategoryViewController.select(sender:)), for: UIControl.Event.touchUpInside)
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
    
    @objc func select(sender: UIButton){
        selectedCategory = sender.currentTitle
        sender.isSelected = !sender.isSelected
        sender.backgroundColor = UIColor.green
        for cat in categories {
            cat.backgroundColor = UIColor.blue
        }
        /*
        if(sender.isSelected){
            sender.backgroundColor = UIColor.green
        }else{
            sender.backgroundColor = UIColor.blue
        }
 */
    }
    
    
}
