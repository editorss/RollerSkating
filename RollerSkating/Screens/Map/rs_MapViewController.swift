//
//  rs_MapViewController.swift
//  RollerSkating
//
//  Skate Spots 地图界面
//

import UIKit
import SnapKit
import MapKit
import CoreLocation
import SVProgressHUD

final class rs_MapViewController: UIViewController {
    
    // MARK: - Properties
    
    private let rs_locationManager = CLLocationManager()
    private var rs_hasLocated = false
    
    // MARK: - UI
    
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
        iv.image = UIImage(named: "Skate Spots")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let rs_mapView: MKMapView = {
        let mv = MKMapView()
        mv.layer.cornerRadius = 20
        mv.clipsToBounds = true
        return mv
    }()
    
    private let rs_loadingLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Loading..."
        lbl.textColor = UIColor(white: 0.8, alpha: 1)
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let rs_infoCard: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(hex: "#D947E4")
        v.layer.cornerRadius = 18
        v.clipsToBounds = true
        return v
    }()
    
    private let rs_placeTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "Park Square"
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return lbl
    }()
    
    private let rs_starsLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "★★★★★"
        lbl.textColor = UIColor(hex: "#FFD24D")
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return lbl
    }()
    
    private let rs_peopleBadge: UILabel = {
        let lbl = UILabel()
        lbl.text = "42 People Today"
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        lbl.textAlignment = .center
        lbl.backgroundColor = UIColor(hex: "#9CFF3A")
        lbl.layer.cornerRadius = 16
        lbl.clipsToBounds = true
        return lbl
    }()
    
    private let rs_joinBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Join", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        btn.backgroundColor = UIColor(hex: "#000000")
        btn.layer.cornerRadius = 18
        return btn
    }()
    
    private let rs_subtitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Suitable For Beginners · Road Surface"
        lbl.textColor = UIColor(white: 0.9, alpha: 1)
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return lbl
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rs_setupUI()
        rs_setupMap()
        rs_setupActions()
        rs_checkLocationPermission()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Setup
    
    private func rs_setupUI() {
        view.addSubview(rs_bgImageView)
        view.addSubview(rs_msgBtn)
        view.addSubview(rs_titleImageView)
        view.addSubview(rs_mapView)
        view.addSubview(rs_loadingLabel)
        view.addSubview(rs_infoCard)
        
        rs_infoCard.addSubview(rs_placeTitle)
        rs_infoCard.addSubview(rs_starsLabel)
        rs_infoCard.addSubview(rs_peopleBadge)
        rs_infoCard.addSubview(rs_joinBtn)
        rs_infoCard.addSubview(rs_subtitleLabel)
        
        rs_bgImageView.snp.makeConstraints { make in
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
        
        rs_mapView.snp.makeConstraints { make in
            make.top.equalTo(rs_msgBtn.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(rs_infoCard.snp.top).offset(-16)
        }
        
        rs_loadingLabel.snp.makeConstraints { make in
            make.center.equalTo(rs_mapView)
        }
        
        rs_infoCard.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(110)
        }
        
        rs_placeTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
        }
        
        rs_starsLabel.snp.makeConstraints { make in
            make.top.equalTo(rs_placeTitle.snp.bottom).offset(6)
            make.leading.equalTo(rs_placeTitle)
        }
        
        rs_peopleBadge.snp.makeConstraints { make in
            make.leading.equalTo(rs_placeTitle)
            make.top.equalTo(rs_starsLabel.snp.bottom).offset(6)
            make.height.equalTo(32)
            make.width.equalTo(140)
        }
        
        rs_joinBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 80, height: 36))
        }
        
        rs_subtitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(rs_peopleBadge)
            make.top.equalTo(rs_peopleBadge.snp.bottom).offset(6)
        }
        
        rs_infoCard.isHidden = true
    }
    
    private func rs_setupMap() {
        rs_mapView.delegate = self
        rs_locationManager.delegate = self
        rs_locationManager.desiredAccuracy = kCLLocationAccuracyBest
        rs_mapView.showsUserLocation = true
    }
    
    private func rs_setupActions() {
        rs_msgBtn.addTarget(self, action: #selector(rs_messageTapped), for: .touchUpInside)
        rs_joinBtn.addTarget(self, action: #selector(rs_joinTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func rs_messageTapped() {
        let messageVC = rs_MessageListViewController()
        navigationController?.pushViewController(messageVC, animated: true)
    }
    
    // MARK: - Location
    
    private func rs_checkLocationPermission() {
        switch rs_locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            rs_startLocation()
        case .notDetermined:
            rs_locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            SVProgressHUD.showError(withStatus: "Location permission required")
        @unknown default:
            break
        }
    }
    
    private func rs_startLocation() {
        rs_locationManager.startUpdatingLocation()
        rs_loadingLabel.isHidden = false
        rs_infoCard.isHidden = true
    }
    
    private func rs_showInfoIfNeeded() {
        rs_loadingLabel.isHidden = true
        rs_infoCard.isHidden = false
        rs_updateJoinButton()
    }
}

// MARK: - CLLocationManagerDelegate

extension rs_MapViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        rs_checkLocationPermission()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last, !rs_hasLocated else { return }
        rs_hasLocated = true
        
        let coordinate = location.coordinate
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        rs_mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        rs_mapView.addAnnotation(annotation)
        
        rs_showInfoIfNeeded()
        rs_locationManager.stopUpdatingLocation()
    }
}

// MARK: - MKMapViewDelegate

extension rs_MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        
        let identifier = "rs_pin"
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
            ?? MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        view.markerTintColor = UIColor(hex: "#7F55B2")
        view.glyphTintColor = .white
        return view
    }
}

// MARK: - Join

private extension rs_MapViewController {
    func rs_updateJoinButton() {
        let joined = rs_UserManager.shared.rs_mapSpotJoined
        rs_joinBtn.setTitle(joined ? "Joined" : "Join", for: .normal)
        rs_joinBtn.backgroundColor = joined
            ? UIColor(hex: "#000000", alpha: 0.5)
            : UIColor(hex: "#000000", alpha: 1.0)
    }
    
    @objc func rs_joinTapped() {
        let joined = !rs_UserManager.shared.rs_mapSpotJoined
        rs_UserManager.shared.rs_mapSpotJoined = joined
        rs_updateJoinButton()
        SVProgressHUD.showSuccess(withStatus: joined ? "Joined" : "Cancelled")
    }
}
