//
//  rs_CallViewController.swift
//  RollerSkating
//
//  视频通话界面
//

import UIKit
import SnapKit
import AVFoundation
import AudioToolbox
import SVProgressHUD

final class rs_CallViewController: UIViewController {
    
    private let rs_peerName: String
    private let rs_peerAvatar: String
    
    private var rs_captureSession: AVCaptureSession?
    private var rs_previewLayer: AVCaptureVideoPreviewLayer?
    private var rs_vibrateTimer: Timer?
    private var rs_callTimer: Timer?
    private var rs_callSeconds: Int = 0
    private var rs_isMuted = false
    private var rs_currentCameraPosition: AVCaptureDevice.Position = .front
    private var rs_audioSessionConfigured = false
    
    // MARK: - UI
    
    private let rs_bgImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "ai分析界面全屏背景图")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let rs_avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 64
        return iv
    }()
    
    private let rs_nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let rs_subtitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Call in progress..."
        lbl.textColor = UIColor(white: 0.8, alpha: 1)
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lbl.textAlignment = .center
        return lbl
    }()

    private let rs_timerLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "00:00"
        lbl.textColor = UIColor(white: 0.85, alpha: 1)
        lbl.font = UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .medium)
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let rs_selfPreviewView: UIView = {
        let v = UIView()
        v.backgroundColor = .black
        v.layer.cornerRadius = 16
        v.clipsToBounds = true
        return v
    }()
    
    private let rs_speakerBtn = rs_CallControlButton(
        iconName: "speaker.slash.fill",
        bgColor: UIColor(hex: "#3A2B55"),
        tint: .white
    )
    
    private let rs_cameraBtn = rs_CallControlButton(
        iconName: "camera.fill",
        bgColor: UIColor(hex: "#3A2B55"),
        tint: .white
    )
    
    private let rs_endBtn = rs_CallControlButton(
        iconName: "phone.down.fill",
        bgColor: UIColor(hex: "#FF5A5A"),
        tint: .white
    )
    
    // MARK: - Init
    
    init(peerName: String, peerAvatar: String) {
        self.rs_peerName = peerName
        self.rs_peerAvatar = peerAvatar
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rs_setupUI()
        rs_setupActions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rs_checkPermissionsAndStart()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        rs_stopCall()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Setup
    
    private func rs_setupUI() {
        view.backgroundColor = UIColor(red: 18/255, green: 0/255, blue: 48/255, alpha: 1)
        
        view.addSubview(rs_bgImageView)
        view.addSubview(rs_selfPreviewView)
        view.addSubview(rs_avatarImageView)
        view.addSubview(rs_nameLabel)
        view.addSubview(rs_subtitleLabel)
        view.addSubview(rs_timerLabel)
        view.addSubview(rs_speakerBtn)
        view.addSubview(rs_cameraBtn)
        view.addSubview(rs_endBtn)
        
        rs_bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        rs_selfPreviewView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.leading.equalToSuperview().offset(12)
            make.size.equalTo(CGSize(width: 96, height: 128))
        }
        
        rs_avatarImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(rs_selfPreviewView.snp.bottom).offset(40)
            make.size.equalTo(128)
        }
        
        rs_nameLabel.snp.makeConstraints { make in
            make.top.equalTo(rs_avatarImageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        rs_subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(rs_nameLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(24)
        }

        rs_timerLabel.snp.makeConstraints { make in
            make.top.equalTo(rs_subtitleLabel.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        rs_speakerBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(48)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24)
            make.size.equalTo(56)
        }
        
        rs_cameraBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(rs_speakerBtn)
            make.size.equalTo(56)
        }
        
        rs_endBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-48)
            make.centerY.equalTo(rs_speakerBtn)
            make.size.equalTo(56)
        }
        
        rs_avatarImageView.image = UIImage(named: rs_peerAvatar)
        rs_nameLabel.text = rs_peerName
    }
    
    private func rs_setupActions() {
        rs_endBtn.addTarget(self, action: #selector(rs_endCallTapped), for: .touchUpInside)
        rs_speakerBtn.addTarget(self, action: #selector(rs_muteTapped), for: .touchUpInside)
        rs_cameraBtn.addTarget(self, action: #selector(rs_switchCameraTapped), for: .touchUpInside)
    }
    
    // MARK: - Permission
    
    private func rs_checkPermissionsAndStart() {
        let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
        let group = DispatchGroup()
        var cameraGranted = (cameraStatus == .authorized)
        var micGranted = false
        
        if cameraStatus == .notDetermined {
            group.enter()
            AVCaptureDevice.requestAccess(for: .video) { granted in
                cameraGranted = granted
                group.leave()
            }
        }
        
        group.enter()
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            micGranted = granted
            group.leave()
        }
        
        group.notify(queue: .main) {
            if cameraGranted && micGranted {
                self.rs_startCall()
            } else {
                self.rs_showPermissionAlert()
            }
        }
    }
    
    private func rs_showPermissionAlert() {
        let alert = UIAlertController(
            title: "Permissions Required",
            message: "Camera and microphone access are required to start a video call. Please enable permissions in Settings.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.dismiss(animated: true)
        })
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
        present(alert, animated: true)
    }
    
    // MARK: - Call Flow
    
    private func rs_startCall() {
        rs_configureAudioSessionIfNeeded()
        rs_startCameraPreview()
        rs_startVibration()
        rs_startAvatarRotation()
        rs_startCallTimer()
        SVProgressHUD.showSuccess(withStatus: "Connected")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            SVProgressHUD.dismiss()
        }
    }
    
    private func rs_stopCall() {
        rs_vibrateTimer?.invalidate()
        rs_vibrateTimer = nil
        rs_callTimer?.invalidate()
        rs_callTimer = nil
        rs_callSeconds = 0
        rs_avatarImageView.layer.removeAnimation(forKey: "rs_rotation")
        rs_captureSession?.stopRunning()
        rs_captureSession = nil
        rs_previewLayer?.removeFromSuperlayer()
        rs_previewLayer = nil
    }
    
    private func rs_startVibration() {
        rs_vibrateTimer?.invalidate()
        rs_vibrateTimer = Timer.scheduledTimer(withTimeInterval: 1.2, repeats: true) { _ in
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        }
    }
    
    private func rs_startAvatarRotation() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = 0
        rotation.toValue = Double.pi * 2
        rotation.duration = 3.0
        rotation.repeatCount = .infinity
        rs_avatarImageView.layer.add(rotation, forKey: "rs_rotation")
    }
    
    private func rs_startCameraPreview() {
        let session = AVCaptureSession()
        session.sessionPreset = .high

        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: rs_currentCameraPosition),
              let input = try? AVCaptureDeviceInput(device: camera) else {
            return
        }
        
        if session.canAddInput(input) {
            session.addInput(input)
        }
        
        let preview = AVCaptureVideoPreviewLayer(session: session)
        preview.videoGravity = .resizeAspectFill
        preview.frame = rs_selfPreviewView.bounds
        rs_selfPreviewView.layer.addSublayer(preview)
        
        rs_captureSession = session
        rs_previewLayer = preview
        
        DispatchQueue.global(qos: .userInitiated).async {
            session.startRunning()
        }
    }

    private func rs_startCallTimer() {
        rs_callSeconds = 0
        rs_updateTimerLabel()
        rs_callTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.rs_callSeconds += 1
            self?.rs_updateTimerLabel()
        }
    }

    private func rs_updateTimerLabel() {
        let minutes = rs_callSeconds / 60
        let seconds = rs_callSeconds % 60
        rs_timerLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }

    private func rs_configureAudioSessionIfNeeded() {
        guard !rs_audioSessionConfigured else { return }
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .videoChat, options: [.defaultToSpeaker, .allowBluetooth])
            try session.setActive(true)
            rs_audioSessionConfigured = true
        } catch {
            // ignore
        }
    }
    
    // MARK: - Actions
    
    @objc private func rs_endCallTapped() {
        rs_stopCall()
        dismiss(animated: true)
    }

    @objc private func rs_muteTapped() {
        rs_isMuted.toggle()
        let imageName = rs_isMuted ? "mic.slash.fill" : "speaker.slash.fill"
        rs_speakerBtn.setImage(UIImage(systemName: imageName), for: .normal)
        rs_speakerBtn.backgroundColor = rs_isMuted ? UIColor(hex: "#5C3B3B") : UIColor(hex: "#3A2B55")
    }

    @objc private func rs_switchCameraTapped() {
        rs_currentCameraPosition = (rs_currentCameraPosition == .front) ? .back : .front
        rs_captureSession?.stopRunning()
        rs_captureSession = nil
        rs_previewLayer?.removeFromSuperlayer()
        rs_previewLayer = nil
        rs_startCameraPreview()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rs_previewLayer?.frame = rs_selfPreviewView.bounds
    }
}

// MARK: - Call Control Button

final class rs_CallControlButton: UIButton {
    init(iconName: String, bgColor: UIColor, tint: UIColor) {
        super.init(frame: .zero)
        backgroundColor = bgColor
        layer.cornerRadius = 28
        let image = UIImage(systemName: iconName)
        setImage(image, for: .normal)
        tintColor = tint
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
