//
//  rs_HomeViewController.swift
//  RollerSkating
//
//  首页 - 可滑动内容
//

import UIKit
import SnapKit

class rs_HomeViewController: UIViewController {
    
    // MARK: - UI Elements
    
    /// 背景图（铺满全屏）
    private let rs_bgImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "首页背景图")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    /// 滚动视图
    private let rs_scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.showsHorizontalScrollIndicator = false
        sv.contentInsetAdjustmentBehavior = .never
        return sv
    }()
    
    /// 内容容器
    private let rs_contentView: UIView = {
        let v = UIView()
        return v
    }()
    
    /// 左上角消息按钮
    private let rs_notificationBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "首页左上角消息通知按钮"), for: .normal)
        return btn
    }()
    
    /// START GLIDING 大图
    private let rs_startGlidingImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "START GLIDING")
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    /// Core Data 标题图
    private let rs_coreDataImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Core Data")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    /// Weekly Goal 模块 (白色字体)
    private let rs_weeklyGoalView: rs_DataCardView = {
        let v = rs_DataCardView(imageName: "Weekly Goal", valueText: "0/7", textColor: .white)
        return v
    }()
    
    /// Day Streak 模块 (黑色字体)
    private let rs_dayStreakView: rs_DataCardView = {
        let v = rs_DataCardView(imageName: "Day Streak", valueText: "0/day", textColor: .black)
        return v
    }()
    
    /// Personal Best 模块 (黑色字体)
    private let rs_personalBestView: rs_DataCardView = {
        let v = rs_DataCardView(imageName: "Personal Best", valueText: "0/km·h", textColor: .black)
        return v
    }()
    
    /// Today's Session 模块 (白色字体)
    private let rs_todaySessionView: rs_DataCardView = {
        let v = rs_DataCardView(imageName: "Todays Session", valueText: "0/min", textColor: .white)
        return v
    }()
    
    /// My Respect 标题图
    private let rs_myRespectImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "My Respect")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    /// My Respect 数值
    private let rs_respectValueLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "0"
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        lbl.textAlignment = .right
        return lbl
    }()
    
    /// 进度条背景
    private let rs_progressBgView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(white: 0.3, alpha: 1)
        v.layer.cornerRadius = 6
        return v
    }()
    
    /// 进度条
    private let rs_progressView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(red: 163/255, green: 230/255, blue: 53/255, alpha: 1) // 绿色
        v.layer.cornerRadius = 6
        return v
    }()
    
    /// 进度提示文字
    private let rs_progressHintLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "It takes 0 to surpass the first place."
        lbl.textColor = UIColor(white: 0.6, alpha: 1)
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return lbl
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rs_setupUI()
        rs_setupActions()
        rs_loadUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rs_loadUserData() // 每次显示时刷新数据
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Setup
    
    private func rs_setupUI() {
        view.backgroundColor = UIColor(red: 18/255, green: 0/255, blue: 48/255, alpha: 1)
        
        // 添加背景图
        view.addSubview(rs_bgImageView)
        view.addSubview(rs_scrollView)
        rs_scrollView.addSubview(rs_contentView)
        
        // 添加内容
        rs_contentView.addSubview(rs_startGlidingImageView)
        rs_contentView.addSubview(rs_notificationBtn)
        rs_contentView.addSubview(rs_coreDataImageView)
        rs_contentView.addSubview(rs_weeklyGoalView)
        rs_contentView.addSubview(rs_dayStreakView)
        rs_contentView.addSubview(rs_personalBestView)
        rs_contentView.addSubview(rs_todaySessionView)
        rs_contentView.addSubview(rs_myRespectImageView)
        rs_contentView.addSubview(rs_respectValueLabel)
        rs_contentView.addSubview(rs_progressBgView)
        rs_progressBgView.addSubview(rs_progressView)
        rs_contentView.addSubview(rs_progressHintLabel)
        
        rs_setupConstraints()
    }
    
    private func rs_setupConstraints() {
        let screenWidth = UIScreen.main.bounds.width
        let cardWidth = (screenWidth - 16 * 3) / 2  // 左右边距16 + 中间间距16
        let cardHeight = cardWidth * (98.0 / 171.0)  // 保持171:98比例
        
        // 背景图铺满
        rs_bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // ScrollView
        rs_scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 内容容器
        rs_contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view)
        }
        
        // 左上角消息按钮
        rs_notificationBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.leading.equalToSuperview().offset(16)
            make.size.equalTo(44)
        }
        
        // START GLIDING 大图 (390x319比例，左右边距0)
        rs_startGlidingImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(rs_startGlidingImageView.snp.width).multipliedBy(319.0 / 390.0)
        }
        
        // Core Data 标题
        rs_coreDataImageView.snp.makeConstraints { make in
            make.top.equalTo(rs_startGlidingImageView.snp.bottom)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(28)
        }
        
        // Weekly Goal (左上)
        rs_weeklyGoalView.snp.makeConstraints { make in
            make.top.equalTo(rs_coreDataImageView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(cardWidth)
            make.height.equalTo(cardHeight)
        }
        
        // Day Streak (右上)
        rs_dayStreakView.snp.makeConstraints { make in
            make.top.equalTo(rs_weeklyGoalView)
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalTo(cardWidth)
            make.height.equalTo(cardHeight)
        }
        
        // Personal Best (左下)
        rs_personalBestView.snp.makeConstraints { make in
            make.top.equalTo(rs_weeklyGoalView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(cardWidth)
            make.height.equalTo(cardHeight)
        }
        
        // Today's Session (右下)
        rs_todaySessionView.snp.makeConstraints { make in
            make.top.equalTo(rs_personalBestView)
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalTo(cardWidth)
            make.height.equalTo(cardHeight)
        }
        
        // My Respect 标题
        rs_myRespectImageView.snp.makeConstraints { make in
            make.top.equalTo(rs_personalBestView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(28)
        }
        
        // My Respect 数值
        rs_respectValueLabel.snp.makeConstraints { make in
            make.centerY.equalTo(rs_myRespectImageView)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        // 进度条背景
        rs_progressBgView.snp.makeConstraints { make in
            make.top.equalTo(rs_myRespectImageView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(12)
        }
        
        // 进度条（初始宽度为背景的15%作为示例）
        rs_progressView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.15)
        }
        
        // 进度提示文字
        rs_progressHintLabel.snp.makeConstraints { make in
            make.top.equalTo(rs_progressBgView.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-120) // 底部留出TabBar空间
        }
    }
    
    private func rs_setupActions() {
        rs_notificationBtn.addTarget(self, action: #selector(rs_notificationTapped), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(rs_startGlidingTapped))
        rs_startGlidingImageView.addGestureRecognizer(tap)
    }
    
    // MARK: - Actions
    
    @objc private func rs_notificationTapped() {
        let messageVC = rs_MessageListViewController()
        navigationController?.pushViewController(messageVC, animated: true)
    }
    
    @objc private func rs_startGlidingTapped() {
        let aiMoveVC = rs_AIMoveSelectionViewController()
        let navController = UINavigationController(rootViewController: aiMoveVC)
        navController.setNavigationBarHidden(true, animated: false)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
    
    /// 加载用户数据
    private func rs_loadUserData() {
        let manager = rs_UserManager.shared
        rs_weeklyGoalView.rs_updateValue(manager.rs_getWeeklyGoalText())
        rs_dayStreakView.rs_updateValue(manager.rs_getDayStreakText())
        rs_personalBestView.rs_updateValue(manager.rs_getPersonalBestText())
        rs_todaySessionView.rs_updateValue(manager.rs_getTodaySessionText())
        rs_respectValueLabel.text = "\(manager.rs_respect)"
        rs_progressHintLabel.text = "It takes \(manager.rs_respect) to surpass the first place."
        
        // 更新进度条 (示例：respect/100 作为进度)
        let progress = min(CGFloat(manager.rs_respect) / 100.0, 1.0)
        rs_progressView.snp.remakeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(max(progress, 0.05))
        }
    }
    
    // MARK: - Public Methods
    
    /// 更新数据
    func rs_updateData(weeklyGoal: String, dayStreak: String, personalBest: String, todaySession: String, respect: Int, progress: CGFloat) {
        rs_weeklyGoalView.rs_updateValue(weeklyGoal)
        rs_dayStreakView.rs_updateValue(dayStreak)
        rs_personalBestView.rs_updateValue(personalBest)
        rs_todaySessionView.rs_updateValue(todaySession)
        rs_respectValueLabel.text = "\(respect)"
        rs_progressHintLabel.text = "It takes \(respect) to surpass the first place."
        
        // 更新进度条
        rs_progressView.snp.remakeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(min(progress, 1.0))
        }
    }
}

// MARK: - 数据卡片视图

class rs_DataCardView: UIView {
    
    private let rs_bgImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 16
        return iv
    }()
    
    private let rs_valueLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        return lbl
    }()
    
    init(imageName: String, valueText: String, textColor: UIColor = .white) {
        super.init(frame: .zero)
        rs_bgImageView.image = UIImage(named: imageName)
        rs_valueLabel.text = valueText
        rs_valueLabel.textColor = textColor
        rs_setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func rs_setupView() {
        layer.cornerRadius = 16
        clipsToBounds = true
        
        addSubview(rs_bgImageView)
        addSubview(rs_valueLabel)
        
        rs_bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        rs_valueLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-12)
        }
    }
    
    func rs_updateValue(_ value: String) {
        rs_valueLabel.text = value
    }
}
