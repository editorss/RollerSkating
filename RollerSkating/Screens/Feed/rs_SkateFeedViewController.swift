//
//  rs_SkateFeedViewController.swift
//  RollerSkating
//
//  Skate Feed 动态列表
//

import UIKit
import SnapKit
import SVProgressHUD

final class rs_SkateFeedViewController: UIViewController {
    
    private enum rs_FeedMode {
        case discover
        case following
    }
    
    private var rs_mode: rs_FeedMode = .discover
    private var rs_allItems: [rs_FeedItem] = []
    private var rs_items: [rs_FeedItem] = []
    private var rs_pageSize: Int = 3
    private var rs_isLoadingMore = false
    
    private let rs_bgImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "ai分析界面全屏背景图")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let rs_msgBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "首页左上角消息通知按钮"), for: .normal)
        return btn
    }()
    
    private let rs_titleImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Skate Feed")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let rs_shareBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "Share Skate大按钮"), for: .normal)
        return btn
    }()
    
    private let rs_kingBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "King of Spin大按钮"), for: .normal)
        return btn
    }()
    
    private let rs_discoverBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Discover", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    private let rs_followingBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Following", for: .normal)
        btn.setTitleColor(UIColor(white: 0.7, alpha: 1), for: .normal)
        return btn
    }()
    
    private let rs_tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = false
        return tv
    }()
    
    private lazy var rs_refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(rs_refresh), for: .valueChanged)
        return rc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rs_setupUI()
        rs_setupTable()
        rs_setupActions()
        rs_loadInitial()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rs_reloadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func rs_setupUI() {
        view.addSubview(rs_bgImageView)
        view.addSubview(rs_msgBtn)
        view.addSubview(rs_titleImageView)
        view.addSubview(rs_shareBtn)
        view.addSubview(rs_kingBtn)
        view.addSubview(rs_discoverBtn)
        view.addSubview(rs_followingBtn)
        view.addSubview(rs_tableView)
        
        rs_bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        rs_msgBtn.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.leading.equalToSuperview().offset(16)
            make.size.equalTo(44)
        }
        
        rs_titleImageView.snp.makeConstraints { make in
            make.centerY.equalTo(rs_msgBtn)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(26)
        }
        
        rs_shareBtn.snp.makeConstraints { make in
            make.top.equalTo(rs_msgBtn.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(view.snp.centerX).offset(-8)
            make.height.equalTo(rs_shareBtn.snp.width).multipliedBy(128.0 / 172.0)
        }
        
        rs_kingBtn.snp.makeConstraints { make in
            make.top.equalTo(rs_shareBtn)
            make.leading.equalTo(view.snp.centerX).offset(8)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(rs_kingBtn.snp.width).multipliedBy(128.0 / 172.0)
        }
        
        rs_discoverBtn.snp.makeConstraints { make in
            make.top.equalTo(rs_shareBtn.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
        }
        
        rs_followingBtn.snp.makeConstraints { make in
            make.leading.equalTo(rs_discoverBtn.snp.trailing).offset(24)
            make.centerY.equalTo(rs_discoverBtn)
        }
        
        rs_tableView.snp.makeConstraints { make in
            make.top.equalTo(rs_discoverBtn.snp.bottom).offset(12)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func rs_setupTable() {
        rs_tableView.delegate = self
        rs_tableView.dataSource = self
        rs_tableView.register(rs_FeedPostCell.self, forCellReuseIdentifier: rs_FeedPostCell.rs_id)
        rs_tableView.refreshControl = rs_refreshControl
    }
    
    private func rs_setupActions() {
        rs_msgBtn.addTarget(self, action: #selector(rs_messageTapped), for: .touchUpInside)
        rs_discoverBtn.addTarget(self, action: #selector(rs_switchToDiscover), for: .touchUpInside)
        rs_followingBtn.addTarget(self, action: #selector(rs_switchToFollowing), for: .touchUpInside)
        rs_shareBtn.addTarget(self, action: #selector(rs_shareTapped), for: .touchUpInside)
        rs_kingBtn.addTarget(self, action: #selector(rs_kingTapped), for: .touchUpInside)
    }
    
    @objc private func rs_messageTapped() {
        let messageVC = rs_MessageListViewController()
        navigationController?.pushViewController(messageVC, animated: true)
    }
    
    @objc private func rs_switchToDiscover() {
        rs_mode = .discover
        rs_updateTabStyle()
        rs_loadInitial()
    }
    
    @objc private func rs_switchToFollowing() {
        rs_mode = .following
        rs_updateTabStyle()
        rs_loadInitial()
    }

    @objc private func rs_shareTapped() {
        let shareVC = rs_ShareSkateViewController()
        navigationController?.pushViewController(shareVC, animated: true)
    }

    @objc private func rs_kingTapped() {
        let kingVC = rs_KingOfSpinViewController()
        navigationController?.pushViewController(kingVC, animated: true)
    }
    
    private func rs_updateTabStyle() {
        let selectedFont = UIFont.systemFont(ofSize: 20, weight: .bold)
        let normalFont = UIFont.systemFont(ofSize: 18, weight: .regular)
        if rs_mode == .discover {
            rs_discoverBtn.titleLabel?.font = selectedFont
            rs_followingBtn.titleLabel?.font = normalFont
            rs_discoverBtn.setTitleColor(.white, for: .normal)
            rs_followingBtn.setTitleColor(UIColor(white: 0.7, alpha: 1), for: .normal)
        } else {
            rs_followingBtn.titleLabel?.font = selectedFont
            rs_discoverBtn.titleLabel?.font = normalFont
            rs_followingBtn.setTitleColor(.white, for: .normal)
            rs_discoverBtn.setTitleColor(UIColor(white: 0.7, alpha: 1), for: .normal)
        }
    }
    
    @objc private func rs_refresh() {
        rs_loadInitial()
    }
    
    private func rs_loadInitial() {
        SVProgressHUD.show(withStatus: "Loading...")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
            self?.rs_reloadData()
            self?.rs_refreshControl.endRefreshing()
            SVProgressHUD.dismiss()
        }
    }
    
    private func rs_reloadData() {
        let currentUser = rs_LocalJSONStore.shared.rs_getCurrentUser()
        let currentUserId = currentUser?.id ?? ""
        let users = rs_LocalJSONStore.shared.rs_loadUsers()
        var items: [rs_FeedItem] = []
        for user in users {
            if user.isBlocked { continue }
            // 过滤掉当前用户的动态（自己发布的不显示在 Discover）
            if user.id == currentUserId { continue }
            for post in user.posts {
                if rs_mode == .following && !user.isFollowed { continue }
                items.append(rs_FeedItem(user: user, post: post))
            }
        }
        rs_allItems = items
        rs_items = Array(items.prefix(rs_pageSize))
        rs_tableView.reloadData()
    }
    
    private func rs_loadMoreIfNeeded() {
        guard !rs_isLoadingMore else { return }
        guard rs_items.count < rs_allItems.count else { return }
        rs_isLoadingMore = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
            guard let self else { return }
            let nextCount = min(self.rs_items.count + self.rs_pageSize, self.rs_allItems.count)
            self.rs_items = Array(self.rs_allItems.prefix(nextCount))
            self.rs_tableView.reloadData()
            self.rs_isLoadingMore = false
        }
    }
}

extension rs_SkateFeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rs_items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: rs_FeedPostCell.rs_id, for: indexPath) as! rs_FeedPostCell
        let item = rs_items[indexPath.row]
        cell.rs_configure(item: item)
        cell.rs_onFollow = { [weak self] in
            _ = rs_LocalJSONStore.shared.rs_toggleFollow(targetUserId: item.user.id)
            self?.rs_loadInitial()
        }
        cell.rs_onChat = { [weak self] in
            let conversationId = rs_LocalJSONStore.shared.rs_getOrCreateConversation(peerName: item.user.nickname, avatar: item.user.avatar)
            let chatVC = rs_ChatViewController(conversationId: conversationId)
            self?.navigationController?.pushViewController(chatVC, animated: true)
        }
        cell.rs_onProfile = { [weak self] in
            let profileVC = rs_ProfileViewController(user: item.user)
            self?.navigationController?.pushViewController(profileVC, animated: true)
        }
        cell.rs_onLike = { [weak self] in
            let willLike = !item.post.isLiked
            rs_LocalJSONStore.shared.rs_updatePostLike(userId: item.user.id, postId: item.post.id, isLiked: willLike)
            self?.rs_reloadData()
        }
        cell.rs_onComment = { [weak self] in
            self?.rs_openDetail(item: item)
        }
        cell.rs_onReport = { [weak self] in
            guard let self else { return }
            rs_ReportSheetView.rs_present(in: self.view) { reportItem in
                if reportItem == .block || reportItem == .notInterested {
                    rs_LocalJSONStore.shared.rs_blockUser(targetUserId: item.user.id)
                    SVProgressHUD.showSuccess(withStatus: "Hidden")
                    self.rs_reloadData()
                } else if !reportItem.rs_isCancel {
                    SVProgressHUD.showSuccess(withStatus: "Report submitted")
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 420
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        rs_openDetail(item: rs_items[indexPath.row])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        if offsetY > contentHeight - height - 200 {
            rs_loadMoreIfNeeded()
        }
    }

    private func rs_openDetail(item: rs_FeedItem) {
        let detailVC = rs_FeedDetailViewController(item: item) { [weak self] in
            self?.rs_reloadData()
        }
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

struct rs_FeedItem {
    let user: rs_UserProfile
    let post: rs_UserPost
}
