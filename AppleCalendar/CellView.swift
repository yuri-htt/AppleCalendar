//
//  CellView.swift
//  AppleCalendar
//
//  Created by 田山　由理 on 2016/12/27.
//  Copyright © 2016年 Yuri Tayama. All rights reserved.
//

import JTAppleCalendar

class CellView: JTAppleDayCellView {
    @IBOutlet var selectedTopView: AnimationView!
    
    @IBOutlet weak var selectedBottonView: UIView!
    
    @IBOutlet weak var selectedLeftView: UIView!
    
    @IBOutlet weak var selectedRightView: UIView!
    
    @IBOutlet var dayLabel: UILabel!
    
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var eventView: UIView!
}
