//
//  SettingViewController.swift
//  BikPik
//
//  Created by jihee moon on 2021/10/18.
//

import UIKit
import SnapKit

class SettingViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubView()
        addTarget()
        setLayout()
    }
    
    enum OpenSetting {
        case theme
        case delete
        case tag
    }
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBAction func navBtnBack(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    let contentsView = UIScrollView()
    let viewAccount = UIView()
    let labelAccount = UILabel()
    let btnAccount = UIButton()
    let viewTheme = UIView()
    let labelTheme = UILabel()
    let btnTheme = UIButton()
    let viewStartSun = UIView()
    let labelStartSun = UILabel()
    let swtStartSun = UISwitch()
    let viewDeleteData = UIView()
    let labelDeleteData = UILabel()
    let swtDeleteData = UISwitch()
    let viewTag = UIView()
    let labelTag = UILabel()
    let btnTag = UIButton()
    
    let offsetLabelTop = 5
    let offsetLeading = 15
    let offsetTrailling = -15
    let offsetTop = 20
    let heightClose = 56
    
    func addSubView(){
        self.view.addSubview(contentsView)
        contentsView.addSubview(viewAccount)
        contentsView.addSubview(viewTheme)
        contentsView.addSubview(viewStartSun)
        contentsView.addSubview(viewDeleteData)
        contentsView.addSubview(viewTag)
        
        viewAccount.addSubview(labelAccount)
        viewAccount.addSubview(btnAccount)
        viewTheme.addSubview(labelTheme)
        viewTheme.addSubview(btnTheme)
        viewStartSun.addSubview(labelStartSun)
        viewStartSun.addSubview(swtStartSun)
        viewDeleteData.addSubview(labelDeleteData)
        viewDeleteData.addSubview(swtDeleteData)
        viewTag.addSubview(labelTag)
        viewTag.addSubview(btnTag)
    }
    
    func setLayout(){
        contentsLayout()
        viewLayout()
        accountLayout()
        themeLayout()
        startSunLayout()
        deleteDataLayout()
        tagLayout()
    }
    
    func contentsLayout() {
        contentsView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(offsetTop)
            $0.bottom.equalTo(view.snp.bottom)
            $0.width.equalToSuperview()
        }
    }
    
    func viewLayout() {
        viewAccount.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(offsetTop)
            make.width.equalToSuperview()
            make.height.equalTo(heightClose)
        }
        viewTheme.snp.makeConstraints { make in
            make.top.equalTo(viewAccount.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(heightClose)
        }
        viewStartSun.snp.makeConstraints{ make in
            make.top.equalTo(viewTheme.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(heightClose)
        }
        viewDeleteData.snp.makeConstraints { make in
            make.top.equalTo(viewStartSun.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(heightClose)
        }
        viewTag.snp.makeConstraints { make in
            make.top.equalTo(viewDeleteData.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(heightClose)
        }
    }
    func viewLayoutResize(setting :OpenSetting, open: Bool) {
        var height = heightClose
        switch setting {
        case .theme:
            height = open ? 300 : heightClose
            viewTheme.snp.remakeConstraints { make in
                make.height.equalTo(height)
            }
        case .delete:
            height = open ? 300 : heightClose
            viewDeleteData.snp.remakeConstraints { make in
                make.height.equalTo(height)
            }
        case .tag:
            height = open ? 300 : heightClose
            viewTag.snp.remakeConstraints { make in
                make.height.equalTo(height)
            }
        }
        
        viewAccount.snp.remakeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(offsetTop)
            make.width.equalToSuperview()
            make.height.equalTo(heightClose)
        }
        viewTheme.snp.makeConstraints { make in
            make.top.equalTo(viewAccount.snp.bottom)
            make.width.equalToSuperview()
        }
        viewStartSun.snp.remakeConstraints{ make in
            make.top.equalTo(viewTheme.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(heightClose)
        }
        viewDeleteData.snp.makeConstraints { make in
            make.top.equalTo(viewStartSun.snp.bottom)
            make.width.equalToSuperview()
        }
        viewTag.snp.makeConstraints { make in
            make.top.equalTo(viewDeleteData.snp.bottom)
            make.width.equalToSuperview()
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.contentsView.layoutIfNeeded()
        })
    }
    
    func accountLayout() {
        labelAccount.text = "계정"
        labelAccount.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(offsetLabelTop)
            make.leading.equalToSuperview().offset(offsetLeading)
        }
        let img = UIImage(systemName: "arrow.right")
        btnAccount.setImage(img, for: .normal)
        btnAccount.tintColor = UIColor(named: "BikPik Color")
        btnAccount.snp.makeConstraints { make in
            make.centerY.equalTo(labelAccount.snp.centerY)
            make.trailing.equalToSuperview().offset(offsetTrailling)
        }
    }
    func themeLayout() {
        labelTheme.text = "테마"
        labelTheme.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(offsetLabelTop)
            make.leading.equalToSuperview().offset(offsetLeading)
        }
        let img = UIImage(systemName: "arrowtriangle.down.fill")
        btnTheme.setImage(img, for: .normal)
        btnTheme.snp.makeConstraints { make in
            make.centerY.equalTo(labelTheme.snp.centerY)
            make.trailing.equalToSuperview().offset(offsetTrailling)
        }
    }
    func startSunLayout() {
        labelStartSun.text = "달력 일요일 부터 시작하기"
        labelStartSun.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(offsetLabelTop)
            make.leading.equalToSuperview().offset(offsetLeading)
        }
        swtStartSun.onTintColor = UIColor(named: "BikPik Color")
        swtStartSun.snp.makeConstraints { make in
            make.centerY.equalTo(labelStartSun.snp.centerY)
            make.trailing.equalToSuperview().offset(offsetTrailling)
        }
    }
    func deleteDataLayout() {
        labelDeleteData.text = "이전 데이터 자동 삭제"
        labelDeleteData.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(offsetLabelTop)
            make.leading.equalToSuperview().offset(offsetLeading)
            
        }
        swtDeleteData.onTintColor = UIColor(named: "BikPik Color")
        swtDeleteData.snp.makeConstraints { make in
            make.centerY.equalTo(labelDeleteData.snp.centerY)
            make.trailing.equalToSuperview().offset(offsetTrailling)
        }
    }
    func tagLayout() {
        labelTag.text = "태그 관리"
        labelTag.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(offsetLabelTop)
            make.leading.equalToSuperview().offset(offsetLeading)
        }
        let img = UIImage(systemName: "arrowtriangle.down.fill")
        btnTag.setImage(img, for: .normal)
        btnTag.snp.makeConstraints { make in
            make.centerY.equalTo(labelTag.snp.centerY)
            make.trailing.equalToSuperview().offset(offsetTrailling)
        }
    }
    
    func addTarget() {
        btnAccount.addTarget(self, action: #selector(actionAccount(_:)), for: .touchUpInside)
        btnTheme.addTarget(self, action: #selector(self.actionTheme(_:)), for: .touchUpInside)
        swtStartSun.addTarget(self, action: #selector(self.actionStartSun(_:)), for: .touchUpInside)
        swtDeleteData.addTarget(self, action: #selector(self.actionDeleteData(_:)), for: .touchUpInside)
        btnTag.addTarget(self, action: #selector(self.actionTag(_:)), for: .touchUpInside)
    }
    
    @objc func actionAccount(_ sender: UIButton) {
        // 계정 뷰 컨트롤러 이동
    }
    @objc func actionTheme(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            viewLayoutResize(setting: .theme, open: true)
        } else {
            viewLayoutResize(setting: .theme, open: false)
        }
    }
    @objc func actionStartSun(_ sender: UISwitch) {
        
    }
    @objc func actionDeleteData(_ sender: UISwitch) {
        sender.isSelected.toggle()
        if sender.isSelected {
            viewLayoutResize(setting: .delete, open: true)
        } else {
            viewLayoutResize(setting: .delete, open: false)
        }
    }
    @objc func actionTag(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            viewLayoutResize(setting: .tag, open: true)
        } else {
            viewLayoutResize(setting: .tag, open: false)
        }
    }
}
