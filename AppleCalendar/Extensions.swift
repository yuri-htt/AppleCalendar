//
//  Extensions.swift
//  AppleCalendar
//
//  Created by 田山　由理 on 2016/12/27.
//  Copyright © 2016年 Yuri Tayama. All rights reserved.
//

import UIKit


extension UIColor {
    convenience init(colorWithHexValue value: Int, alpha:CGFloat = 1.0){
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}

func delayRunOnMainThread(_ delay: Double, closure: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() +
            Double(Int64(delay * Double(NSEC_PER_SEC))) /
            Double(NSEC_PER_SEC), execute: closure)
}

func delayRunOnGlobalThread(_ delay: Double,
                            qos: DispatchQoS.QoSClass,
                            closure: @escaping () -> ()) {
    DispatchQueue.global(qos: qos).asyncAfter(
        deadline: DispatchTime.now() +
            Double(Int64(delay * Double(NSEC_PER_SEC))) /
            Double(NSEC_PER_SEC), execute: closure
    )
}
