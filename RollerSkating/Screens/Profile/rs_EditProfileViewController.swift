//
//  rs_EditProfileViewController.swift
//  RollerSkating
//
//  Edit profile
//

import UIKit
import SnapKit
import AVFoundation
import Photos
import SVProgressHUD

final class rs_EditProfileViewController: UIViewController {
    
    private let rs_ageRange = Array(18...50)
    private var rs_selectedGender: String?
    private var rs_selectedAge: Int?
    private var rs_selectedAvatarPath: String?
    
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
        lbl.text = "Edit profile"
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return lbl
    }()
    
    private let rs_avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 50
        iv.clipsToBounds = true
        return iv
    }()
    
    private let rs_avatarBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = UIColor(hex: "#9CFF3A")
        btn.layer.cornerRadius = 16
        btn.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        btn.tintColor = .black
        return btn
    }()
    
    private let rs_nicknameTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "Nickname"
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return lbl
    }()
    
    private let rs_nicknameBg: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(hex: "#2B1B4A")
        v.layer.cornerRadius = 16
        return v
    }()
    
    private let rs_nicknameField: UITextField = {
        let tf = UITextField()
        tf.textColor = .white
        tf.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        tf.attributedPlaceholder = NSAttributedString(
            string: "Please enter....",
            attributes: [.foregroundColor: UIColor(hex: "#B3B3B3")]
        )
        return tf
    }()
    
    private let rs_genderTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "Gender"
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return lbl
    }()
    
    private let rs_genderBtn = rs_SelectFieldButton()
    
    private let rs_ageTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "Age"
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return lbl
    }()
    
    private let rs_ageBtn = rs_SelectFieldButton()
    
    private let rs_saveBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Save", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        btn.backgroundColor = UIColor(hex: "#C85CFF")
        btn.layer.cornerRadius = 22
        return btn
    }()
    
    private let rs_pickerMask = UIView()
    private let rs_pickerContainer = UIView()
    private let rs_agePicker = UIPickerView()
    private let rs_pickerCancelBtn = UIButton(type: .custom)
    private let rs_pickerDoneBtn = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rs_setupUI()
        rs_setupActions()
        rs_loadProfile()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    private func rs_setupUI() {
        view.addSubview(rs_bgImageView)
        view.addSubview(rs_backBtn)
        view.addSubview(rs_titleLabel)
        view.addSubview(rs_avatarImageView)
        view.addSubview(rs_avatarBtn)
        view.addSubview(rs_nicknameTitle)
        view.addSubview(rs_nicknameBg)
        rs_nicknameBg.addSubview(rs_nicknameField)
        view.addSubview(rs_genderTitle)
        view.addSubview(rs_genderBtn)
        view.addSubview(rs_ageTitle)
        view.addSubview(rs_ageBtn)
        view.addSubview(rs_saveBtn)
        
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
        rs_avatarImageView.snp.makeConstraints { make in
            make.top.equalTo(rs_backBtn.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.size.equalTo(100)
        }
        rs_avatarBtn.snp.makeConstraints { make in
            make.trailing.equalTo(rs_avatarImageView.snp.trailing).offset(6)
            make.bottom.equalTo(rs_avatarImageView.snp.bottom).offset(6)
            make.size.equalTo(32)
        }
        rs_nicknameTitle.snp.makeConstraints { make in
            make.top.equalTo(rs_avatarImageView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(16)
        }
        rs_nicknameBg.snp.makeConstraints { make in
            make.top.equalTo(rs_nicknameTitle.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(52)
        }
        rs_nicknameField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        rs_genderTitle.snp.makeConstraints { make in
            make.top.equalTo(rs_nicknameBg.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(16)
        }
        rs_genderBtn.snp.makeConstraints { make in
            make.top.equalTo(rs_genderTitle.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(52)
        }
        rs_ageTitle.snp.makeConstraints { make in
            make.top.equalTo(rs_genderBtn.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(16)
        }
        rs_ageBtn.snp.makeConstraints { make in
            make.top.equalTo(rs_ageTitle.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(52)
        }
        rs_saveBtn.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-18)
            make.height.equalTo(50)
        }
        
        rs_setupPickerSheet()
    }
    
    private func rs_setupPickerSheet() {
        rs_pickerMask.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        rs_pickerMask.alpha = 0
        rs_pickerContainer.backgroundColor = UIColor(hex: "#1E0B3C")
        rs_pickerContainer.layer.cornerRadius = 16
        
        rs_pickerCancelBtn.setTitle("Cancel", for: .normal)
        rs_pickerCancelBtn.setTitleColor(.white, for: .normal)
        rs_pickerDoneBtn.setTitle("Done", for: .normal)
        rs_pickerDoneBtn.setTitleColor(.white, for: .normal)
        
        rs_agePicker.dataSource = self
        rs_agePicker.delegate = self
        
        view.addSubview(rs_pickerMask)
        view.addSubview(rs_pickerContainer)
        rs_pickerContainer.addSubview(rs_pickerCancelBtn)
        rs_pickerContainer.addSubview(rs_pickerDoneBtn)
        rs_pickerContainer.addSubview(rs_agePicker)
        
        rs_pickerMask.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        rs_pickerContainer.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(280)
        }
        rs_pickerCancelBtn.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(12)
        }
        rs_pickerDoneBtn.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(12)
        }
        rs_agePicker.snp.makeConstraints { make in
            make.top.equalTo(rs_pickerCancelBtn.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview().inset(12)
            make.height.equalTo(180)
        }
    }
    
    private func rs_setupActions() {
        rs_backBtn.addTarget(self, action: #selector(rs_backTapped), for: .touchUpInside)
        rs_avatarBtn.addTarget(self, action: #selector(rs_avatarTapped), for: .touchUpInside)
        rs_genderBtn.addTarget(self, action: #selector(rs_genderTapped), for: .touchUpInside)
        rs_ageBtn.addTarget(self, action: #selector(rs_ageTapped), for: .touchUpInside)
        rs_saveBtn.addTarget(self, action: #selector(rs_saveTapped), for: .touchUpInside)
        rs_pickerCancelBtn.addTarget(self, action: #selector(rs_pickerCancelTapped), for: .touchUpInside)
        rs_pickerDoneBtn.addTarget(self, action: #selector(rs_pickerDoneTapped), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(rs_hideKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    private func rs_loadProfile() {
        let user = rs_UserManager.shared
        rs_nicknameField.text = user.rs_nickname
        rs_selectedGender = user.rs_gender
        rs_selectedAge = user.rs_age == 0 ? nil : user.rs_age
        rs_selectedAvatarPath = user.rs_avatar
        
        rs_avatarImageView.image = UIImage.rs_load(user.rs_avatar)
        rs_genderBtn.rs_setText(rs_selectedGender ?? "Please select....")
        if let age = rs_selectedAge {
            rs_ageBtn.rs_setText("\(age)")
        } else {
            rs_ageBtn.rs_setText("Please select....")
        }
    }
    
    @objc private func rs_hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func rs_backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func rs_avatarTapped() {
        let sheet = UIAlertController(title: "Change Avatar", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.rs_requestCamera()
        }))
        sheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            self.rs_requestPhoto()
        }))
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(sheet, animated: true)
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
    
    @objc private func rs_genderTapped() {
        let sheet = UIAlertController(title: "Gender", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Male", style: .default, handler: { _ in
            self.rs_selectedGender = "male"
            self.rs_genderBtn.rs_setText("male")
        }))
        sheet.addAction(UIAlertAction(title: "Female", style: .default, handler: { _ in
            self.rs_selectedGender = "female"
            self.rs_genderBtn.rs_setText("female")
        }))
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(sheet, animated: true)
    }
    
    @objc private func rs_ageTapped() {
        rs_showPickerSheet()
    }
    
    private func rs_showPickerSheet() {
        rs_pickerMask.alpha = 0
        view.bringSubviewToFront(rs_pickerMask)
        view.bringSubviewToFront(rs_pickerContainer)
        let currentAge = rs_selectedAge ?? rs_ageRange.first ?? 18
        if let idx = rs_ageRange.firstIndex(of: currentAge) {
            rs_agePicker.selectRow(idx, inComponent: 0, animated: false)
        }
        UIView.animate(withDuration: 0.25) {
            self.rs_pickerMask.alpha = 1
            self.rs_pickerContainer.snp.updateConstraints { make in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-8)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func rs_pickerCancelTapped() {
        rs_hidePickerSheet()
    }
    
    @objc private func rs_pickerDoneTapped() {
        let row = rs_agePicker.selectedRow(inComponent: 0)
        rs_selectedAge = rs_ageRange[row]
        rs_ageBtn.rs_setText("\(rs_ageRange[row])")
        rs_hidePickerSheet()
    }
    
    private func rs_hidePickerSheet() {
        UIView.animate(withDuration: 0.25, animations: {
            self.rs_pickerMask.alpha = 0
            self.rs_pickerContainer.snp.updateConstraints { make in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(280)
            }
            self.view.layoutIfNeeded()
        })
    }
    
    @objc private func rs_saveTapped() {
        let nickname = rs_nicknameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if nickname.isEmpty {
            SVProgressHUD.showError(withStatus: "Please enter nickname")
            return
        }
        rs_UserManager.shared.rs_updateProfile(nickname: nickname, avatar: rs_selectedAvatarPath)
        if let gender = rs_selectedGender {
            rs_UserManager.shared.rs_gender = gender
        }
        if let age = rs_selectedAge {
            rs_UserManager.shared.rs_age = age
        }
        _ = rs_LocalJSONStore.shared.rs_getCurrentUser()
        SVProgressHUD.showSuccess(withStatus: "Saved")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func rs_saveAvatarImage(_ image: UIImage) -> String? {
        let fileName = "rs_avatar_\(Int(Date().timeIntervalSince1970)).jpg"
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
        if let data = image.jpegData(compressionQuality: 0.8) {
            try? data.write(to: url, options: .atomic)
            // 只返回文件名，避免沙盒路径变化导致加载失败
            return fileName
        }
        return nil
    }
}

extension rs_EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = (info[.editedImage] ?? info[.originalImage]) as? UIImage
        if let image, let fileName = rs_saveAvatarImage(image) {
            rs_selectedAvatarPath = fileName
            rs_avatarImageView.image = UIImage.rs_load(fileName)
        }
        picker.dismiss(animated: true)
    }
}

extension rs_EditProfileViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return rs_ageRange.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(rs_ageRange[row])"
    }
}

final class rs_SelectFieldButton: UIButton {
    
    private let rs_valueLabel = UILabel()
    private let rs_chevron = UIImageView(image: UIImage(systemName: "chevron.right"))
    
    init() {
        super.init(frame: .zero)
        backgroundColor = UIColor(hex: "#2B1B4A")
        layer.cornerRadius = 16
        rs_valueLabel.textColor = UIColor(hex: "#B3B3B3")
        rs_valueLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        rs_chevron.tintColor = UIColor(hex: "#B3B3B3")
        addSubview(rs_valueLabel)
        addSubview(rs_chevron)
        rs_valueLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        rs_chevron.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func rs_setText(_ text: String) {
        rs_valueLabel.text = text
        let isPlaceholder = text.contains("Please")
        rs_valueLabel.textColor = isPlaceholder ? UIColor(hex: "#B3B3B3") : .white
    }
}
