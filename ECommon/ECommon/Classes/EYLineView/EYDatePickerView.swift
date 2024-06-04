//
//  EYDatePickerView.swift
//  ECommon
//
//  Created by empty on 2024/6/3.
//

import UIKit

@objcMembers
public class EYDatePickerView: UIView {
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker(frame: .zero)
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "zh_CHS_CN")
//        [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CHS_CN"];
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
//        datePicker.addTarget(self, action: #selector(dateValueChange(_:)), for: .valueChanged)
        return datePicker
    }()
    
    private let topView = UIView()
    private let topTitleLabel = UILabel()
    private let lineView = UIView()
    private let cancleBtn = UIButton()
    private let comfireBtn = UIButton()
    private var selectedValue: String?
    private var comfireTrailing: NSLayoutConstraint?
    private var comfireTop: NSLayoutConstraint?
    private var comfireBottom: NSLayoutConstraint?
    private var cancelLeading: NSLayoutConstraint?
    private var cancelTop: NSLayoutConstraint?
    private var cancelBottom: NSLayoutConstraint?
    
    var config: EYDatePickerConfigDelegare? {
        didSet {
            self.setConfig()
        }
    }
    var cancelBlock: (()->Void)?
    var comfireBlock: ((_ value:String?)->Void)?
    
    static var popupWindow:UIWindow?
    
    private init() {
        super.init(frame: .zero)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initUI() {
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
        
        self.addSubview(datePicker)
        

        self.topTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.topTitleLabel.topAnchor.constraint(equalTo: topView.topAnchor).isActive = true
        self.topTitleLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
        self.topTitleLabel.bottomAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        self.topTitleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
        
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
        
        
        self.datePicker.translatesAutoresizingMaskIntoConstraints = false
        self.datePicker.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        self.datePicker.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.datePicker.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.datePicker.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    private func setConfig() {
        guard let config = config else { return }
        datePicker.datePickerMode = config.datePickerMode
        
        if let minDate = config.minDate {
            datePicker.minimumDate = minDate
        }
        
        if let currentDate = config.currentDate {
            datePicker.date = currentDate
        }
        
        if let maxDate = config.maxDate {
            datePicker.maximumDate = maxDate
        }
        
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
    
    private func formateDate(date:Date)->String {
        let dataFormate = DateFormatter()
        dataFormate.dateFormat = "yyyy-MM-dd"
        let dateStr = dataFormate.string(from: date)
        return dateStr
    }
    
    func cancelAction(_ sender:UIButton) {
        self.cancelBlock?()
        EYDatePickerView.dissmiss()
    }
    
    func comfireAction(_ sender:UIButton) {
        let selectedValue = formateDate(date: datePicker.date)
        self.comfireBlock?(selectedValue)
        EYDatePickerView.dissmiss()
    }
    
    private class func dissmiss() {
        if self.popupWindow != nil {
            self.popupWindow?.isHidden = true
            self.popupWindow = nil
        }
    }
    

    public class func showDateView(config:EYDatePickerConfigDelegare,closeBlock: (()->Void)? = nil, comfireBlock:((_ value:String?)->Void)?){
        popupWindow = UIWindow(frame: UIScreen.main.bounds)
        popupWindow?.windowLevel = UIWindowLevelAlert + 1.0
        popupWindow?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        let pickerView = EYDatePickerView()
        pickerView.config = config
        pickerView.cancelBlock = closeBlock
        pickerView.comfireBlock = comfireBlock
        
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
    
}

public protocol EYDatePickerConfigDelegare: NSObjectProtocol  {
    var height: CGFloat { get set }
    var backgroundColor: UIColor? { get set }
    var topBackgroundColor: UIColor? { get set }
    var topTextFont: UIFont? { get set }
    var topTextColor: UIColor? { get set }
    var topText: String? { get set }
    var lineColor: UIColor? { get set }
    var cancelFont: UIFont? { get set }
    var cancelText: String? { get set }
    var cancelColor: UIColor? { get set }
    var cancelBackgroundColor: UIColor? { get set }
    var comfireText: String? { get set }
    var comfireColor: UIColor? { get set }
    var comfireFont: UIFont? { get set }
    var comfireBackgroundColor: UIColor? { get set }
    var buttonCornerRadius: CGFloat { get set }
    var datePickerMode: UIDatePickerMode { get set }
    var minDate: Date? { get set }
    var maxDate: Date? { get set }
    var currentDate: Date? { get set }
}

@objcMembers
public class EYDatePickerConfig:NSObject,EYDatePickerConfigDelegare {
     
    public var lineColor: UIColor? = UIColor(red: 223/255.0, green: 223/255.0, blue: 223/255.0, alpha: 1)
    
    public var minDate: Date?
    
    public var currentDate: Date?
    
    public var maxDate: Date?
    
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
    
    public var datePickerMode: UIDatePickerMode = .date
    
    public override init() {
        super.init()
    }
}
