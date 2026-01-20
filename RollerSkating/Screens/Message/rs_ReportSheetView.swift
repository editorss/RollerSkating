//
//  rs_ReportSheetView.swift
//  RollerSkating
//
//  举报弹窗（可复用）
//

import UIKit
import SnapKit

final class rs_ReportSheetView: UIView {
    
    enum rs_Item: String, CaseIterable {
        case harassment = "Harassment or bullying"
        case spam = "Spam or scam"
        case inappropriate = "Inappropriate content"
        case sexual = "Sexual or suggestive content"
        case notInterested = "Not interested"
        case block = "Block"
        case cancel = "Cancel"
        
        var rs_isCancel: Bool { self == .cancel }
        var rs_isPrimary: Bool { self == .cancel }
    }
    
    private let rs_backgroundView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(hex: "#000000", alpha: 0.6)
        return v
    }()
    
    private let rs_containerView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(hex: "#2C2C2C")
        v.layer.cornerRadius = 28
        v.clipsToBounds = true
        return v
    }()
    
    private let rs_stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 12
        return sv
    }()
    
    private var rs_actionHandler: ((rs_Item) -> Void)?
    
    // MARK: - Init
    
    init(items: [rs_Item] = rs_Item.allCases, handler: ((rs_Item) -> Void)?) {
        self.rs_actionHandler = handler
        super.init(frame: .zero)
        rs_setupUI(items: items)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    
    static func rs_present(in view: UIView, handler: @escaping (rs_Item) -> Void) {
        let sheet = rs_ReportSheetView(handler: handler)
        view.addSubview(sheet)
        sheet.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        sheet.rs_show()
    }
    
    // MARK: - Setup
    
    private func rs_setupUI(items: [rs_Item]) {
        addSubview(rs_backgroundView)
        addSubview(rs_containerView)
        rs_containerView.addSubview(rs_stackView)
        
        rs_backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        rs_containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-12)
        }
        
        rs_stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        items.forEach { item in
            let button = rs_buildButton(title: item.rawValue, isPrimary: item.rs_isPrimary)
            button.tag = itemIndex(item)
            rs_stackView.addArrangedSubview(button)
            button.snp.makeConstraints { make in
                make.height.equalTo(item.rs_isPrimary ? 56 : 52)
            }
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(rs_backgroundTapped))
        rs_backgroundView.addGestureRecognizer(tap)
        rs_backgroundView.isUserInteractionEnabled = true
    }
    
    private func rs_buildButton(title: String, isPrimary: Bool) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(isPrimary ? .black : .white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        btn.backgroundColor = isPrimary ? UIColor(hex: "#9CFF3A") : UIColor(hex: "#3A3A3A")
        btn.layer.cornerRadius = 22
        btn.addTarget(self, action: #selector(rs_itemTapped(_:)), for: .touchUpInside)
        return btn
    }
    
    private func itemIndex(_ item: rs_Item) -> Int {
        switch item {
        case .harassment: return 0
        case .spam: return 1
        case .inappropriate: return 2
        case .sexual: return 3
        case .notInterested: return 4
        case .block: return 5
        case .cancel: return 6
        }
    }
    
    private func itemFromTag(_ tag: Int) -> rs_Item {
        switch tag {
        case 0: return .harassment
        case 1: return .spam
        case 2: return .inappropriate
        case 3: return .sexual
        case 4: return .notInterested
        case 5: return .block
        default: return .cancel
        }
    }
    
    // MARK: - Actions
    
    @objc private func rs_itemTapped(_ sender: UIButton) {
        let item = itemFromTag(sender.tag)
        rs_hide { [weak self] in
            self?.rs_actionHandler?(item)
        }
    }
    
    @objc private func rs_backgroundTapped() {
        rs_hide { [weak self] in
            self?.rs_actionHandler?(.cancel)
        }
    }
    
    // MARK: - Animations
    
    private func rs_show() {
        rs_containerView.transform = CGAffineTransform(translationX: 0, y: 300)
        rs_backgroundView.alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.rs_containerView.transform = .identity
            self.rs_backgroundView.alpha = 1
        }
    }
    
    private func rs_hide(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.2, animations: {
            self.rs_containerView.transform = CGAffineTransform(translationX: 0, y: 300)
            self.rs_backgroundView.alpha = 0
        }, completion: { _ in
            self.removeFromSuperview()
            completion()
        })
    }
}
