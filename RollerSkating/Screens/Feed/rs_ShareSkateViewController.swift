//
//  rs_ShareSkateViewController.swift
//  RollerSkating
//
//  Share Skate
//

import UIKit
import SnapKit
import SVProgressHUD
import IQTextView
import AVFoundation
import Photos

final class rs_ShareSkateViewController: UIViewController {
    
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
        lbl.text = "Share Skate"
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let rs_inputView: IQTextView = {
        let tv = IQTextView()
        tv.backgroundColor = UIColor(hex: "#2B1B4A")
        tv.textColor = .white
        tv.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        tv.layer.cornerRadius = 16
        tv.placeholder = "Write something"
        return tv
    }()
    
    private let rs_tagLeft: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("#TrickSession", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor(hex: "#3A2B55")
        btn.layer.cornerRadius = 16
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return btn
    }()
    
    private let rs_tagRight: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("#SpinTricks", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor(hex: "#C85CFF")
        btn.layer.cornerRadius = 16
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return btn
    }()
    
    private let rs_addCard: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(hex: "#2B1B4A")
        v.layer.cornerRadius = 16
        v.clipsToBounds = true
        return v
    }()
    
    private let rs_addLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "+"
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 30, weight: .regular)
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let rs_addPreviewImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.isHidden = true
        return iv
    }()
    
    private let rs_deleteIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "删除动态按钮")
        iv.contentMode = .scaleAspectFit
        iv.isHidden = true
        return iv
    }()
    
    private let rs_coinLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Requires 100 coins"
        lbl.textColor = UIColor(white: 0.7, alpha: 1)
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let rs_shareBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Share", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        btn.backgroundColor = UIColor(hex: "#C85CFF")
        btn.layer.cornerRadius = 22
        return btn
    }()
    
    private var rs_selectedTag: String = "#SpinTricks"
    private var rs_selectedImagePath: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rs_setupUI()
        rs_setupActions()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    private func rs_setupUI() {
        view.addSubview(rs_bgImageView)
        view.addSubview(rs_backBtn)
        view.addSubview(rs_titleLabel)
        view.addSubview(rs_inputView)
        view.addSubview(rs_tagLeft)
        view.addSubview(rs_tagRight)
        view.addSubview(rs_addCard)
        rs_addCard.addSubview(rs_addLabel)
        rs_addCard.addSubview(rs_addPreviewImageView)
        rs_addCard.addSubview(rs_deleteIcon)
        view.addSubview(rs_coinLabel)
        view.addSubview(rs_shareBtn)
        
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
        rs_inputView.snp.makeConstraints { make in
            make.top.equalTo(rs_backBtn.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(160)
        }
        rs_tagLeft.snp.makeConstraints { make in
            make.top.equalTo(rs_inputView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(36)
            make.width.equalTo(120)
        }
        rs_tagRight.snp.makeConstraints { make in
            make.centerY.equalTo(rs_tagLeft)
            make.leading.equalTo(rs_tagLeft.snp.trailing).offset(12)
            make.height.equalTo(36)
            make.width.equalTo(120)
        }
        rs_addCard.snp.makeConstraints { make in
            make.top.equalTo(rs_tagLeft.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.size.equalTo(120)
        }
        rs_addLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        rs_addPreviewImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        rs_deleteIcon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.size.equalTo(22)
        }
        rs_coinLabel.snp.makeConstraints { make in
            make.top.equalTo(rs_addCard.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
        rs_shareBtn.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(50)
        }
    }
    
    private func rs_setupActions() {
        rs_backBtn.addTarget(self, action: #selector(rs_backTapped), for: .touchUpInside)
        rs_tagLeft.addTarget(self, action: #selector(rs_tagLeftTapped), for: .touchUpInside)
        rs_tagRight.addTarget(self, action: #selector(rs_tagRightTapped), for: .touchUpInside)
        rs_shareBtn.addTarget(self, action: #selector(rs_shareTapped), for: .touchUpInside)
        
        rs_inputView.delegate = self
        let addTap = UITapGestureRecognizer(target: self, action: #selector(rs_addImageTapped))
        rs_addCard.addGestureRecognizer(addTap)
        rs_addCard.isUserInteractionEnabled = true
        
        let deleteTap = UITapGestureRecognizer(target: self, action: #selector(rs_deleteImageTapped))
        rs_deleteIcon.addGestureRecognizer(deleteTap)
        rs_deleteIcon.isUserInteractionEnabled = true
        
        rs_updateShareState()
    }
    
    @objc private func rs_backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func rs_tagLeftTapped() {
        rs_selectedTag = "#TrickSession"
        rs_tagLeft.backgroundColor = UIColor(hex: "#C85CFF")
        rs_tagRight.backgroundColor = UIColor(hex: "#3A2B55")
    }
    
    @objc private func rs_tagRightTapped() {
        rs_selectedTag = "#SpinTricks"
        rs_tagRight.backgroundColor = UIColor(hex: "#C85CFF")
        rs_tagLeft.backgroundColor = UIColor(hex: "#3A2B55")
        rs_updateShareState()
    }
    
    @objc private func rs_addImageTapped() {
        let sheet = UIAlertController(title: "Add Photo", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.rs_requestCamera()
        }))
        sheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            self.rs_requestPhoto()
        }))
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(sheet, animated: true)
    }
    
    @objc private func rs_deleteImageTapped() {
        rs_selectedImagePath = nil
        rs_addPreviewImageView.image = nil
        rs_addPreviewImageView.isHidden = true
        rs_addLabel.isHidden = false
        rs_deleteIcon.isHidden = true
        rs_updateShareState()
    }
    
    private func rs_requestCamera() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        if status == .authorized {
            rs_presentImagePicker(source: .camera)
            return
        }
        if status == .notDetermined {
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    granted ? self.rs_presentImagePicker(source: .camera) : self.rs_showPermissionAlert(type: "Camera")
                }
            }
            return
        }
        rs_showPermissionAlert(type: "Camera")
    }
    
    private func rs_requestPhoto() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch status {
        case .authorized, .limited:
            rs_presentImagePicker(source: .photoLibrary)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                DispatchQueue.main.async {
                    (newStatus == .authorized || newStatus == .limited)
                    ? self.rs_presentImagePicker(source: .photoLibrary)
                    : self.rs_showPermissionAlert(type: "Photos")
                }
            }
        default:
            rs_showPermissionAlert(type: "Photos")
        }
    }
    
    private func rs_showPermissionAlert(type: String) {
        let alert = UIAlertController(
            title: "\(type) Permission Required",
            message: "Please enable access in Settings.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }))
        present(alert, animated: true)
    }
    
    private func rs_presentImagePicker(source: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(source) else { return }
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = source
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    private func rs_updateShareState() {
        let text = rs_inputView.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let hasText = !text.isEmpty
        let hasImage = rs_selectedImagePath != nil
        let canShare = hasText && hasImage
        rs_shareBtn.isEnabled = canShare
        rs_shareBtn.alpha = canShare ? 1.0 : 0.4
    }
    
    @objc private func rs_shareTapped() {
        rs_hideKeyboard()
        rs_updateShareState()
        guard rs_shareBtn.isEnabled else {
            SVProgressHUD.showError(withStatus: "Please complete all fields")
            return
        }
        
        // 检查金币
        let requiredCoins = 100
        if !rs_UserManager.shared.rs_hasEnoughCoins(requiredCoins) {
            // 金币不足，弹窗提示
            let alert = UIAlertController(
                title: "Insufficient Coins",
                message: "Posting requires 100 coins. Would you like to purchase more coins?",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Buy Coins", style: .default) { [weak self] _ in
                let walletVC = rs_WalletViewController()
                self?.navigationController?.pushViewController(walletVC, animated: true)
            })
            present(alert, animated: true)
            return
        }
        
        // 扣除金币
        _ = rs_UserManager.shared.rs_spendCoins(requiredCoins)
        
        let content = rs_inputView.text ?? ""
        let imagePath = rs_selectedImagePath ?? ""
        _ = rs_LocalJSONStore.shared.rs_addPostForCurrentUser(
            content: content,
            imageName: imagePath,
            tags: [rs_selectedTag]
        )
        SVProgressHUD.showSuccess(withStatus: "Shared")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func rs_hideKeyboard() {
        view.endEditing(true)
    }
    
    private func rs_saveImageToDocuments(_ image: UIImage) -> String? {
        let fileName = "rs_post_\(Int(Date().timeIntervalSince1970)).jpg"
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
        if let data = image.jpegData(compressionQuality: 0.85) {
            try? data.write(to: url, options: .atomic)
            // 只返回文件名，避免沙盒路径变化导致加载失败
            return fileName
        }
        return nil
    }
}

extension rs_ShareSkateViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        rs_updateShareState()
    }
}

extension rs_ShareSkateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = (info[.editedImage] ?? info[.originalImage]) as? UIImage
        picker.dismiss(animated: true)
        guard let image else { return }
        
        SVProgressHUD.show(withStatus: "Uploading...")
        DispatchQueue.global().async {
            let fileName = self.rs_saveImageToDocuments(image)
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                if let fileName {
                    self.rs_selectedImagePath = fileName
                    // 使用 rs_load 加载图片
                    self.rs_addPreviewImageView.image = UIImage.rs_load(fileName)
                    self.rs_addPreviewImageView.isHidden = false
                    self.rs_addLabel.isHidden = true
                    self.rs_deleteIcon.isHidden = false
                    self.rs_updateShareState()
                } else {
                    SVProgressHUD.showError(withStatus: "Upload failed")
                }
            }
        }
    }
}
