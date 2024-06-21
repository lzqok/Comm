//
//  EYPickerView.swift
//  ECommon
//
//  Created by empty on 2024/6/5.
//

import UIKit

@objcMembers
public class EYPickerView: UIView {
    private let pickerView = UIPickerView()
    
    private let topView = UIView()
    private let topTitleLabel = UILabel()
    private let lineView = UIView()
    private let cancleBtn = UIButton()
    private let comfireBtn = UIButton()
    
    private var comfireTrailing: NSLayoutConstraint?
    private var comfireTop: NSLayoutConstraint?
    private var comfireBottom: NSLayoutConstraint?
    private var cancelLeading: NSLayoutConstraint?
    private var cancelTop: NSLayoutConstraint?
    private var cancelBottom: NSLayoutConstraint?
    static var popupWindow:UIWindow?
    
    var config: EYPickerConfigDelegare? {
        didSet {
            self.setConfig()
        }
    }
    
    var data: EYPickerDataSource?
    
    public init() {
        super.init(frame: .zero)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        
        self.backgroundColor = UIColor.white
        topView.backgroundColor = UIColor.red
        self.addSubview(topView)
        
        topView.addSubview(topTitleLabel)
        
        cancleBtn.setTitle("取消", for: .normal)
        cancleBtn.addTarget(self, action: #selector(cancelAction(_:)), for: .touchUpInside)
        cancleBtn.setTitleColor(UIColor.black, for: .normal)
        topView.addSubview(cancleBtn)
        
        comfireBtn.setTitle("确定", for: .normal)
        comfireBtn.setTitleColor(UIColor.black, for: .normal)
        comfireBtn.addTarget(self, action: #selector(comfireAction(_:)), for: .touchUpInside)
        topView.addSubview(comfireBtn)
        
        topView.addSubview(lineView)
        
        pickerView.delegate = self
        pickerView.dataSource = self
        self.addSubview(pickerView)
        
        
        self.cancleBtn.translatesAutoresizingMaskIntoConstraints = false
        cancelTop = self.cancleBtn.topAnchor.constraint(equalTo: topView.topAnchor)
        cancelTop?.isActive = true
        cancelLeading = self.cancleBtn.leadingAnchor.constraint(equalTo: topView.leadingAnchor)
        cancelLeading?.isActive = true
        cancelBottom = self.cancleBtn.bottomAnchor.constraint(equalTo: topView.bottomAnchor)
        cancelBottom?.isActive = true
        self.cancleBtn.widthAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
        
        self.comfireBtn.translatesAutoresizingMaskIntoConstraints = false
        
        comfireTop = self.comfireBtn.topAnchor.constraint(equalTo: topView.topAnchor)
        comfireTop?.isActive = true
        comfireTrailing = self.comfireBtn.trailingAnchor.constraint(equalTo: topView.trailingAnchor,constant: 0)
        comfireTrailing?.isActive = true
        comfireBottom = self.comfireBtn.bottomAnchor.constraint(equalTo: topView.bottomAnchor)
        comfireBottom?.isActive = true
        self.comfireBtn.widthAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
        
        self.lineView.translatesAutoresizingMaskIntoConstraints = false
        self.lineView.bottomAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        self.lineView.leadingAnchor.constraint(equalTo: topView.leadingAnchor).isActive = true
        self.lineView.trailingAnchor.constraint(equalTo: topView.trailingAnchor).isActive = true
        self.lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        self.topView.translatesAutoresizingMaskIntoConstraints = false
        self.topView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.topView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.topView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.topView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        
        self.pickerView.translatesAutoresizingMaskIntoConstraints = false
        self.pickerView.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        self.pickerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.pickerView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.pickerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    func cancelAction(_ sender:UIButton) {
        EYPickerView.dissmiss()
    }
    
    func comfireAction(_ sender:UIButton) {
        EYPickerView.dissmiss()
    }
    
    private func setConfig() {
        guard let config = config else { return }
        
        self.backgroundColor = config.backgroundColor
        topView.backgroundColor = config.topBackgroundColor
        topTitleLabel.text = config.topText
        topTitleLabel.font = config.topTextFont
        topTitleLabel.textColor = config.topTextColor
        lineView.backgroundColor = config.lineColor
        self.cancleBtn.backgroundColor = config.cancelBackgroundColor
        self.cancleBtn.setTitle(config.cancelText, for: .normal)
        self.cancleBtn.setTitleColor(config.cancelColor, for: .normal)
        self.cancleBtn.titleLabel?.font = config.cancelFont
        self.cancleBtn.layer.cornerRadius = config.buttonCornerRadius
        
        self.comfireBtn.backgroundColor = config.comfireBackgroundColor
        self.comfireBtn.setTitle(config.comfireText, for: .normal)
        self.comfireBtn.setTitleColor(config.comfireColor, for: .normal)
        self.comfireBtn.titleLabel?.font = config.comfireFont
        self.comfireBtn.layer.cornerRadius = config.buttonCornerRadius
        
        if config.buttonCornerRadius > 0 {
            cancelTop?.constant = 5
            cancelBottom?.constant = -5
            cancelLeading?.constant = 16
            comfireTrailing?.constant = -16
            comfireTop?.constant = 5
            comfireBottom?.constant = -5
        }
    }
    
    
    public class func showPickerView(config:EYPickerConfig,closeBlock: (()->Void)? = nil, comfireBlock:((_ value:String?)->Void)?){
        popupWindow = UIWindow(frame: UIScreen.main.bounds)
        popupWindow?.windowLevel = UIWindowLevelAlert + 1.0
        popupWindow?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        let pickerView = EYPickerView()
        pickerView.data = config.dataSource
        pickerView.config = config
        // 创建一个临时的视图控制器作为 popupWindow 的根视图控制器
        let tempViewController = UIViewController()
        tempViewController.view.addSubview(pickerView)

        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.leadingAnchor.constraint(equalTo: tempViewController.view.leadingAnchor).isActive = true
        pickerView.trailingAnchor.constraint(equalTo: tempViewController.view.trailingAnchor).isActive = true
        pickerView.heightAnchor.constraint(equalToConstant: config.height).isActive = true
        if #available(iOS 11.0, *) {
            let fillView = UIView()
            fillView.backgroundColor = config.backgroundColor
            tempViewController.view.addSubview(fillView)
            fillView.translatesAutoresizingMaskIntoConstraints = false
            fillView.leadingAnchor.constraint(equalTo: tempViewController.view.leadingAnchor).isActive = true
            fillView.trailingAnchor.constraint(equalTo: tempViewController.view.trailingAnchor).isActive = true
            fillView.topAnchor.constraint(equalTo: pickerView.bottomAnchor).isActive = true
            fillView.bottomAnchor.constraint(equalTo: tempViewController.view.bottomAnchor).isActive = true
            
            pickerView.bottomAnchor.constraint(equalTo: tempViewController.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            pickerView.bottomAnchor.constraint(equalTo: tempViewController.view.bottomAnchor).isActive = true
        }
        
        // 设置根视图控制器
        popupWindow?.rootViewController = tempViewController
        popupWindow?.makeKeyAndVisible()
    }
    
    private class func dissmiss() {
        if self.popupWindow != nil {
            self.popupWindow?.isHidden = true
            self.popupWindow = nil
        }
    }
    
}


extension EYPickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return data?.componentNum ?? 0
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data?.number(component: component) ?? 0
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data?.getStr(component: component, row: row)
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        data?.selectedIndex(component: component, row: row)
        pickerView.reloadAllComponents()
    }
    
}


public protocol EYData {
    associatedtype T:EYData
    var title: String {get set}
    var datas:[T] { get set }
}

public class EYDataModel: EYData {
    public var datas: [EYDataModel] = [EYDataModel]()
    public var title: String = ""
    public init() {
        
    }
}

public class EYPickerDataSource {
    
