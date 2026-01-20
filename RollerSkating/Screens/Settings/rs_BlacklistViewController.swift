//
//  rs_BlacklistViewController.swift
//  RollerSkating
//
//  黑名单列表
//

import UIKit
import SnapKit
import SVProgressHUD

final class rs_BlacklistViewController: UIViewController {
    
    private var rs_blockedUsers: [rs_UserProfile] = []
    
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
        lbl.text = "Blacklist"
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
    
    private let rs_emptyImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "No data加人物")
        iv.contentMode = .scaleAspectFit
        iv.isHidden = true
        return iv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rs_setupUI()
        rs_setupTable()
        rs_loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rs_loadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    private func rs_setupUI() {
        view.addSubview(rs_bgImageView)
        view.addSubview(rs_backBtn)
        view.addSubview(rs_titleLabel)
        view.addSubview(rs_tableView)
        view.addSubview(rs_emptyImageView)
        
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
        rs_tableView.snp.makeConstraints { make in
            make.top.equalTo(rs_backBtn.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
        rs_emptyImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(180)
        }
        
        rs_backBtn.addTarget(self, action: #selector(rs_backTapped), for: .touchUpInside)
    }
    
    private func rs_setupTable() {
        rs_tableView.delegate = self
        rs_tableView.dataSource = self
        rs_tableView.register(rs_BlacklistCell.self, forCellReuseIdentifier: rs_BlacklistCell.rs_id)
    }
    
    private func rs_loadData() {
        let allUsers = rs_LocalJSONStore.shared.rs_loadUsers()
        rs_blockedUsers = allUsers.filter { $0.isBlocked }
        
        rs_emptyImageView.isHidden = !rs_blockedUsers.isEmpty
        rs_tableView.isHidden = rs_blockedUsers.isEmpty
        rs_tableView.reloadData()
    }
    
    @objc private func rs_backTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension rs_BlacklistViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rs_blockedUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: rs_BlacklistCell.rs_id, for: indexPath) as! rs_BlacklistCell
        let user = rs_blockedUsers[indexPath.row]
        cell.rs_configure(user: user)
        cell.rs_onUnblock = { [weak self] in
            rs_LocalJSONStore.shared.rs_unblockUser(targetUserId: user.id)
            SVProgressHUD.showSuccess(withStatus: "Unblocked")
            self?.rs_loadData()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

// MARK: - Blacklist Cell

final class rs_BlacklistCell: UITableViewCell {
    
    static let rs_id = "rs_BlacklistCell"
    
    var rs_onUnblock: (() -> Void)?
    
    private let rs_avatar: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 24
        iv.clipsToBounds = true
        return iv
    }()
    
    private let rs_nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return lbl
    }()
    
    private let rs_unblockBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Unblock", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        btn.backgroundColor = UIColor(hex: "#C85CFF")
        btn.layer.cornerRadius = 16
        return btn
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
        contentView.addSubview(rs_avatar)
        contentView.addSubview(rs_nameLabel)
        contentView.addSubview(rs_unblockBtn)
        
        rs_avatar.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(48)
        }
        rs_nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(rs_avatar.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
        }
        rs_unblockBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(32)
        }
        
        rs_unblockBtn.addTarget(self, action: #selector(rs_unblockTapped), for: .touchUpInside)
    }
    
    func rs_configure(user: rs_UserProfile) {
        rs_avatar.image = UIImage.rs_load(user.avatar)
        rs_nameLabel.text = user.nickname
    }
    
    @objc private func rs_unblockTapped() {
        rs_onUnblock?()
    }
}
