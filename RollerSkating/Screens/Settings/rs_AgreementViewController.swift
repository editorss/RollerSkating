//
//  rs_AgreementViewController.swift
//  RollerSkating
//
//  协议详情页 - WebView 加载
//

import UIKit
import SnapKit
import WebKit

enum rs_AgreementType {
    case privacy
    case user
    
    var rs_title: String {
        switch self {
        case .privacy: return "Privacy Agreement"
        case .user: return "User Agreement"
        }
    }
    
    var rs_url: String {
        switch self {
        case .privacy: return "https://docs.google.com/document/d/e/2PACX-1vQDiGEVwO54wwNkTs9unQpVNiJ224DcaKEyS1ptDfPZ6WqYk5FM0IP11h5gQjRniQ/pub"
        case .user: return "https://docs.google.com/document/d/e/2PACX-1vRnCM4dts2MKuCwSOBixPRfiesbsMZa__2nuAEoguAiNnRPm8B8YoWqPFI1C6yZhQ/pub"
        }
    }
}

final class rs_AgreementViewController: UIViewController {
    
    private let rs_type: rs_AgreementType
    
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
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let rs_webView: WKWebView = {
        let config = WKWebViewConfiguration()
        let wv = WKWebView(frame: .zero, configuration: config)
        wv.backgroundColor = .clear
        wv.isOpaque = false
        wv.scrollView.backgroundColor = .clear
        return wv
    }()
    
    private let rs_loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    init(type: rs_AgreementType) {
        self.rs_type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rs_setupUI()
        rs_loadContent()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    private func rs_setupUI() {
        view.addSubview(rs_bgImageView)
        view.addSubview(rs_backBtn)
        view.addSubview(rs_titleLabel)
        view.addSubview(rs_webView)
        view.addSubview(rs_loadingIndicator)
        
        rs_titleLabel.text = rs_type.rs_title
        
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
        rs_webView.snp.makeConstraints { make in
            make.top.equalTo(rs_backBtn.snp.bottom).offset(12)
            make.leading.trailing.bottom.equalToSuperview()
        }
        rs_loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        rs_backBtn.addTarget(self, action: #selector(rs_backTapped), for: .touchUpInside)
        rs_webView.navigationDelegate = self
    }
    
    private func rs_loadContent() {
        rs_loadingIndicator.startAnimating()
        if let url = URL(string: rs_type.rs_url) {
            let request = URLRequest(url: url)
            rs_webView.load(request)
        }
    }
    
    @objc private func rs_backTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension rs_AgreementViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        rs_loadingIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        rs_loadingIndicator.stopAnimating()
    }
}
