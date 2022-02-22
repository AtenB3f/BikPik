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
    let mngFirebase = Firebase.mngFirebase
    let mngAccount = AccountManager.mngAccount
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        addTarget()
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
    
    let scrollView = UIScrollView()
    let contentsView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 0
        view.distribution = .fill
        return view
    }()
    
    let viewAccount = UIView()
    var labelAccount: UILabel = {
        let label = UILabel()
        label.text = "계정"
        return label
    }()
    let btnAccount:UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "arrow.right")
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(named: "BikPik Color")
        return button
    }()
    
    let viewStartSunday = UIView()
    let labelStartSunday:UILabel = {
        let label = UILabel()
        label.text = "달력 일요일부터 시작하기"
        return label
    }()
    let swtStartSunday:UISwitch = {
        let swt = UISwitch()
        swt.onTintColor = UIColor(named: "BikPik Color")
        return swt
    }()
    
    let viewTheme = UIView()
    let labelTheme: UILabel = {
        let label = UILabel()
        label.text = "시간 테마 적용"
        return label
    }()
    let swtTheme: UISwitch = {
        let swt = UISwitch()
        swt.onTintColor = UIColor(named: "BikPik Color")
        return swt
    }()
    
    let viewAutoDelete = UIView()
    let labelAutoDelete: UILabel = {
        let label = UILabel()
        label.text = "1년 지난 데이터 자동 삭제"
        return label
    }()
    let swtAutoDelete:UISwitch = {
        let swt = UISwitch()
        swt.onTintColor = UIColor(named: "BikPik Color")
        return swt
    }()
    
    let viewTag = UIView()
    let labelTag:UILabel = {
        let label = UILabel()
        label.text = "태그"
        return label
    }()
    let btnTag:UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "arrowtriangle.down.fill")
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(named: "BikPik Color")
        return button
    }()
    
    let emptyView = UIView()
    
    private func setScrollView() {
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    private func setStackView() {
        scrollView.addSubview(contentsView)
        contentsView.snp.makeConstraints { make in
            make.width.height.centerX.centerY.equalToSuperview()
        }
    }
    
    let offsetLabelTop = 5
    let offsetLeading = 15
    let offsetTrailling = -15
    let offsetTop = 20
    let heightClose = 56
    let hightTheme = 78
    let iconSize = 44
    
    let leading = 20.0
    let heightObject = 44.0
    
    private func setLayout(){
        setScrollView()
        setStackView()
        setViewObject(view: viewAccount, label: labelAccount, button: btnAccount)
        setViewObject(view: viewStartSunday, label: labelStartSunday, swit: swtStartSunday)
        contentsView.addArrangedSubview(emptyView)
    }
    
    private func setViewObject(view: UIView, label: UILabel, button: UIButton) {
        contentsView.addArrangedSubview(view)
        view.snp.makeConstraints { make in
            make.height.equalTo(heightObject)
            make.width.equalToSuperview()
        }
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(leading)
            make.height.equalTo(heightObject)
            make.centerY.equalToSuperview()
        }
        
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.height.equalTo(heightObject)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-leading)
        }
    }
    
    private func setViewObject(view: UIView, label: UILabel, swit: UISwitch) {
        contentsView.addArrangedSubview(view)
        view.snp.makeConstraints { make in
            make.height.equalTo(heightObject)
            make.width.equalToSuperview()
        }
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(leading)
            make.height.equalTo(heightObject)
            make.centerY.equalToSuperview()
        }
        
        view.addSubview(swit)
        swit.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-leading)
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
        viewStartSunday.snp.remakeConstraints{ make in
            make.top.equalTo(viewTheme.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(heightClose)
        }
        viewAutoDelete.snp.makeConstraints { make in
            make.top.equalTo(viewStartSunday.snp.bottom)
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
        //contentsView.contentSize = size
    }
    
    func addTarget() {
        let gestureAccount = UITapGestureRecognizer(target: self, action: #selector(actionAccount(_:)))
        viewAccount.addGestureRecognizer(gestureAccount)
        btnAccount.addTarget(self, action: #selector(actionAccount(_:)), for: .touchUpInside)
        //swtTheme.addTarget(self, action: #selector(self.actionTheme(_:)), for: .touchUpInside)
        swtStartSunday.addTarget(self, action: #selector(self.actionStartSun(_:)), for: .touchUpInside)
        //swtAutoDelete.addTarget(self, action: #selector(self.actionAutoDelete(_:)), for: .touchUpInside)
        //btnTag.addTarget(self, action: #selector(self.actionTag(_:)), for: .touchUpInside)
    }
    
    func updateSetting() {
        mngSetting.LoadSetting()
        swtStartSunday.isOn = mngSetting.data.startSun
        swtAutoDelete.isOn = mngSetting.data.autoDelete
    }
    
    @objc func actionAccount(_ sender: UIButton) {
        // 계정 뷰 컨트롤러 이동
        var vc: UIViewController? = nil
        
        if mngAccount.account.value.email == nil {
            vc = self.storyboard?.instantiateViewController(withIdentifier: "LogInVC") as! LogInViewController
        } else if !mngFirebase.isAuthEmailVerified() {
            vc = self.storyboard?.instantiateViewController(withIdentifier: "EmailAuthVC") as! EmailAuthViewController
        } else {
            vc = self.storyboard?.instantiateViewController(withIdentifier: "AccountVC") as! AccountViewController
        }
        vc!.modalPresentationStyle = .fullScreen
        vc!.modalTransitionStyle = .crossDissolve
        present(vc!, animated: true, completion: nil)
    }
    
    @objc func actionTheme(_ sender: UIButton) {
        sender.isSelected.toggle()
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
    
}
