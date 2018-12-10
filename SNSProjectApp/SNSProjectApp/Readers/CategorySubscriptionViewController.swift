//
//  CategorySubscriptionViewController.swift
//  SNSProjectApp
//
//  Created by Yanran Qian on 12/8/18.
//

import Foundation
import UIKit

class CategorySubscriptionViewController: UIViewController {
    var categories: [UIButton] = []
    
    @IBOutlet weak var subscribeButton: UIButton!
    @IBOutlet weak var myView: UIView!
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
        
        subscribeButton.addTarget(self, action: #selector(CategorySubscriptionViewController.subscribe(sender:)), for: UIControl.Event.touchUpInside)
    }
    
    func SetupCategory(cat: String){
        let category = UIButton(frame: CGRect(x: 5, y: 100 + (categories.count) * 55, width:100 , height:50))
        category.setTitle(cat, for: .normal)
        category.backgroundColor = UIColor.blue
        category.addTarget(self, action: #selector(CategorySubscriptionViewController.isSelected(sender:)), for: UIControl.Event.touchUpInside)
        category.isSelected = false
        categories.append(category)
        
    }
    
    func SetupSubCategory(cat: String){
        let category = UIButton(frame: CGRect(x: 30, y: 100 + (categories.count) * 55, width:100 , height:50))
        category.setTitle(cat, for: .normal)
        category.backgroundColor = UIColor.blue
        category.addTarget(self, action: #selector(CategorySubscriptionViewController.isSelected(sender:)), for: UIControl.Event.touchUpInside)
        category.isSelected = false
        categories.append(category)
    }
    
    
    //idk why its not working
    @objc func isSelected(sender: UIButton){
        sender.isSelected = !sender.isSelected
        if(sender.isSelected){
            sender.backgroundColor = UIColor.green
        }else{
            sender.backgroundColor = UIColor.blue
        }
    }
    
    @objc func subscribe(sender: UIButton) {
        //subscribe
    }
}
