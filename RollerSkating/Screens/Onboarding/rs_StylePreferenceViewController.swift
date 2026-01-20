//
//  rs_StylePreferenceViewController.swift
//  RollerSkating
//
//  风格偏好选择界面 - Which kind of cool do you prefer
//

import UIKit
import SnapKit

class rs_StylePreferenceViewController: UIViewController {
    
    // MARK: - Properties
    
    private let rs_styleOptions = [
        "Smooth & Flow",
        "Fast & Powerful",
        "Tricks & Style",
        "Urban & Street",
        "Chill & Clean"
    ]
    
    private var rs_selectedIndex: Int? = 0  // 默认选中第一个
    
    /// 从前面页面传递的数据
    var rs_gender: String = ""
    var rs_age: Int = 18
    var rs_playStyle: String = ""
    
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
        lbl.text = "Which kind of cool do\nyou prefer"
        lbl.numberOfLines = 2
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        return lbl
    }()
    
    /// 选项列表
    private let rs_tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.isScrollEnabled = false
        return tv
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
        rs_setupTableView()
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
        view.addSubview(rs_tableView)
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
        
        // 选项列表
        rs_tableView.snp.makeConstraints { make in
            make.top.equalTo(rs_titleLabel.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalTo(rs_nextBtn.snp.top).offset(-20)
        }
        
        // Next按钮
        rs_nextBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
            make.height.equalTo(56)
        }
    }
    
    private func rs_setupTableView() {
        rs_tableView.delegate = self
        rs_tableView.dataSource = self
        rs_tableView.register(rs_StyleOptionCell.self, forCellReuseIdentifier: rs_StyleOptionCell.rs_identifier)
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
        let completionVC = rs_CompletionViewController()
        completionVC.rs_gender = rs_gender
        completionVC.rs_age = rs_age
        completionVC.rs_playStyle = rs_playStyle
        completionVC.rs_stylePreference = rs_styleOptions[rs_selectedIndex ?? 0]
        navigationController?.pushViewController(completionVC, animated: true)
    }
}

// MARK: - UITableViewDelegate & DataSource

extension rs_StylePreferenceViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rs_styleOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: rs_StyleOptionCell.rs_identifier, for: indexPath) as! rs_StyleOptionCell
        let isSelected = rs_selectedIndex == indexPath.row
        cell.rs_configure(title: rs_styleOptions[indexPath.row], isChecked: isSelected)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rs_selectedIndex = indexPath.row
        tableView.reloadData()
    }
}

// MARK: - Style Option Cell

class rs_StyleOptionCell: UITableViewCell {
    
    static let rs_identifier = "rs_StyleOptionCell"
    
    private let rs_titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return lbl
    }()
    
    private let rs_checkImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "选中勾选")
        iv.contentMode = .scaleAspectFit
        iv.isHidden = true
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        rs_setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func rs_setupCell() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(rs_titleLabel)
        contentView.addSubview(rs_checkImageView)
        
        rs_titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        rs_checkImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }
    }
    
    func rs_configure(title: String, isChecked: Bool) {
        rs_titleLabel.text = title
        rs_checkImageView.isHidden = !isChecked
    }
}
