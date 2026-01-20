//
//  rs_SettingsViewController.swift
//  RollerSkating
//
//  设置界面
//

import UIKit
import SnapKit
import SVProgressHUD

final class rs_SettingsViewController: UIViewController {
    
    private let rs_menuItems = [
        "Blacklist",
        "Privacy agreement",
        "User agreement",
        "Deletion of account"
    ]
    
    private let rs_bgImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "ai分析界面全屏背景图")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let rs_backBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "全局返回按钮"), for: .normal)
        return btn
    }()
    
    private let rs_titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Setting"
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let rs_tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = false
        return tv
    }()
    
    private let rs_logoutBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "退出按钮"), for: .normal)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rs_setupUI()
        rs_setupTable()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    private func rs_setupUI() {
        view.addSubview(rs_bgImageView)
        view.addSubview(rs_backBtn)
        view.addSubview(rs_titleLabel)
        view.addSubview(rs_tableView)
        view.addSubview(rs_logoutBtn)
        
        rs_bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        rs_backBtn.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.leading.equalToSuperview().offset(16)
            make.size.equalTo(44)
        }
        rs_titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(rs_backBtn)
            make.centerX.equalToSuperview()
        }
        rs_logoutBtn.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(56)
        }
        rs_tableView.snp.makeConstraints { make in
            make.top.equalTo(rs_backBtn.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(rs_logoutBtn.snp.top).offset(-20)
        }
        
        rs_backBtn.addTarget(self, action: #selector(rs_backTapped), for: .touchUpInside)
        rs_logoutBtn.addTarget(self, action: #selector(rs_logoutTapped), for: .touchUpInside)
    }
    
    private func rs_setupTable() {
        rs_tableView.delegate = self
        rs_tableView.dataSource = self
        rs_tableView.register(rs_SettingCell.self, forCellReuseIdentifier: rs_SettingCell.rs_id)
    }
    
    @objc private func rs_backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func rs_logoutTapped() {
        let alert = UIAlertController(title: "Log out", message: "Are you sure you want to log out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { [weak self] _ in
            self?.rs_performLogout()
        }))
        present(alert, animated: true)
    }
    
    private func rs_performLogout() {
        rs_UserManager.shared.rs_logout()
        // 删除本地 JSON 数据
        rs_LocalJSONStore.shared.rs_resetData()
        
        SVProgressHUD.showSuccess(withStatus: "Logged out")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // 切换到登录界面
            let welcomeVC = rs_WelcomeViewController()
            let navController = UINavigationController(rootViewController: welcomeVC)
            navController.setNavigationBarHidden(true, animated: false)
            if let window = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first?.windows.first {
                window.rootViewController = navController
                window.makeKeyAndVisible()
            }
        }
    }
    
    private func rs_handleDeleteAccount() {
        let alert = UIAlertController(title: "Delete Account", message: "Are you sure you want to delete your account? This action cannot be undone.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.rs_performLogout()
        }))
        present(alert, animated: true)
    }
}

extension rs_SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rs_menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: rs_SettingCell.rs_id, for: indexPath) as! rs_SettingCell
        cell.rs_configure(title: rs_menuItems[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            // Blacklist
            let vc = rs_BlacklistViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            // Privacy agreement
            let vc = rs_AgreementViewController(type: .privacy)
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            // User agreement
            let vc = rs_AgreementViewController(type: .user)
            navigationController?.pushViewController(vc, animated: true)
        case 3:
            // Deletion of account
            rs_handleDeleteAccount()
        default:
            break
        }
    }
}

// MARK: - Setting Cell

final class rs_SettingCell: UITableViewCell {
    
    static let rs_id = "rs_SettingCell"
    
    private let rs_titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return lbl
    }()
    
    private let rs_arrowImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "chevron.right")
        iv.tintColor = UIColor(white: 0.6, alpha: 1)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let rs_separator: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(white: 0.3, alpha: 0.5)
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        rs_setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func rs_setup() {
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(rs_titleLabel)
        contentView.addSubview(rs_arrowImageView)
        contentView.addSubview(rs_separator)
        
        rs_titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        rs_arrowImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.size.equalTo(16)
        }
        rs_separator.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    func rs_configure(title: String) {
        rs_titleLabel.text = title
    }
}
