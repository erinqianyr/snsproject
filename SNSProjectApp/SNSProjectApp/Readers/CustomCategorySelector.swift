//
//  CustomCategorySelector.swift
//  SNSProjectApp
//
//  Created by Yanran Qian on 12/8/18.
//

import Foundation
import UIKit

class CustomCategorySelector: UIViewController{
    
    var categories: [UIButton] = []
    var selectedCategories: [UIButton] = []
    

    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
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
        
        nextButton.addTarget(self, action: #selector(CustomCategorySelector.save(sender:)), for: UIControl.Event.touchUpInside)
    }
    
    //use this to manually add category buttons
    func SetupCategory(cat: String){
        let category = UIButton(frame: CGRect(x: 5, y: 100 + (categories.count) * 55, width:100 , height:50))
        category.setTitle(cat, for: .normal)
        category.backgroundColor = UIColor.blue
        category.addTarget(self, action: #selector(CustomCategorySelector.isSelected(sender:)), for: UIControl.Event.touchUpInside)
        category.isSelected = false
        categories.append(category)
        
    }
    
    func SetupSubCategory(cat: String){
        let category = UIButton(frame: CGRect(x: 30, y: 100 + (categories.count) * 55, width:100 , height:50))
        category.setTitle(cat, for: .normal)
        category.backgroundColor = UIColor.blue
        category.addTarget(self, action: #selector(CustomCategorySelector.isSelected(sender:)), for: UIControl.Event.touchUpInside)
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
    
    @objc func save(sender: UIButton) {
        //as global variable?
    }
    
}
