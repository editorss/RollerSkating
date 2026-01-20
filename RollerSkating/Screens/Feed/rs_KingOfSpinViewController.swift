//
//  rs_KingOfSpinViewController.swift
//  RollerSkating
//
//  King of Spin
//

import UIKit
import SnapKit

final class rs_KingOfSpinViewController: UIViewController {
    
    private var rs_allUsers: [rs_UserProfile] = []
    private var rs_restUsers: [rs_UserProfile] = [] // 第4名及以后
    
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
        lbl.text = "King of Spin"
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        lbl.textAlignment = .center
        return lbl
    }()
    
    // MARK: - Top 3 Views
    
    private let rs_top3Container = UIView()
    
    // 第二名（左）
    private let rs_secondAvatar: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 40
        iv.clipsToBounds = true
        iv.layer.borderWidth = 3
        iv.layer.borderColor = UIColor(hex: "#C0C0C0").cgColor
        return iv
    }()
    private let rs_secondNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        lbl.textAlignment = .center
        return lbl
    }()
    private let rs_secondHeatLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        lbl.textAlignment = .center
        return lbl
    }()
    
    // 第一名（中）
    private let rs_firstAvatar: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 50
        iv.clipsToBounds = true
        iv.layer.borderWidth = 3
        iv.layer.borderColor = UIColor(hex: "#FFD700").cgColor
        return iv
    }()
    private let rs_firstNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        lbl.textAlignment = .center
        return lbl
    }()
    private let rs_firstHeatLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        lbl.textAlignment = .center
        return lbl
    }()
    
    // 第三名（右）
    private let rs_thirdAvatar: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 40
        iv.clipsToBounds = true
        iv.layer.borderWidth = 3
        iv.layer.borderColor = UIColor(hex: "#CD7F32").cgColor
        return iv
    }()
    private let rs_thirdNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        lbl.textAlignment = .center
        return lbl
    }()
    private let rs_thirdHeatLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 12, weight: .medium)
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
    
    private let rs_rankCard: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(hex: "#2B1B4A")
        v.layer.cornerRadius = 18
        return v
    }()
    
    private let rs_rankLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "You currently rank"
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return lbl
    }()
    
    private let rs_rankValueLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "0"
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rs_setupUI()
        rs_setupTable()
        rs_loadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    private func rs_setupUI() {
        view.addSubview(rs_bgImageView)
        view.addSubview(rs_backBtn)
        view.addSubview(rs_titleLabel)
        view.addSubview(rs_top3Container)
        view.addSubview(rs_tableView)
        view.addSubview(rs_rankCard)
        rs_rankCard.addSubview(rs_rankLabel)
        rs_rankCard.addSubview(rs_rankValueLabel)
        
        // Top 3 subviews
        rs_top3Container.addSubview(rs_secondAvatar)
        rs_top3Container.addSubview(rs_secondNameLabel)
        rs_top3Container.addSubview(rs_secondHeatLabel)
        rs_top3Container.addSubview(rs_firstAvatar)
        rs_top3Container.addSubview(rs_firstNameLabel)
        rs_top3Container.addSubview(rs_firstHeatLabel)
        rs_top3Container.addSubview(rs_thirdAvatar)
        rs_top3Container.addSubview(rs_thirdNameLabel)
        rs_top3Container.addSubview(rs_thirdHeatLabel)
        
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
        rs_rankCard.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-12)
            make.height.equalTo(60)
        }
        rs_rankLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        rs_rankValueLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        
        // Top 3 container
        rs_top3Container.snp.makeConstraints { make in
            make.top.equalTo(rs_backBtn.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(180)
        }
        
        // 第一名（中间，最大，位置最高）
        rs_firstAvatar.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.size.equalTo(100)
        }
        rs_firstNameLabel.snp.makeConstraints { make in
            make.centerX.equalTo(rs_firstAvatar)
            make.top.equalTo(rs_firstAvatar.snp.bottom).offset(8)
        }
        rs_firstHeatLabel.snp.makeConstraints { make in
            make.centerX.equalTo(rs_firstAvatar)
            make.top.equalTo(rs_firstNameLabel.snp.bottom).offset(4)
        }
        
        // 第二名（左边，稍小，位置偏下）
        rs_secondAvatar.snp.makeConstraints { make in
            make.centerX.equalToSuperview().multipliedBy(0.33)
            make.top.equalToSuperview().offset(30)
            make.size.equalTo(80)
        }
        rs_secondNameLabel.snp.makeConstraints { make in
            make.centerX.equalTo(rs_secondAvatar)
            make.top.equalTo(rs_secondAvatar.snp.bottom).offset(8)
        }
        rs_secondHeatLabel.snp.makeConstraints { make in
            make.centerX.equalTo(rs_secondAvatar)
            make.top.equalTo(rs_secondNameLabel.snp.bottom).offset(4)
        }
        
        // 第三名（右边，稍小，位置偏下）
        rs_thirdAvatar.snp.makeConstraints { make in
            make.centerX.equalToSuperview().multipliedBy(1.67)
            make.top.equalToSuperview().offset(30)
            make.size.equalTo(80)
        }
        rs_thirdNameLabel.snp.makeConstraints { make in
            make.centerX.equalTo(rs_thirdAvatar)
            make.top.equalTo(rs_thirdAvatar.snp.bottom).offset(8)
        }
        rs_thirdHeatLabel.snp.makeConstraints { make in
            make.centerX.equalTo(rs_thirdAvatar)
            make.top.equalTo(rs_thirdNameLabel.snp.bottom).offset(4)
        }
        
        rs_tableView.snp.makeConstraints { make in
            make.top.equalTo(rs_top3Container.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(rs_rankCard.snp.top).offset(-12)
        }
        
        rs_backBtn.addTarget(self, action: #selector(rs_backTapped), for: .touchUpInside)
    }
    
    private func rs_setupTable() {
        rs_tableView.delegate = self
        rs_tableView.dataSource = self
        rs_tableView.register(rs_KingCell.self, forCellReuseIdentifier: rs_KingCell.rs_id)
    }
    
    private func rs_loadData() {
        // 按热力值排序
        rs_allUsers = rs_LocalJSONStore.shared.rs_loadUsers().sorted { $0.heatValue > $1.heatValue }
        
        // 配置前三名
        if rs_allUsers.count > 0 {
            let first = rs_allUsers[0]
            rs_firstAvatar.image = UIImage.rs_load(first.avatar)
            rs_firstNameLabel.text = first.nickname
            rs_firstHeatLabel.text = "🔥 \(first.heatValue)"
        }
        if rs_allUsers.count > 1 {
            let second = rs_allUsers[1]
            rs_secondAvatar.image = UIImage.rs_load(second.avatar)
            rs_secondNameLabel.text = second.nickname
            rs_secondHeatLabel.text = "🔥 \(second.heatValue)"
        }
        if rs_allUsers.count > 2 {
            let third = rs_allUsers[2]
            rs_thirdAvatar.image = UIImage.rs_load(third.avatar)
            rs_thirdNameLabel.text = third.nickname
            rs_thirdHeatLabel.text = "🔥 \(third.heatValue)"
        }
        
        // 第4名及以后
        rs_restUsers = rs_allUsers.count > 3 ? Array(rs_allUsers.dropFirst(3)) : []
        rs_tableView.reloadData()
    }
    
    @objc private func rs_backTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension rs_KingOfSpinViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rs_restUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: rs_KingCell.rs_id, for: indexPath) as! rs_KingCell
        cell.rs_configure(user: rs_restUsers[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
}

final class rs_KingCell: UITableViewCell {
    
    static let rs_id = "rs_KingCell"
    
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
    
    private let rs_heatLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return lbl
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
        contentView.addSubview(rs_heatLabel)
        
        rs_avatar.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(48)
        }
        rs_nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(rs_avatar.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
        }
        rs_heatLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }
    
    func rs_configure(user: rs_UserProfile) {
        rs_avatar.image = UIImage.rs_load(user.avatar)
        rs_nameLabel.text = user.nickname
        rs_heatLabel.text = "🔥 \(user.heatValue)"
    }
}
