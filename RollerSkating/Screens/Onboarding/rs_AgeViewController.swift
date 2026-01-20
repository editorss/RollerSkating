//
//  rs_AgeViewController.swift
//  RollerSkating
//
//  年龄选择界面 - 滚轮选择器 18-50
//

import UIKit
import SnapKit

class rs_AgeViewController: UIViewController {
    
    // MARK: - Properties
    
    private let rs_ageRange = Array(18...50)
    private var rs_selectedAge: Int = 18
    
    /// 从上一页传递的性别
    var rs_gender: String = ""
    
    // MARK: - UI Elements
    
    /// 返回按钮
    private let rs_backBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "全局返回按钮"), for: .normal)
        return btn
    }()
    
    /// 标题
    private let rs_titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "How old are you"
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        return lbl
    }()
    
    /// 年龄选择器
    private let rs_agePicker: UIPickerView = {
        let pv = UIPickerView()
        return pv
    }()
    
    /// 选择框背景
    private let rs_selectionBgView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        v.layer.cornerRadius = 12
        return v
    }()
    
    /// Next按钮
    private let rs_nextBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "next按钮"), for: .normal)
        return btn
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rs_setupUI()
        rs_setupActions()
        rs_setupPicker()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Setup
    
    private func rs_setupUI() {
        view.backgroundColor = UIColor(red: 18/255, green: 0/255, blue: 48/255, alpha: 1)
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        view.addSubview(rs_backBtn)
        view.addSubview(rs_titleLabel)
        view.addSubview(rs_selectionBgView)
        view.addSubview(rs_agePicker)
        view.addSubview(rs_nextBtn)
        
        // 返回按钮
        rs_backBtn.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(44)
        }
        
        // 标题
        rs_titleLabel.snp.makeConstraints { make in
            make.top.equalTo(rs_backBtn.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        // 年龄选择器
        rs_agePicker.snp.makeConstraints { make in
            make.top.equalTo(rs_titleLabel.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(200)
        }
        
        // 选择框背景 - 居中显示
        rs_selectionBgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(rs_agePicker)
            make.width.equalTo(120)
            make.height.equalTo(50)
        }
        
        // Next按钮
        rs_nextBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
            make.height.equalTo(56)
        }
    }
    
    private func rs_setupPicker() {
        rs_agePicker.delegate = self
        rs_agePicker.dataSource = self
        // 延迟刷新确保初始选中行颜色正确
        DispatchQueue.main.async {
            self.rs_agePicker.reloadAllComponents()
        }
    }
    
    private func rs_setupActions() {
        rs_backBtn.addTarget(self, action: #selector(rs_backTapped), for: .touchUpInside)
        rs_nextBtn.addTarget(self, action: #selector(rs_nextTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func rs_backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func rs_nextTapped() {
        let playStyleVC = rs_PlayStyleViewController()
        playStyleVC.rs_gender = rs_gender
        playStyleVC.rs_age = rs_selectedAge
        navigationController?.pushViewController(playStyleVC, animated: true)
    }
}

// MARK: - UIPickerViewDelegate & DataSource

extension rs_AgeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return rs_ageRange.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.text = "\(rs_ageRange[row])"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        // 选中行显示黑色（白色背景），其他行显示白色
        let selectedRow = pickerView.selectedRow(inComponent: component)
        label.textColor = (row == selectedRow) ? .white : .white
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        rs_selectedAge = rs_ageRange[row]
        // 刷新所有行的颜色
        pickerView.reloadAllComponents()
    }
    
}
