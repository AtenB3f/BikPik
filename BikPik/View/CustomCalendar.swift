//
//  CustomCalendar.swift
//  BikPik
//
//  Created by jihee moon on 2021/11/09.
//

//import UIKit
import FSCalendar

enum CalendarStyle{
    case month
    case week
    case habit
}

class CustomCalendar: FSCalendar{
    init(style:CalendarStyle, frame:CGRect) {
        super.init(frame: frame)
        
        setLayout()
        switch(style){
        case .month:
            self.setMonthLayout()
            break
        case .week:
            self.setWeekLayout()
            break
        case .habit:
            self.setHabitLayout()
            break
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let mngSetting = SettingManager.mngSetting
    
    func setLayout() {
        if mngSetting.data.startSun {
            super.firstWeekday = 1
        } else {
            super.firstWeekday = 2
        }
    }
    
    func setWeekLayout() {
        super.appearance.headerMinimumDissolvedAlpha = 0.0
    }
    
    func setMonthLayout() {
        super.contentView.backgroundColor = .systemBackground
        super.contentView.layer.borderColor = UIColor(named: "BikPik Color")?.cgColor
        super.contentView.layer.borderWidth = 1.5
        super.contentView.layer.cornerRadius = 10.0
        super.appearance.headerTitleColor = UIColor(named: "BikPik Dark Color")
        super.appearance.headerTitleFont = UIFont.systemFont(ofSize: 14.0)
        super.appearance.selectionColor = UIColor(named: "BikPik Color")
        super.appearance.todayColor = UIColor(named: "BikPik Light Color")
        super.appearance.titleTodayColor = UIColor(named: "BikPik Dark Color")
        super.appearance.weekdayFont = UIFont.systemFont(ofSize: 14.0, weight: .bold)
        super.appearance.weekdayTextColor = UIColor(named: "BikPik Dark Color")
        super.appearance.titleDefaultColor = UIColor(named: "TextLightColor")
        super.appearance.headerMinimumDissolvedAlpha = 0.0
        super.appearance.caseOptions = .weekdayUsesSingleUpperCase
    }
    
    func setHabitLayout() {
        super.contentView.backgroundColor = .systemBackground
        super.contentView.layer.borderColor = UIColor(named: "BikPik Color")?.cgColor
        super.contentView.layer.borderWidth = 1.5
        super.contentView.layer.cornerRadius = 10.0
        super.appearance.headerTitleColor = UIColor(named: "BikPik Dark Color")
        super.appearance.headerTitleFont = UIFont.systemFont(ofSize: 14.0)
        super.appearance.selectionColor = UIColor(named: "BikPik Color")
        super.appearance.todayColor = UIColor(named: "BikPik Light Color")
        super.appearance.titleTodayColor = UIColor(named: "BikPik Dark Color")
        super.appearance.weekdayFont = UIFont.systemFont(ofSize: 14.0, weight: .bold)
        super.appearance.titleDefaultColor = UIColor(named: "TextLightColor")
        super.appearance.weekdayTextColor = UIColor(named: "BikPik Dark Color")
        super.appearance.headerMinimumDissolvedAlpha = 0.0
        super.appearance.caseOptions = .weekdayUsesSingleUpperCase
    }
    
    func setLayoutMutiSelected(start: Date, end: Date, date: Date) {
        
    }
}

 
 enum SelectionType : Int {
     case none
     case single
     case leftBorder
     case middle
     case rightBorder
 }
 
class CustomCalendarCell: FSCalendarCell {
    weak var selectionLayer: CAShapeLayer!
    var hide:Bool = false
    
    var selectionType: SelectionType = .none {
        didSet {
            setLayout()
            setNeedsLayout()
        }
    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.selectionLayer.fillColor = UIColor.systemBackground.cgColor
        selectionType = .none
    }
    
    func setLayout() {
        let selectionLayer = CAShapeLayer()
        selectionLayer.fillColor = UIColor(named: "BikPik Color")?.cgColor
        self.selectionLayer = selectionLayer
        self.contentView.layer.insertSublayer(selectionLayer, below: self.titleLabel!.layer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setCellLayout()
    }
    
    func setCellLayout() {
        self.backgroundView?.frame = self.bounds.insetBy(dx: 1, dy: 1)
        self.selectionLayer.frame = self.contentView.bounds
        
        if selectionType == .middle {
            self.selectionLayer.path = UIBezierPath(rect: self.selectionLayer.bounds).cgPath
        }
        else if selectionType == .leftBorder {
            self.selectionLayer.path = UIBezierPath(roundedRect: self.selectionLayer.bounds, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: self.selectionLayer.frame.width / 2, height: self.selectionLayer.frame.width / 2)).cgPath
        }
        else if selectionType == .rightBorder {
            self.selectionLayer.path = UIBezierPath(roundedRect: self.selectionLayer.bounds, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: self.selectionLayer.frame.width / 2, height: self.selectionLayer.frame.width / 2)).cgPath
        }
        else if selectionType == .single {
            let diameter: CGFloat = min(self.selectionLayer.frame.height, self.selectionLayer.frame.width)
            self.selectionLayer.path = UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter / 2, y: self.contentView.frame.height / 2 - diameter / 2, width: diameter, height: diameter)).cgPath
        }
    }
}
