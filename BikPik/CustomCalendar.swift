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
}

enum SelectionType : Int {
    case none
    case single
    case leftBorder
    case middle
    case rightBorder
}

class CustomCalendar: FSCalendar{
    init(style:CalendarStyle, frame:CGRect) {
        super.init(frame: frame)
        
        switch(style){
        case .month:
            self.SetMonthLayout()
            break
        case .week:
            self.SetWeekLayout()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func SetWeekLayout() {
        super.appearance.headerMinimumDissolvedAlpha = 0.0
    }
    
    func SetMonthLayout() {
        super.contentView.backgroundColor = .white
        super.contentView.layer.borderColor = UIColor(named: "BikPik Color")?.cgColor
        super.contentView.layer.borderWidth = 1.5
        super.contentView.layer.cornerRadius = 10.0
        super.appearance.headerTitleColor = UIColor(named: "BikPik Dark Color")
        super.appearance.headerTitleFont = UIFont.systemFont(ofSize: 14.0)
        super.appearance.selectionColor = UIColor(named: "BikPik Color")
        super.appearance.todayColor = UIColor(named: "BikPik Color")
        super.appearance.titleTodayColor = .white
        super.appearance.weekdayFont = UIFont.systemFont(ofSize: 14.0, weight: .bold)
        super.appearance.weekdayTextColor = UIColor(named: "BikPik Dark Color")
        super.appearance.headerMinimumDissolvedAlpha = 0.0
        super.appearance.titleDefaultColor = .darkGray
        super.appearance.caseOptions = .weekdayUsesSingleUpperCase
    }
}

class CustomCalendarCell: FSCalendarCell {
    weak var circleImageView: UIImageView!
        weak var selectionLayer: CAShapeLayer!
        
        var selectionType: SelectionType = .none {
            didSet {
                setNeedsLayout()
            }
        }
    override init(frame: CGRect) {
            super.init(frame: frame)
            
            let circleImageView = UIImageView(image: UIImage(named: "CheckBox.png")!)
            self.contentView.insertSubview(circleImageView, at: 0)
            self.circleImageView = circleImageView
            
            let selectionLayer = CAShapeLayer()
            selectionLayer.fillColor = UIColor.black.cgColor
            selectionLayer.actions = ["hidden": NSNull()]
            self.contentView.layer.insertSublayer(selectionLayer, below: self.titleLabel!.layer)
            self.selectionLayer = selectionLayer
            
            self.shapeLayer.isHidden = true
            
            let view = UIView(frame: self.bounds)
            view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.12)
            self.backgroundView = view;
            
        }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.circleImageView.frame = self.contentView.bounds
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
    
    override func configureAppearance() {
        super.configureAppearance()
        // Override the build-in appearance configuration
        if self.isPlaceholder {
            self.eventIndicator.isHidden = true
            self.titleLabel.textColor = UIColor.lightGray
        }
    }
}


