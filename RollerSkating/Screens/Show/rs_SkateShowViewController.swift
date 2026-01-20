//
//  rs_SkateShowViewController.swift
//  RollerSkating
//
//  Skate Show 短视频
//

import UIKit
import SnapKit
import AVFoundation
import SVProgressHUD

final class rs_SkateShowViewController: UIViewController {
    
    private var rs_items: [rs_SkateShowItem] = []
    
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
        iv.image = UIImage(named: "Skate Show")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let rs_collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.showsVerticalScrollIndicator = false
        cv.backgroundColor = .clear
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rs_setupUI()
        rs_setupCollection()
        rs_loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rs_playVisible()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        rs_stopAll()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func rs_setupUI() {
        view.addSubview(rs_bgImageView)
        view.addSubview(rs_collectionView)
        view.addSubview(rs_msgBtn)
        view.addSubview(rs_titleImageView)
        
        rs_bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        rs_collectionView.snp.makeConstraints { make in
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
        
        rs_msgBtn.addTarget(self, action: #selector(rs_messageTapped), for: .touchUpInside)
    }
    
    private func rs_setupCollection() {
        rs_collectionView.delegate = self
        rs_collectionView.dataSource = self
        rs_collectionView.register(rs_SkateShowCell.self, forCellWithReuseIdentifier: rs_SkateShowCell.rs_id)
    }
    
    private func rs_loadData() {
        let users = rs_LocalJSONStore.shared.rs_loadUsers()
        var items: [rs_SkateShowItem] = []
        for user in users {
            if user.isBlocked { continue }
            for video in user.videos {
                items.append(rs_SkateShowItem(user: user, video: video))
            }
        }
        print("[rs_SkateShow] Items count:", items.count)
        rs_items = items
        rs_collectionView.reloadData()
        DispatchQueue.main.async { [weak self] in
            self?.rs_playCurrent()
        }
    }
    
    @objc private func rs_messageTapped() {
        let messageVC = rs_MessageListViewController()
        navigationController?.pushViewController(messageVC, animated: true)
    }
}

extension rs_SkateShowViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rs_items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: rs_SkateShowCell.rs_id, for: indexPath) as! rs_SkateShowCell
        let item = rs_items[indexPath.item]
        cell.rs_configure(item: item)
        cell.rs_onLike = { [weak self] in
            self?.rs_toggleLike(item: item, cell: cell)
        }
        cell.rs_onComment = { [weak self] in
            self?.rs_presentComments(item: item)
        }
        cell.rs_onReport = { [weak self] in
            guard let self else { return }
            rs_ReportSheetView.rs_present(in: self.view) { reportItem in
                if reportItem == .block || reportItem == .notInterested {
                    rs_LocalJSONStore.shared.rs_blockUser(targetUserId: item.user.id)
                    SVProgressHUD.showSuccess(withStatus: "Hidden")
                    self.rs_loadData()
                } else if !reportItem.rs_isCancel {
                    SVProgressHUD.showSuccess(withStatus: "Report submitted")
                }
            }
        }
        cell.rs_onFollow = { [weak self] in
            rs_LocalJSONStore.shared.rs_updateFollow(userId: item.user.id, isFollowed: !item.user.isFollowed)
            self?.rs_loadData()
        }
        cell.rs_onProfile = { [weak self] in
            let profileVC = rs_ProfileViewController(user: item.user)
            self?.navigationController?.pushViewController(profileVC, animated: true)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        rs_stopAll()
        rs_playCurrent()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        rs_stopAll()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            rs_stopAll()
            rs_playCurrent()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? rs_SkateShowCell)?.rs_stop()
    }
    
    private func rs_toggleLike(item: rs_SkateShowItem, cell: rs_SkateShowCell) {
        let isLiked = !item.video.isLiked
        rs_LocalJSONStore.shared.rs_updateVideoLike(userId: item.user.id, videoId: item.video.id, isLiked: isLiked)
        rs_loadData()
        cell.rs_play()
    }
    
    private func rs_presentComments(item: rs_SkateShowItem) {
        rs_CommentSheetView.rs_present(in: view, item: item) { commentText in
            guard let text = commentText else { return }
            rs_LocalJSONStore.shared.rs_appendVideoComment(
                userId: item.user.id,
                videoId: item.video.id,
                userName: "Poppins",
                avatar: "默认avatar1",
                text: text
            )
            self.rs_loadData()
        }
    }

    private func rs_playVisible() {
        rs_stopAll()
        rs_playCurrent()
    }

    private func rs_playCurrent() {
        guard rs_collectionView.bounds.height > 0 else { return }
        let page = Int(round(rs_collectionView.contentOffset.y / rs_collectionView.bounds.height))
        let indexPath = IndexPath(item: max(0, page), section: 0)
        if let cell = rs_collectionView.cellForItem(at: indexPath) as? rs_SkateShowCell {
            cell.rs_play()
        }
    }

    private func rs_stopAll() {
        rs_collectionView.visibleCells.forEach { cell in
            (cell as? rs_SkateShowCell)?.rs_stop()
        }
    }
}

struct rs_SkateShowItem {
    let user: rs_UserProfile
    let video: rs_ShortVideo
}
