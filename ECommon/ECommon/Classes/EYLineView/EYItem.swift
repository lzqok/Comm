//
//  EYItem.swift
//  Test
//
//  Created by empty on 2024/5/30.
//

import UIKit

@objcMembers
public class EYItem: NSObject,NSCoding {
    public var name = ""
    public var value = ""
    public var subValue = ""
    public var placeholder = ""
    public var keyboardType = UIKeyboardType.default
    public var canEdit:Bool = true
    public var valueKey: String?
    public var maxHeight: Double = 0
    public var canResponse:Bool = true
    
    public init(name:String,value:String = "",placeholder:String = "") {
        super.init()
        self.name = name
        self.value = value
        self.placeholder = placeholder
    }
    
    private override init() {
        super.init()
    }
    
    public required init?(coder: NSCoder) {
        super.init()
        name = coder.decodeObject(forKey: "name") as? String ?? ""
        value = coder.decodeObject(forKey: "value") as? String ?? ""
        subValue = coder.decodeObject(forKey: "subValue") as? String ?? ""
        placeholder = coder.decodeObject(forKey: "placeholder") as? String ?? ""
        keyboardType = UIKeyboardType(rawValue:coder.decodeInteger(forKey: "keyboardType")) ?? .default
        canEdit = coder.decodeBool(forKey: "canEdit")
        canResponse = coder.decodeBool(forKey: "canResponse")
        valueKey = coder.decodeObject(forKey: "valueKey") as? String
    }

    
    public func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(value, forKey: "value")
        coder.encode(subValue, forKey: "subValue")
        coder.encode(placeholder, forKey: "placeholder")
        coder.encode(keyboardType.rawValue, forKey: "keyboardType")
        coder.encode(canEdit, forKey: "canEdit")
        coder.encode(canResponse, forKey: "canResponse")
        coder.encode(valueKey, forKey: "valueKey")
    }
}
