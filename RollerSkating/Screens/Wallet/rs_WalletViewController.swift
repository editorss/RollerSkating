//
//  rs_WalletViewController.swift
//  RollerSkating
//
//  钱包/内购界面
//

import UIKit
import SnapKit
import SVProgressHUD

final class rs_WalletViewController: UIViewController {
    
    private let rs_products = rs_IAPProduct.rs_allProducts
    
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
        lbl.text = "My Wallet"
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let rs_coinIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "金币切图")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let rs_coinLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        lbl.textAlignment = .right
        return lbl
    }()
    
    private let rs_coinContainer: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(hex: "#2B1B4A")
        v.layer.cornerRadius = 16
        return v
    }()
    
    private let rs_desc1Label: UILabel = {
        let lbl = UILabel()
        lbl.text = "👉 Post Premium Updates (More Exposure)"
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private let rs_desc2Label: UILabel = {
        let lbl = UILabel()
        lbl.text = "👉 Use AI Roller Skating Guidance"
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return lbl
    }()
    
    private let rs_tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = false
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rs_setupUI()
        rs_setupTable()
        rs_updateCoins()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rs_updateCoins()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    private func rs_setupUI() {
        view.addSubview(rs_bgImageView)
        view.addSubview(rs_backBtn)
        view.addSubview(rs_titleLabel)
        view.addSubview(rs_coinContainer)
        rs_coinContainer.addSubview(rs_coinIcon)
        rs_coinContainer.addSubview(rs_coinLabel)
        view.addSubview(rs_desc1Label)
        view.addSubview(rs_desc2Label)
        view.addSubview(rs_tableView)
        
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
        rs_coinContainer.snp.makeConstraints { make in
            make.centerY.equalTo(rs_backBtn)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(32)
        }
        rs_coinIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
            make.size.equalTo(20)
        }
        rs_coinLabel.snp.makeConstraints { make in
            make.leading.equalTo(rs_coinIcon.snp.trailing).offset(6)
            make.trailing.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
        }
        rs_desc1Label.snp.makeConstraints { make in
            make.top.equalTo(rs_backBtn.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        rs_desc2Label.snp.makeConstraints { make in
            make.top.equalTo(rs_desc1Label.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        rs_tableView.snp.makeConstraints { make in
            make.top.equalTo(rs_desc2Label.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        rs_backBtn.addTarget(self, action: #selector(rs_backTapped), for: .touchUpInside)
    }
    
    private func rs_setupTable() {
        rs_tableView.delegate = self
        rs_tableView.dataSource = self
        rs_tableView.register(rs_CoinProductCell.self, forCellReuseIdentifier: rs_CoinProductCell.rs_id)
    }
    
    private func rs_updateCoins() {
        rs_coinLabel.text = "\(rs_UserManager.shared.rs_coins)"
    }
    
    @objc private func rs_backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func rs_purchase(product: rs_IAPProduct) {
        guard rs_StoreKitManager.shared.rs_canMakePayments() else {
            SVProgressHUD.showError(withStatus: "In-app purchases are disabled")
            return
        }
        
        SVProgressHUD.show(withStatus: "Processing...")
        
        rs_StoreKitManager.shared.rs_purchase(product: product) { [weak self] success, error in
            SVProgressHUD.dismiss()
            
            if success {
                SVProgressHUD.showSuccess(withStatus: "Purchase successful!")
                self?.rs_updateCoins()
            } else if let error = error {
                SVProgressHUD.showError(withStatus: error)
            }
        }
    }
}

extension rs_WalletViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rs_products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: rs_CoinProductCell.rs_id, for: indexPath) as! rs_CoinProductCell
        cell.rs_configure(product: rs_products[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        rs_purchase(product: rs_products[indexPath.row])
    }
}

// MARK: - Coin Product Cell

final class rs_CoinProductCell: UITableViewCell {
    
    static let rs_id = "rs_CoinProductCell"
    
    private let rs_card: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(hex: "#2B1B4A")
        v.layer.cornerRadius = 12
        return v
    }()
    
    private let rs_coinIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "金币切图")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let rs_coinsLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return lbl
    }()
    
    private let rs_priceLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 18, weight: .bold)
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
        
        contentView.addSubview(rs_card)
        rs_card.addSubview(rs_coinIcon)
        rs_card.addSubview(rs_coinsLabel)
        rs_card.addSubview(rs_priceLabel)
        
        rs_card.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        rs_coinIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(28)
        }
        rs_coinsLabel.snp.makeConstraints { make in
            make.leading.equalTo(rs_coinIcon.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
        }
        rs_priceLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }
    
    func rs_configure(product: rs_IAPProduct) {
        rs_coinsLabel.text = "\(product.coins)"
        rs_priceLabel.text = product.price
    }
}
