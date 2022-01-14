//
//  SettingViewController.swift
//  BikPik
//
//  Created by jihee moon on 2021/10/18.
//

import UIKit
import SnapKit

class SettingViewController: UIViewController {
    
    let mngSetting = SettingManager.mngSetting
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubView()
        addTarget()
        setLayout()
        updateSetting()
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
    var labelAccount = UILabel()
    let btnAccount = UIButton()
    
    let viewTheme = UIView()
    let labelTheme = UILabel()
    let btnTheme = UIButton()
    let viewThemeDetail = UIView()
    let labelTimeTheme = UILabel()
    let swtTimeTheme = UISwitch()
    
    let viewStartSun = UIView()
    let labelStartSun = UILabel()
    let swtStartSun = UISwitch()
    
    let viewAutoDelete = UIView()
    let labelAutoDelete = UILabel()
    let swtAutoDelete = UISwitch()
    
    let viewTag = UIView()
    let labelTag = UILabel()
    let btnTag = UIButton()
    
    let offsetLabelTop = 5
    let offsetLeading = 15
    let offsetTrailling = -15
    let offsetTop = 20
    let heightClose = 56
    let hightTheme = 78
    let iconSize = 44
    
    func addSubView(){
        self.view.addSubview(contentsView)
        contentsView.addSubview(viewAccount)
        contentsView.addSubview(viewTheme)
        contentsView.addSubview(viewStartSun)
        contentsView.addSubview(viewAutoDelete)
        contentsView.addSubview(viewTag)
        
        viewAccount.addSubview(labelAccount)
        viewAccount.addSubview(btnAccount)
        
        viewTheme.addSubview(labelTheme)
        viewTheme.addSubview(btnTheme)
        viewTheme.addSubview(viewThemeDetail)
        viewThemeDetail.addSubview(labelTimeTheme)
        viewThemeDetail.addSubview(swtTimeTheme)
        
        viewStartSun.addSubview(labelStartSun)
        viewStartSun.addSubview(swtStartSun)
        
        viewAutoDelete.addSubview(labelAutoDelete)
        viewAutoDelete.addSubview(swtAutoDelete)
        
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
        viewAutoDelete.snp.makeConstraints { make in
            make.top.equalTo(viewStartSun.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(heightClose)
        }
        viewTag.snp.makeConstraints { make in
            make.top.equalTo(viewAutoDelete.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(heightClose)
        }
    }
    func viewLayoutResize(setting :OpenSetting, open: Bool) {
        var height = heightClose
        switch setting {
        case .theme:
            height = open ? hightTheme+50 : heightClose
            viewTheme.snp.remakeConstraints { make in
                make.height.equalTo(height)
            }
        case .delete:
            height = open ? hightTheme : heightClose
            viewAutoDelete.snp.remakeConstraints { make in
                make.height.equalTo(height)
            }
        case .tag:
            height = open ? hightTheme : heightClose
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
        viewAutoDelete.snp.makeConstraints { make in
            make.top.equalTo(viewStartSun.snp.bottom)
            make.width.equalToSuperview()
        }
        viewTag.snp.makeConstraints { make in
            make.top.equalTo(viewAutoDelete.snp.bottom)
            make.width.equalToSuperview()
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.contentsView.layoutIfNeeded()
        })
        
        var size = contentsView.frame.size
        size.height = viewTag.frame.maxY - contentsView.layer.frame.minY
        contentsView.contentSize = size
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
            make.width.height.equalTo(iconSize)
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
            make.width.height.equalTo(iconSize)
        }
        
        viewThemeDetail.backgroundColor = .yellow
        viewThemeDetail.snp.makeConstraints { make in
            make.top.equalTo(labelTheme.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(0)
        }
        
        labelTimeTheme.text = "시간 테마 적용"
        labelTimeTheme.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(offsetLeading)
            make.top.equalTo(labelTheme.snp.bottom).offset(offsetTop)
        }
        labelTimeTheme.isHidden = true
        
        swtTimeTheme.onTintColor = UIColor(named: "BikPik Color")
        swtTimeTheme.snp.makeConstraints { make in
            make.top.equalTo(labelTheme.snp.bottom).offset(offsetTop)
            make.trailing.equalToSuperview().offset(offsetTrailling)
        }
        swtTimeTheme.isHidden = true
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
        labelAutoDelete.text = "이전 데이터 자동 삭제"
        labelAutoDelete.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(offsetLabelTop)
            make.leading.equalToSuperview().offset(offsetLeading)
            
        }
        swtAutoDelete.onTintColor = UIColor(named: "BikPik Color")
        swtAutoDelete.snp.makeConstraints { make in
            make.centerY.equalTo(labelAutoDelete.snp.centerY)
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
            make.width.height.equalTo(iconSize)
        }
    }
    
