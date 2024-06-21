//
//  EYPickerConfigProtocol.swift
//  ECommon
//
//  Created by empty on 2024/6/21.
//

import Foundation
public protocol EYPickerConfigDelegare: NSObjectProtocol  {
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
}

public protocol EYDatePickerConfigDelegare: EYPickerConfigDelegare  {
    var datePickerMode: UIDatePickerMode { get set }
    var minDate: Date? { get set }
    var maxDate: Date? { get set }
    var currentDate: Date? { get set }
}

