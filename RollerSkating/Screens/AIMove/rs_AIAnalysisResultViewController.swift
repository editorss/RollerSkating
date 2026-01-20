//
//  rs_AIAnalysisResultViewController.swift
//  RollerSkating
//
//  AI Move Recognition - 分析结果界面
//

import UIKit
import SnapKit

class rs_AIAnalysisResultViewController: UIViewController {
    
    // MARK: - Properties
    
    var rs_selectedMove: String = ""
    var rs_recordingDuration: Int = 0
    
    private var rs_isAnalyzing = true
    private var rs_loadingTimer: Timer?
    private var rs_loadingTextIndex = 0
    
    private let rs_loadingTexts = [
        "Checking posture and alignment",
        "Measuring balance and control",
        "Analyzing speed and stability",
        "Detecting trick completion",
        "Evaluating safety and form",
        "Mapping your movement flow"
    ]
    
    // 分析结果数据
    private var rs_overallScore: Double = 0
    private var rs_postureScore: Double = 0
    private var rs_balanceScore: Double = 0
    private var rs_safetyScore: Double = 0
    
    // MARK: - UI Elements
    
    /// 背景图
    private let rs_bgImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "ai分析界面全屏背景图")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    /// 返回按钮
    private let rs_backBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "全局返回按钮"), for: .normal)
        return btn
    }()
    
    /// 标题
    private let rs_titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "AI move recognition"
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        lbl.textAlignment = .center
        return lbl
    }()
    
    /// 主状态文案
    private let rs_mainStatusLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "AI is analyzing your moves"
        lbl.textColor = .white
        lbl.font = UIFont.italicSystemFont(ofSize: 24)
        lbl.textAlignment = .center
        return lbl
    }()
    
    /// 处理中文案
    private let rs_processingLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Checking posture and alignment"
        lbl.textColor = UIColor(white: 0.7, alpha: 1)
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lbl.textAlignment = .center
        return lbl
    }()
    
    /// Loading指示器容器
    private let rs_loadingContainer: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 8
        sv.alignment = .center
        sv.distribution = .fillEqually
        return sv
    }()
    
    /// 结果滚动视图
    private let rs_resultScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.alpha = 0
        return sv
    }()
    
    /// 结果内容视图
    private let rs_resultContentView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(red: 30/255, green: 20/255, blue: 50/255, alpha: 0.9)
        v.layer.cornerRadius = 16
        return v
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rs_setupUI()
        rs_setupActions()
        rs_generateRandomScores()
        rs_startAnalyzing()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Setup
    
    private func rs_setupUI() {
        view.backgroundColor = UIColor(red: 18/255, green: 0/255, blue: 48/255, alpha: 1)
        
        view.addSubview(rs_bgImageView)
        view.addSubview(rs_backBtn)
        view.addSubview(rs_titleLabel)
        view.addSubview(rs_mainStatusLabel)
        view.addSubview(rs_processingLabel)
        view.addSubview(rs_loadingContainer)
        view.addSubview(rs_resultScrollView)
        rs_resultScrollView.addSubview(rs_resultContentView)
        
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
        
        rs_mainStatusLabel.snp.makeConstraints { make in
            make.top.equalTo(rs_backBtn.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        rs_processingLabel.snp.makeConstraints { make in
            make.top.equalTo(rs_mainStatusLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        // 创建3个loading方块
        for _ in 0..<3 {
            let block = UIView()
            block.backgroundColor = UIColor(red: 163/255, green: 230/255, blue: 53/255, alpha: 1)
            block.layer.cornerRadius = 4
            rs_loadingContainer.addArrangedSubview(block)
            block.snp.makeConstraints { make in
                make.size.equalTo(CGSize(width: 20, height: 20))
            }
        }
        
        rs_loadingContainer.snp.makeConstraints { make in
            make.top.equalTo(rs_processingLabel.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
        
        rs_resultScrollView.snp.makeConstraints { make in
            make.top.equalTo(rs_loadingContainer.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        rs_resultContentView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
            make.width.equalTo(view).offset(-32)
        }
    }
    
    private func rs_setupActions() {
        rs_backBtn.addTarget(self, action: #selector(rs_backTapped), for: .touchUpInside)
    }
    
    // MARK: - Data Generation
    
    private func rs_generateRandomScores() {
        // 生成合理的随机分数 (7.0 - 9.5)
        rs_overallScore = Double.random(in: 7.5...9.2)
        rs_postureScore = Double.random(in: 7.0...9.5)
        rs_balanceScore = Double.random(in: 7.0...9.5)
        rs_safetyScore = Double.random(in: 8.0...9.8)
    }
    
    // MARK: - Analysis Animation
    
    private func rs_startAnalyzing() {
        // 随机5-10秒
        let analysisDuration = Double.random(in: 5...10)
        
        // 文案轮播
        rs_loadingTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { [weak self] _ in
            self?.rs_updateLoadingText()
        }
        
        // Loading方块动画
        rs_startLoadingAnimation()
        
        // 分析完成后显示结果
        DispatchQueue.main.asyncAfter(deadline: .now() + analysisDuration) { [weak self] in
            self?.rs_finishAnalyzing()
        }
    }
    
    private func rs_updateLoadingText() {
        rs_loadingTextIndex = (rs_loadingTextIndex + 1) % rs_loadingTexts.count
        
        UIView.transition(with: rs_processingLabel, duration: 0.3, options: .transitionCrossDissolve) {
            self.rs_processingLabel.text = self.rs_loadingTexts[self.rs_loadingTextIndex]
        }
    }
    
    private func rs_startLoadingAnimation() {
        let blocks = rs_loadingContainer.arrangedSubviews
        
        for (index, block) in blocks.enumerated() {
            let delay = Double(index) * 0.2
            UIView.animate(withDuration: 0.5, delay: delay, options: [.repeat, .autoreverse]) {
                block.alpha = 0.3
            }
        }
    }
    
    private func rs_finishAnalyzing() {
        rs_isAnalyzing = false
        rs_loadingTimer?.invalidate()
        
        // 停止loading动画
        rs_loadingContainer.arrangedSubviews.forEach { $0.layer.removeAllAnimations() }
        
        // 更新状态文案
        rs_mainStatusLabel.text = "Analysis Complete"
        rs_processingLabel.text = "Here are your results"
        
        // 构建结果视图
        rs_buildResultView()
        
        // 显示结果
        UIView.animate(withDuration: 0.5) {
            self.rs_loadingContainer.alpha = 0
            self.rs_resultScrollView.alpha = 1
        }
        
        // 更新用户数据
        rs_updateUserStats()
    }
    
    private func rs_buildResultView() {
        // Overall Score
        let overallSection = rs_createScoreSection(
            title: "Overall Score",
            score: String(format: "%.1f / 10", rs_overallScore),
            description: rs_getOverallDescription()
        )
        
        // Posture
        let postureSection = rs_createDetailSection(
            icon: "🧍",
            title: "Posture（姿态）",
            score: rs_postureScore,
            description: rs_getPostureDescription()
        )
        
        // Balance
        let balanceSection = rs_createDetailSection(
            icon: "⚖️",
            title: "Balance（平衡）",
            score: rs_balanceScore,
            description: rs_getBalanceDescription()
        )
        
        // Safety
        let safetySection = rs_createDetailSection(
            icon: "🟠",
            title: "Safety（安全）",
            score: rs_safetyScore,
            description: rs_getSafetyDescription()
        )
        
        let stackView = UIStackView(arrangedSubviews: [overallSection, postureSection, balanceSection, safetySection])
        stackView.axis = .vertical
        stackView.spacing = 24
        
        rs_resultContentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }
    
    private func rs_createScoreSection(title: String, score: String, description: String) -> UIView {
        let container = UIView()
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = UIColor(white: 0.7, alpha: 1)
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        let scoreLabel = UILabel()
        scoreLabel.text = score
        scoreLabel.textColor = .white
        scoreLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        
        let descLabel = UILabel()
        descLabel.text = description
        descLabel.textColor = .white
        descLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        descLabel.numberOfLines = 0
        
        container.addSubview(titleLabel)
        container.addSubview(scoreLabel)
        container.addSubview(descLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        scoreLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }
        
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(scoreLabel.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        return container
    }
    
    private func rs_createDetailSection(icon: String, title: String, score: Double, description: String) -> UIView {
        let container = UIView()
        
        let titleLabel = UILabel()
        titleLabel.text = "\(icon) \(title)"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        let scoreLabel = UILabel()
        scoreLabel.text = String(format: "Score: %.1f", score)
        scoreLabel.textColor = UIColor(white: 0.8, alpha: 1)
        scoreLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        let descLabel = UILabel()
        descLabel.text = description
        descLabel.textColor = UIColor(white: 0.7, alpha: 1)
        descLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        descLabel.numberOfLines = 0
        
        container.addSubview(titleLabel)
        container.addSubview(scoreLabel)
        container.addSubview(descLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        scoreLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }
        
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(scoreLabel.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        return container
    }
    
    // MARK: - Description Generators
    
    private func rs_getOverallDescription() -> String {
        let descriptions = [
            "Smooth control with solid fundamentals. Great progress.",
            "Impressive technique! Your form shows consistent improvement.",
            "Solid performance with room for minor adjustments.",
            "Well-executed moves with good control throughout."
        ]
        return descriptions.randomElement() ?? descriptions[0]
    }
    
    private func rs_getPostureDescription() -> String {
        let descriptions = [
            "Upper body stays relaxed and stable. Try keeping your shoulders slightly lower during turns for better balance.",
            "Good posture maintained throughout. Focus on keeping your core engaged for more stability.",
            "Excellent body alignment. Minor adjustments to arm position could improve flow."
        ]
        return descriptions.randomElement() ?? descriptions[0]
    }
    
    private func rs_getBalanceDescription() -> String {
        let descriptions = [
            "Weight distribution is consistent. Minor instability appears during landing — bend your knees a bit more.",
            "Good center of gravity control. Try widening your stance slightly for better stability.",
            "Balance is well-maintained. Focus on smoother weight transitions between feet."
        ]
        return descriptions.randomElement() ?? descriptions[0]
    }
    
    private func rs_getSafetyDescription() -> String {
        let descriptions = [
            "Safe execution with proper protective awareness. Keep maintaining this approach.",
            "Good safety awareness throughout the session. Remember to check your equipment regularly.",
            "Excellent safety practices observed. Your cautious approach helps prevent injuries."
        ]
        return descriptions.randomElement() ?? descriptions[0]
    }
    
    // MARK: - Update User Stats
    
    private func rs_updateUserStats() {
        let manager = rs_UserManager.shared
        
        // 增加今日训练时长
        manager.rs_todaySession += max(rs_recordingDuration / 60, 1)
        
        // 增加连续天数（简化逻辑）
        manager.rs_dayStreak += 1
        
        // 更新周目标
        manager.rs_weeklyGoal = min(manager.rs_weeklyGoal + 1, manager.rs_weeklyGoalTotal)
        
        // 更新个人最佳（如果分数更高）
        if rs_overallScore > manager.rs_personalBest {
            manager.rs_personalBest = rs_overallScore
        }
        
        // 增加 Respect
        manager.rs_respect += Int.random(in: 5...15)
    }
    
    // MARK: - Actions
    
    @objc private func rs_backTapped() {
        // 返回到首页
        view.window?.rootViewController = rs_MainTabBarController()
    }
}
