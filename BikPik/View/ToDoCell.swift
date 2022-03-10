//
//  ToDoCell.swift
//  BikPik
//
//  Created by jihee moon on 2022/03/08.
//

import UIKit

enum CellType {
    case ToDo
    case Habit
}

class ToDoCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let btnDone:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "CheckBox.png"), for: .normal)
        button.tintColor = UIColor(named: "TextLightColor")
        button.addTarget(self, action: #selector(actionDone), for: .touchUpInside)
        return button
    }()
    let labelTime: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = UIColor(named: "TextLightColor")
        return label
    }()
    let labelTask: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor(named: "TextLightColor")
        return label
    }()
    let btnSetting: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        button.tintColor = UIColor(named: "TextLightColor")
        return button
    }()
    
    func setLayout() {
        contentView.snp.makeConstraints { make in
            make.height.equalTo(40.0)
            make.left.right.equalTo(safeAreaInsets)
        }
        
        contentView.addSubview(btnDone)
        btnDone.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20.0)
            make.width.height.equalTo(18.0)
        }
        
        contentView.addSubview(btnSetting)
        btnSetting.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(20.0)
            make.width.height.equalTo(18.0)
        }
        
        contentView.addSubview(labelTime)
        labelTime.snp.makeConstraints { make in
            make.centerY.height.equalToSuperview()
            make.left.equalTo(btnDone.snp.right).offset(8.0)
            make.width.equalTo(60.0)
        }
        
        contentView.addSubview(labelTask)
        labelTask.snp.makeConstraints { make in
            make.centerY.height.equalToSuperview()
            make.left.equalTo(labelTime.snp.right).offset(8.0)
            make.right.equalTo(btnSetting.snp.left).offset(-8.0)
        }
    }
    
    @objc func actionDone() {
        btnDone.isSelected.toggle()
        displayDone(done: btnDone.isSelected)
    }
    func displayDone(done: Bool) {
        btnDone.isSelected = done
        labelTask.textColor = UIColor(named: "TextLightColor") ?? .lightText
        labelTime.textColor = UIColor(named: "TextLightColor") ?? .lightText
        
        if done {
            btnDone.setImage(UIImage(named: "CheckBox_fill.png")?.withRenderingMode(.alwaysTemplate), for: .normal)
            btnDone.tintColor = UIColor(named: "BikPik Dark Color")
            labelTask.attributedText = NSAttributedString(
                                    string: self.labelTask.text ?? ""  ,
                                    attributes: [NSAttributedString.Key.strikethroughStyle : NSUnderlineStyle.single.rawValue])
        } else {
            btnDone.setImage(UIImage(named: "CheckBox.png")?.withRenderingMode(.alwaysTemplate), for: .normal)
            btnDone.tintColor = UIColor(named: "TextLightColor")
            labelTask.attributedText = NSAttributedString(
                                    string: self.labelTask.text ?? "" ,
                                    attributes: [NSAttributedString.Key.strikethroughStyle:NSUnderlineStyle.byWord])
        }
    }
    
    func updateCell(indexPathRow row: Int, name: String, done: Bool, time: String, type: CellType) {
        displayDone(done: done)
        switch type {
        case .ToDo:
            btnSetting.setImage(UIImage(systemName: "x.circle"), for: .normal)
        case .Habit:
            btnSetting.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        }
        self.labelTask.text = name
        self.labelTime.text = time
        self.btnDone.tag = row
        self.btnSetting.tag = row
    }
}