    func addTarget() {
        btnAccount.addTarget(self, action: #selector(actionAccount(_:)), for: .touchUpInside)
        btnTheme.addTarget(self, action: #selector(self.actionTheme(_:)), for: .touchUpInside)
        swtStartSun.addTarget(self, action: #selector(self.actionStartSun(_:)), for: .touchUpInside)
        swtAutoDelete.addTarget(self, action: #selector(self.actionAutoDelete(_:)), for: .touchUpInside)
        btnTag.addTarget(self, action: #selector(self.actionTag(_:)), for: .touchUpInside)
    }
    
    func updateSetting() {
        mngSetting.LoadSetting()
        swtStartSun.isOn = mngSetting.data.startSun
        swtAutoDelete.isOn = mngSetting.data.autoDelete
    }
    
    @objc func actionAccount(_ sender: UIButton) {
        // 계정 뷰 컨트롤러 이동
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LogInVC") as! LogInViewController
        loginVC.modalPresentationStyle = .fullScreen
        loginVC.modalTransitionStyle = .crossDissolve
        present(loginVC, animated: true, completion: nil)
    }
    
    @objc func actionTheme(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            openTheme()
            viewLayoutResize(setting: .theme, open: true)
        } else {
            viewLayoutResize(setting: .theme, open: false)
            closeTheme()
        }
    }
    @objc func actionStartSun(_ sender: UISwitch) {
        let select = sender.isOn
        mngSetting.data.startSun = select
        mngSetting.SaveSetting()
    }
    @objc func actionAutoDelete(_ sender: UISwitch) {
        if sender.isOn {
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
    
    
    func openTheme() {
        viewThemeDetail.backgroundColor = UIColor(named: "BikPik Light Color")
        viewThemeDetail.layer.cornerRadius = 10
        labelTimeTheme.isHidden = false
        swtTimeTheme.isHidden = false
        
        viewThemeDetail.snp.remakeConstraints({ make in
            make.height.equalTo(hightTheme)
            make.top.equalTo(labelTheme.snp.bottom)
            make.width.equalToSuperview().offset(10)
        })
        
        labelTimeTheme.text = "시간 테마 적용"
        labelTimeTheme.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(offsetLeading)
            make.top.equalTo(labelTheme.snp.bottom).offset(offsetTop)
        }
        
        swtTimeTheme.onTintColor = UIColor(named: "BikPik Color")
        swtTimeTheme.snp.makeConstraints { make in
            make.top.equalTo(labelTheme.snp.bottom).offset(offsetTop)
            make.trailing.equalToSuperview().offset(offsetTrailling)
        }
        
    }
    func closeTheme() {
        viewThemeDetail.snp.remakeConstraints({ make in
            make.height.equalTo(0)
            make.top.equalTo(labelTheme.snp.bottom)
            make.width.equalToSuperview()
        })
        
        labelTimeTheme.isHidden = true
        swtTimeTheme.isHidden = true
    }
    func openDeleteData() {
    
    }
    func closeDeleteData() {
        
    }
}
