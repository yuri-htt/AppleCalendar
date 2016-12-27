//
//  ViewController.swift
//  AppleCalendar
//
//  Created by 田山　由理 on 2016/12/27.
//  Copyright © 2016年 Yuri Tayama. All rights reserved.
//

import UIKit
import JTAppleCalendar

class ViewController: UIViewController {

    var numberOfRows = 5
    let formatter = DateFormatter()
    var testCalendar = Calendar.current
    var generateInDates: InDateCellGeneration = .forAllMonths
    var generateOutDates: OutDateCellGeneration = .tillEndOfGrid
    let firstDayOfWeek: DaysOfWeek = .sunday
    let disabledColor = UIColor.lightGray
    let enabledColor = UIColor.blue
    let dateCellSize: CGFloat? = nil
    
    let red = UIColor.red
    let white = UIColor.white
    let black = UIColor.black
    let gray = UIColor.gray
    let shade = UIColor(colorWithHexValue: 0x4E4E4E)
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var monthLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = testCalendar.timeZone
        formatter.locale = testCalendar.locale
        
        // Setting up your dataSource and delegate is manditory
        // ___________________________________________________________________
        calendarView.delegate = self
        calendarView.dataSource = self
        
        
        // ___________________________________________________________________
        // Registering your cells is manditory
        // ___________________________________________________________________
        calendarView.registerCellViewXib(file: "CellView")
        
        calendarView.cellInset = CGPoint(x: 0, y: 0)
        
        calendarView.visibleDates { (visibleDates: DateSegmentInfo) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
        
        calendarView.direction = .vertical
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        guard let startDate = visibleDates.monthDates.first else {
            return
        }
        let month = testCalendar.dateComponents([.month], from: startDate).month!
        let monthName = DateFormatter().monthSymbols[(month-1) % 12]
        // 0 indexed array
        let year = testCalendar.component(.year, from: startDate)
        monthLabel.text = monthName + " " + String(year)
    }
    
    // Function to handle the text color of the calendar
    func handleCellTextColor(view: JTAppleDayCellView?, cellState: CellState) {
        
        guard let myCustomCell = view as? CellView  else {
            return
        }
        
        if cellState.isSelected {
            myCustomCell.dayLabel.textColor = black
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                myCustomCell.dayLabel.textColor = black
            } else {
                myCustomCell.dayLabel.textColor = gray
            }
        }
        let before20Days = NSDate(timeIntervalSinceNow: -60 * 60 * 24 * 20)
        let before14Days = NSDate(timeIntervalSinceNow: -60 * 60 * 24 * 14)
        let before9Days = NSDate(timeIntervalSinceNow: -60 * 60 * 24 * 9)
        let before5Days = NSDate(timeIntervalSinceNow: -60 * 60 * 24 * 5)
        let yesterday = NSDate(timeIntervalSinceNow: -60 * 60 * 24)
        let tomorrow = NSDate(timeIntervalSinceNow: 60 * 60 * 24)
        
        if cellState.date == before20Days as Date {
            myCustomCell.gameView.isHidden = false
            myCustomCell.eventView.isHidden = true
        }
        if cellState.date == before14Days as Date {
            myCustomCell.gameView.isHidden = false
            myCustomCell.eventView.isHidden = false
        }
        if cellState.date == before5Days as Date {
            myCustomCell.gameView.isHidden = false
            myCustomCell.eventView.isHidden = true
        }
        if cellState.date == yesterday as Date {
            myCustomCell.gameView.isHidden = true
            myCustomCell.eventView.isHidden = false
        }
        if cellState.date == tomorrow as Date {
            myCustomCell.gameView.isHidden = false
            myCustomCell.eventView.isHidden = true
        }
    }
    
    // Function to handle the calendar selection
    func handleCellSelection(view: JTAppleDayCellView?, cellState: CellState) {
        guard let myCustomCell = view as? CellView  else {
            return
        }
        if cellState.isSelected {
            myCustomCell.selectedTopView.isHidden = false
            myCustomCell.selectedBottonView.isHidden = false
            myCustomCell.selectedRightView.isHidden = false
            myCustomCell.selectedLeftView.isHidden = false
        } else {
            myCustomCell.selectedTopView.isHidden = true
            myCustomCell.selectedBottonView.isHidden = true
            myCustomCell.selectedRightView.isHidden = true
            myCustomCell.selectedLeftView.isHidden = true
        }
        myCustomCell.gameView.isHidden = false
        myCustomCell.eventView.isHidden = false
        
    }
    
}

// MARK : JTAppleCalendarDelegate
extension ViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        let startDate = formatter.date(from: "2016 12 01")!
        let endDate = formatter.date(from: "2026 10 01")!
        
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: numberOfRows,
                                                 calendar: testCalendar,
                                                 generateInDates: generateInDates,
                                                 generateOutDates: generateOutDates,
                                                 firstDayOfWeek: firstDayOfWeek)
        
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplayCell cell: JTAppleDayCellView, date: Date, cellState: CellState) {
        
        let myCustomCell = cell as! CellView
        myCustomCell.dayLabel.text = cellState.text
        
        
        if testCalendar.isDateInToday(date) {
            myCustomCell.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        } else {
            myCustomCell.backgroundColor = white
        }
        
        handleCellSelection(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        handleCellSelection(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        handleCellSelection(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        
        print(formatter.string(from: date))
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        self.setupViewsOfCalendar(from: visibleDates)
    }
    
    func scrollDidEndDecelerating(for calendar: JTAppleCalendarView) {
        self.setupViewsOfCalendar(from: calendarView.visibleDates())
    }
    
    func calendar(_ calendar: JTAppleCalendarView, sectionHeaderIdentifierFor range: (start: Date, end: Date), belongingTo month: Int) -> String {
        if month % 2 > 0 {
            return "WhiteSectionHeaderView"
        }
        return "PinkSectionHeaderView"
    }
    
    func calendar(_ calendar: JTAppleCalendarView, sectionHeaderSizeFor range: (start: Date, end: Date), belongingTo month: Int) -> CGSize {
        if month % 2 > 0 {
            return CGSize(width: 200, height: 50)
        } else {
            // Yes you can have different size headers
            return CGSize(width: 200, height: 100)
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplaySectionHeader header: JTAppleHeaderView, range: (start: Date, end: Date), identifier: String) {
//        switch identifier {
//        case "WhiteSectionHeaderView":
//            let headerCell = header as? WhiteSectionHeaderView
//            headerCell?.title.text = "Design multiple headers"
//        default:
//            let headerCell = header as? PinkSectionHeaderView
//            headerCell?.title.text = "In any color or size you want"
//        }
    }
}