    public var datas: [any EYData] = [any EYData]() {
        didSet {
            component()
        }
    }
    
    public private(set) var componentNum = 0
    private var selectedRows = [Int:Int]()
    
    private func component() {
        var temp = datas
        var count = 0
        while temp.count > 0 {
            count += 1
            temp = temp[0].datas
            selectedRows[count-1] = 0
        }
        componentNum = count
    }
    
    public func number(component: Int) -> Int {
        let temp = getComponentList(component: component)
        return temp.count
    }
    
    public func selectedIndex(component:Int,row:Int) {
        selectedRows[component] = row
        
        var count = 0
        var temp = datas
        while temp.count > 0 {
            let row = selectedRows[count] ?? 0
            temp = temp[row].datas
            count += 1
        }
        componentNum = count
    }
    
    public func getStr(component: Int, row: Int) -> String? {
        let temp = getComponentList(component: component)
        return temp[row].title
    }
    
    private func getComponentList(component: Int)-> [any EYData]{
        var count = 0
        var temp = datas
        while temp.count > 0 {
            if component == count {
                break
            }
            let row = selectedRows[count] ?? 0
            temp = temp[row].datas
            count += 1
        }
        return temp
    }
    
    public init() {
        
    }
}


@objcMembers
public class EYPickerConfig:NSObject,EYPickerConfigDelegare {
     
    public var lineColor: UIColor? = UIColor(red: 223/255.0, green: 223/255.0, blue: 223/255.0, alpha: 1)
    
    public var height: CGFloat = 280

    public var buttonCornerRadius: CGFloat = 10
    
    public var topTextFont: UIFont? = UIFont.systemFont(ofSize: 18)
    
    public var topTextColor: UIColor? = UIColor.black
    
    public var topText: String? = "时间选择器"
     
    public var topBackgroundColor: UIColor? = UIColor.white
    
    public var cancelFont: UIFont? = UIFont.systemFont(ofSize: 16)
    
    public var cancelBackgroundColor: UIColor? = UIColor.lightGray
    
    public var comfireFont: UIFont? = UIFont.systemFont(ofSize: 16)
    
    public var comfireBackgroundColor: UIColor? = UIColor.systemGreen
    
    public var cancelText: String? = "返回"
    
    public var cancelColor: UIColor? = UIColor.white
    
    public var comfireText: String? = "OK"
    
    public var comfireColor: UIColor? = UIColor.white
    
    public var backgroundColor: UIColor? = UIColor.white
    
    public var dataSource: EYPickerDataSource?
    
    public override init() {
        super.init()
    }
}
