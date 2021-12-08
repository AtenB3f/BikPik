//
//  CalendarViewController.swift
//  BikPik
//
//  Created by jihee moon on 2021/06/14.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate{
    
    

    override func viewDidLoad() {
    super.viewDidLoad()
        /*
        let height: CGFloat = 300
        let calendar = FSCalendar(frame: CGRect(x: 0, y: 20, width: view.frame.size.width, height: height))
        calendar.dataSource = self
        calendar.delegate = self
        calendar.allowsMultipleSelection = true
        view.addSubview(calendar)
        self.calendar = calendar
        calendar.register(CustomCalendarCell.self, forCellReuseIdentifier: "cell")
        self.calendar.accessibilityIdentifier = "calendar"
         */
    }
    /*
     fileprivate let gregorian = Calendar(identifier: .gregorian)
        fileprivate let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()
     
     
     var calendar: FSCalendar!
     
    // MARK:- FSCalendarDataSource
        
        func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
            let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
            print("1")
            return cell
        }
        
        func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
            self.configure(cell: cell, for: date, at: position)
            print("2")
        }
        
        func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
            if self.gregorian.isDateInToday(date) {
                return "今"
            }
            return nil
        }
        
        func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
            return 1
        }
        
        // MARK:- FSCalendarDelegate
        
        func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
            self.calendar.frame.size.height = bounds.height
        }
        
        func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition)   -> Bool {
            return monthPosition == .current
        }
        
        func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
            return monthPosition == .current
        }
        
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            print("did select date \(date)")

        }
        
        func calendar(_ calendar: FSCalendar, didDeselect date: Date) {
            print("did deselect date \(date)")

        }
        
        func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
            if self.gregorian.isDateInToday(date) {
                return [UIColor.orange]
            }
            return [appearance.eventDefaultColor]
        }
    
    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
            
        let diyCell = cell as! CustomCalendarCell
            // Custom today circle
            diyCell.circleImageView.isHidden = !self.gregorian.isDateInToday(date)
            // Configure selection layer
            if position == .current {
                
                var selectionType = SelectionType.none
                
                if calendar.selectedDates.contains(date) {
                    let previousDate = self.gregorian.date(byAdding: .day, value: -1, to: date)!
                    let nextDate = self.gregorian.date(byAdding: .day, value: 1, to: date)!
                    if calendar.selectedDates.contains(date) {
                        if calendar.selectedDates.contains(previousDate) && calendar.selectedDates.contains(nextDate) {
                            selectionType = .middle
                        }
                        else if calendar.selectedDates.contains(previousDate) && calendar.selectedDates.contains(date) {
                            selectionType = .rightBorder
                        }
                        else if calendar.selectedDates.contains(nextDate) {
                            selectionType = .leftBorder
                        }
                        else {
                            selectionType = .single
                        }
                    }
                }
                else {
                    selectionType = .none
                }
                if selectionType == .none {
                    diyCell.selectionLayer.isHidden = true
                    return
                }
                diyCell.selectionLayer.isHidden = false
                diyCell.selectionType = selectionType
                
            } else {
                diyCell.circleImageView.isHidden = true
                diyCell.selectionLayer.isHidden = true
            }
        }
     */
}
