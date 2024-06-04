//
//  EYLineViewVC.swift
//  EmptyCommon_Example
//
//  Created by empty on 2024/5/30.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import ECommon
class EYLineViewVC: UIViewController {
    private let scrollView = UIScrollView()
    private var items:[EYItem] = [EYItem]()
    private var linViews: [EYLineView] = [EYLineView]()
    private var currentStr:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = NSHomeDirectory() + "/Documents" + "/xx.plist"
        
        let restoreItems = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? [EYItem]
        
        
        
        scrollView.backgroundColor = UIColor.white
        self.view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(lessThanOrEqualTo: self.view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(greaterThanOrEqualTo: self.view.bottomAnchor).isActive = true
        
        let keys = ["id","value","date","des"]
        
        for (i,key) in keys.enumerated() {
            let item = EYItem(name: "标题 \(i)",placeholder: "请输入")
            item.canResponse = key != "date"
            item.valueKey = key
            items.append(item)
        }
        
        
        let calendar = NSCalendar.current
        
        let dataFormate = DateFormatter()
        dataFormate.dateFormat = "YYYY-MM-dd"
        let date = dataFormate.date(from: "1990-01-01")
        

        if let restoreItems = restoreItems {
            items = restoreItems
        }
        
        var relativeView: UIView = scrollView
        
        for (index,item) in items.enumerated()  {
            let lineView = EYLineView()
            lineView.delegate = self
            lineView.setInfo(item)
            scrollView.addSubview(lineView)
            linViews.append(lineView)
            lineView.marginRight = 50
            lineView.translatesAutoresizingMaskIntoConstraints = false
//            lineView.heightAnchor.constraint(lessThanOrEqualToConstant: 180).isActive = true
//            lineView.heightAnchor.constraint(greaterThanOrEqualToConstant: 45).isActive = true
            lineView.leadingAnchor.constraint(equalTo: relativeView.leadingAnchor).isActive = true
            lineView.widthAnchor.constraint(equalTo: relativeView.widthAnchor).isActive = true
            if index == 0 {
                lineView.topAnchor.constraint(equalTo: relativeView.topAnchor,constant: 10).isActive = true
            }else {
                lineView.topAnchor.constraint(equalTo: relativeView.bottomAnchor,constant: 0).isActive = true
            }
            
            if index == items.count - 1 {
                lineView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
            }
            relativeView = lineView
        }
        
        let sendBtn = UIButton()
        sendBtn.setTitle("发送", for: .normal)
        sendBtn.setTitleColor(UIColor.black, for: .normal)
        sendBtn.addTarget(self, action: #selector(sendAction(_:)), for: .touchUpInside)
        self.view.addSubview(sendBtn)
        
        sendBtn.translatesAutoresizingMaskIntoConstraints = false
        sendBtn.heightAnchor.constraint(equalToConstant: 45).isActive = true
        sendBtn.widthAnchor.constraint(equalToConstant: 60).isActive = true
        sendBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        sendBtn.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,constant: -60).isActive = true
        
        
        let datePicker = UIButton()
        datePicker.setTitle("show Date", for: .normal)
        datePicker.setTitleColor(UIColor.black, for: .normal)
        datePicker.addTarget(self, action: #selector(showDate(_:)), for: .touchUpInside)
        self.view.addSubview(datePicker)
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        datePicker.heightAnchor.constraint(equalToConstant: 45).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,constant: -130).isActive = true
        
    }
    
    @objc func showDate(_ sender:UIButton) {
       
    }
    
    @objc func sendAction(_ sender:UIButton) {
        let dic = NSMutableDictionary()
        for item in items {
            if let valueKey = item.valueKey {
                dic.setValue(item.value, forKey: valueKey)
            }
        }
        print("values ", dic)
        
        let path = NSHomeDirectory() + "/Documents" + "/xx.plist"
        let result = NSKeyedArchiver.archiveRootObject(items, toFile: path)
       
    }
}

extension EYLineViewVC: EYLineViewDelegate {
    func beginEdit(view: ECommon.EYLineView,item: EYItem?) {
        guard let item = item, item.valueKey == "date" else { return }
        
        let config = EYDatePickerConfig()
 
        let dataFormate = DateFormatter()
        dataFormate.dateFormat = "YYYY-MM-dd"
        
        let minDate = dataFormate.date(from: "2000-01-01")
        config.minDate = minDate
        
        let date = dataFormate.date(from: "2048-01-01")
        config.maxDate = date
        
        var currentDate = dataFormate.date(from: "2025-02-02")
        if currentStr != nil {
            currentDate = dataFormate.date(from: currentStr!)
        }
        config.currentDate = currentDate
        
        EYDatePickerView.showDateView(config: config,comfireBlock: {[weak self] value in
            self?.currentStr = value
            view.reloadData(value)
        })
    }
    
    
    func changeText(view: ECommon.EYLineView, value: String) {
        
    }
    
    func textFieldDidEndEditing(view: ECommon.EYLineView) {
        
    }
    
}
