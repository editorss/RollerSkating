//
//  rs_CameraRecordViewController.swift
//  RollerSkating
//
//  AI Move Recognition - 相机录制界面
//

import UIKit
import SnapKit
import AVFoundation

class rs_CameraRecordViewController: UIViewController {
    
    // MARK: - Properties
    
    var rs_selectedMove: String = ""
    
    private var rs_captureSession: AVCaptureSession?
    private var rs_previewLayer: AVCaptureVideoPreviewLayer?
    private var rs_recordingTimer: Timer?
    private var rs_recordingSeconds: Int = 0
    private var rs_isRedDotVisible = true
    
    // MARK: - UI Elements
    
    /// 相机预览容器
    private let rs_previewView: UIView = {
        let v = UIView()
        v.backgroundColor = .black
        return v
    }()
    
    /// 录制状态容器
    private let rs_recordingStatusView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        v.layer.cornerRadius = 16
        return v
    }()
    
    /// 红点
    private let rs_redDotView: UIView = {
        let v = UIView()
        v.backgroundColor = .red
        v.layer.cornerRadius = 6
        return v
    }()
    
    /// 录制时长
    private let rs_timeLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "00:00"
        lbl.textColor = .white
        lbl.font = UIFont.monospacedDigitSystemFont(ofSize: 16, weight: .medium)
        return lbl
    }()
    
    /// Stop按钮
    private let rs_stopBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "AI Stop按钮"), for: .normal)
        return btn
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rs_setupUI()
        rs_setupCamera()
        rs_setupActions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rs_startRecording()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        rs_stopRecording()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Setup
    
    private func rs_setupUI() {
        view.backgroundColor = .black
        
        view.addSubview(rs_previewView)
        view.addSubview(rs_recordingStatusView)
        rs_recordingStatusView.addSubview(rs_redDotView)
        rs_recordingStatusView.addSubview(rs_timeLabel)
        view.addSubview(rs_stopBtn)
        
        rs_previewView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        rs_recordingStatusView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(32)
        }
        
        rs_redDotView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.size.equalTo(12)
        }
        
        rs_timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(rs_redDotView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
        }
        
        rs_stopBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24)
            make.height.equalTo(56)
        }
    }
    
    private func rs_setupCamera() {
        rs_captureSession = AVCaptureSession()
        rs_captureSession?.sessionPreset = .high
        
        guard let captureSession = rs_captureSession,
              let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: camera)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
            
            rs_previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            rs_previewLayer?.videoGravity = .resizeAspectFill
            rs_previewLayer?.frame = view.bounds
            
            if let previewLayer = rs_previewLayer {
                rs_previewView.layer.addSublayer(previewLayer)
            }
            
            DispatchQueue.global(qos: .userInitiated).async {
                captureSession.startRunning()
            }
        } catch {
            print("Camera setup error: \(error)")
        }
    }
    
    private func rs_setupActions() {
        rs_stopBtn.addTarget(self, action: #selector(rs_stopTapped), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rs_previewLayer?.frame = rs_previewView.bounds
    }
    
    // MARK: - Recording
    
    private func rs_startRecording() {
        rs_recordingSeconds = 0
        rs_updateTimeLabel()
        
        // 启动定时器
        rs_recordingTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.rs_recordingSeconds += 1
            self?.rs_updateTimeLabel()
            self?.rs_toggleRedDot()
        }
    }
    
    private func rs_stopRecording() {
        rs_recordingTimer?.invalidate()
        rs_recordingTimer = nil
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.rs_captureSession?.stopRunning()
        }
    }
    
    private func rs_updateTimeLabel() {
        let minutes = rs_recordingSeconds / 60
        let seconds = rs_recordingSeconds % 60
        rs_timeLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func rs_toggleRedDot() {
        rs_isRedDotVisible.toggle()
        UIView.animate(withDuration: 0.2) {
            self.rs_redDotView.alpha = self.rs_isRedDotVisible ? 1.0 : 0.3
        }
    }
    
    // MARK: - Actions
    
    @objc private func rs_stopTapped() {
        rs_stopRecording()
        
        // 跳转到分析结果界面
        let analysisVC = rs_AIAnalysisResultViewController()
        analysisVC.rs_selectedMove = rs_selectedMove
        analysisVC.rs_recordingDuration = rs_recordingSeconds
        analysisVC.modalPresentationStyle = .fullScreen
        present(analysisVC, animated: true)
    }
}
