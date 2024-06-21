//
//  EYLineView.swift
//  Test
//
//  Created by empty on 2024/5/30.
//
import UIKit

@objc
public protocol EYLineViewDelegate: NSObjectProtocol {
    @objc optional func beginEdit(view:EYLineView,item:EYItem?)
    @objc optional func changeText(view:EYLineView,value:String)
    @objc optional func textFieldDidEndEditing(view:EYLineView)
}

@objcMembers
public class EYLineView: UIView {
    private let EYLineViewResignFirstResponderNoticeKey = "EYLineViewResignFirstResponderNotice"
    private var nameLabel = UILabel()
    private var inputText = UITextView()
    private let lineView = UIView()
    private var item:EYItem?
    public var delegate: EYLineViewDelegate?
    
    private var placeholderLabel : UILabel = UILabel()
    
    public var titleColor: UIColor? {
        didSet {
            nameLabel.textColor = titleColor
        }
    }
    public var titleFont = UIFont.systemFont(ofSize: 15) {
        didSet {
            nameLabel.font = titleFont
        }
    }
    public var textColor: UIColor? {
        didSet {
            inputText.textColor = textColor
        }
    }
    public var textFont = UIFont.systemFont(ofSize: 15) {
        didSet {
            inputText.font = textFont
            placeholderLabel.font = textFont
        }
    }
    
    public var textAlignment: NSTextAlignment = .left {
        didSet {
            inputText.textAlignment = textAlignment
            placeholderLabel.textAlignment = textAlignment
        }
    }
    
    public var showLine = true {
        didSet {
            lineView.isHidden = !showLine
        }
    }
    
    public var lineColor: UIColor? {
        didSet {
            lineView.backgroundColor = lineColor
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    public var marginTop:CGFloat = 10 {
        didSet {
            marginTopConstraint?.constant = marginTop
        }
    }
    
    public var marginLeft:CGFloat = 15 {
        didSet {
            marginLeftConstraint?.constant = marginLeft
        }
    }
    
    public var marginBottom:CGFloat = 10 {
        didSet {
            marginBottomConstraint?.constant = -marginBottom
        }
    }
    
    public var marginRight:CGFloat = 15 {
        didSet {
            marginRightConstraint?.constant = -marginRight
        }
    }
    
    private var marginTopConstraint:NSLayoutConstraint?
    private var marginLeftConstraint:NSLayoutConstraint?
    private var marginBottomConstraint:NSLayoutConstraint?
    private var marginRightConstraint:NSLayoutConstraint?
    private var inputTextHeight:NSLayoutConstraint?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
    }
    
    private func setUI() {
        nameLabel.font = titleFont
        nameLabel.textColor = titleColor
        nameLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        self.addSubview(nameLabel)
        inputText.textAlignment = .right
        inputText.font = textFont
        inputText.delegate = self
        inputText.textColor = textColor
        placeholderLabel.textAlignment = textAlignment
        placeholderLabel.text = "PlaceHolder"
        self.addSubview(inputText)
        self.addSubview(placeholderLabel)
        lineView.backgroundColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1)
        lineView.isHidden = !showLine
        self.addSubview(lineView)

        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        marginTopConstraint = nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: marginTop)
        marginTopConstraint?.isActive = true
        marginBottomConstraint =  nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -marginBottom)
        marginBottomConstraint?.isActive = true
        marginLeftConstraint = nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: marginLeft)
        marginLeftConstraint?.isActive = true
        
        nameLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 120).isActive = true
        
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.topAnchor.constraint(equalTo: self.topAnchor,constant: 11).isActive = true
//        placeholderLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -5).isActive = true
//        placeholderLabel.heightAnchor.constraint(equa).isActive = true
        placeholderLabel.leadingAnchor.constraint(equalTo: inputText.leadingAnchor, constant: 15).isActive = true
        placeholderLabel.trailingAnchor.constraint(equalTo: inputText.trailingAnchor,constant: -5       ).isActive = true
        
        
        
        inputText.translatesAutoresizingMaskIntoConstraints = false
        inputText.topAnchor.constraint(equalTo: self.topAnchor,constant: 5).isActive = true
        inputText.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -5).isActive = true
        inputTextHeight = inputText.heightAnchor.constraint(equalToConstant: 35)
        inputTextHeight?.isActive = true
        inputText.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 15).isActive = true
        marginRightConstraint = inputText.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -marginRight)
        marginRightConstraint?.isActive = true
        
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        lineView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: marginLeft).isActive = true
        lineView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true

        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDone), name: NSNotification.Name(EYLineViewResignFirstResponderNoticeKey), object: nil)
    }
    
    public func setInfo(_ item:EYItem) {
        self.item = item
        nameLabel.text = item.name
        inputText.text = item.value
        placeholderLabel.text = item.placeholder
        inputText.keyboardType = item.keyboardType
        inputText.isUserInteractionEnabled = item.canEdit
        inputText.inputAccessoryView = self.addToolbar()
    }
    
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.textViewDidChange(inputText)
    }
    
    public func reloadData(_ value:String?) {
        self.item?.value = value ?? ""
        self.inputText.text = value
    }
    
    public func addToolbar()->UIToolbar {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: Int(self.frame.width), height: 35));
        toolbar.tintColor = UIColor.blue
        toolbar.backgroundColor = UIColor.gray
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneItem = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(textFieldDone))
        toolbar.items = [space,doneItem]
        return toolbar;
    }
    
    @objc private func textFieldDone() {
        inputText.resignFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


extension EYLineView: UITextViewDelegate {
    
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        placeholderLabel.isHidden = true
        let canEditing = item?.canResponse ?? true
        if !canEditing {
            NotificationCenter.default.post(name: NSNotification.Name(EYLineViewResignFirstResponderNoticeKey), object: nil)
        }
        self.delegate?.beginEdit?(view: self, item: item)
        return canEditing
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        if let value = textView.text{
            if let item = self.item,item.maxHeight <= textView.contentSize.height && item.maxHeight > 0 {
                inputTextHeight?.constant = item.maxHeight
            }else {
                inputTextHeight?.constant = textView.contentSize.height
            }
            self.item?.value = value
            self.delegate?.changeText?(view: self,value: value)
        }
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        self.delegate?.textFieldDidEndEditing?(view: self)
    }
    
}
