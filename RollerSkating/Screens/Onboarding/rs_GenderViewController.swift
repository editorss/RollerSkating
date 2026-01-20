//
//  rs_GenderViewController.swift
//  RollerSkating
//
//  性别选择界面 - BOY/Girl选择
//

import UIKit
import SnapKit

class rs_GenderViewController: UIViewController {
    
    // MARK: - Properties
    
    private var rs_selectedGender: String? = nil
    
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
        lbl.text = "What is your gender"
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        return lbl
    }()
    
    /// BOY按钮
    private let rs_boyBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "BOY未选中"), for: .normal)
        btn.setImage(UIImage(named: "BOY选中"), for: .selected)
        btn.imageView?.contentMode = .scaleAspectFit
        return btn
    }()
    
    /// Girl按钮
    private let rs_girlBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "Girl未选中"), for: .normal)
        btn.setImage(UIImage(named: "Girl选中"), for: .selected)
        btn.imageView?.contentMode = .scaleAspectFit
        return btn
    }()
    
    /// 性别选择容器
    private let rs_genderStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 24
        sv.alignment = .center
        sv.distribution = .fill
        return sv
    }()
    
    /// Next按钮
    private let rs_nextBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "next按钮"), for: .normal)
        btn.alpha = 0.4  // 默认半透明
        btn.isEnabled = false
        return btn
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rs_setupUI()
        rs_setupActions()
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
        view.addSubview(rs_genderStack)
        view.addSubview(rs_nextBtn)
        
        rs_genderStack.addArrangedSubview(rs_boyBtn)
        rs_genderStack.addArrangedSubview(rs_girlBtn)
        
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
        
        // 性别选择 - 居中
        rs_genderStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(rs_titleLabel.snp.bottom).offset(60)
        }
        
        // BOY和Girl按钮尺寸
        rs_boyBtn.snp.makeConstraints { make in
            make.width.equalTo(140)
            make.height.equalTo(160)
        }
        
        rs_girlBtn.snp.makeConstraints { make in
            make.width.equalTo(140)
            make.height.equalTo(160)
        }
        
        // Next按钮
        rs_nextBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
            make.height.equalTo(56)
        }
    }
    
    private func rs_setupActions() {
        rs_backBtn.addTarget(self, action: #selector(rs_backTapped), for: .touchUpInside)
        rs_boyBtn.addTarget(self, action: #selector(rs_boyTapped), for: .touchUpInside)
        rs_girlBtn.addTarget(self, action: #selector(rs_girlTapped), for: .touchUpInside)
        rs_nextBtn.addTarget(self, action: #selector(rs_nextTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func rs_backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func rs_boyTapped() {
        rs_selectedGender = "boy"
        rs_boyBtn.isSelected = true
        rs_girlBtn.isSelected = false
        rs_updateNextBtnState()
    }
    
    @objc private func rs_girlTapped() {
        rs_selectedGender = "girl"
        rs_boyBtn.isSelected = false
        rs_girlBtn.isSelected = true
        rs_updateNextBtnState()
    }
    
    private func rs_updateNextBtnState() {
        let isSelected = rs_selectedGender != nil
        rs_nextBtn.isEnabled = isSelected
        rs_nextBtn.alpha = isSelected ? 1.0 : 0.4
    }
    
    @objc private func rs_nextTapped() {
        guard let gender = rs_selectedGender else { return }
        let ageVC = rs_AgeViewController()
        ageVC.rs_gender = gender
        navigationController?.pushViewController(ageVC, animated: true)
    }
}
