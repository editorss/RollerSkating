//
//  rs_MainTabBarController.swift
//  RollerSkating
//
//  主TabBar控制器
//

import UIKit
import SnapKit
import IQKeyboardManagerSwift

class rs_MainTabBarController: UITabBarController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rs_setupTabBar()
        rs_setupViewControllers()
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    // MARK: - Setup
    
    private func rs_setupTabBar() {
        // TabBar背景色
        tabBar.backgroundColor = UIColor(red: 18/255, green: 0/255, blue: 48/255, alpha: 1)
        tabBar.barTintColor = UIColor(red: 18/255, green: 0/255, blue: 48/255, alpha: 1)
        tabBar.isTranslucent = false
        
        // 移除顶部线条
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        
        // 选中颜色
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = .gray
    }
    
    private func rs_setupViewControllers() {
        // 首页
        let homeVC = rs_HomeViewController()
        homeVC.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tabbar_1")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "tabbar_1s")?.withRenderingMode(.alwaysOriginal)
        )
        let homeNav = rs_RootNavigationController(rootViewController: homeVC)
        homeNav.setNavigationBarHidden(true, animated: false)
        
        // 地图页
        let mapVC = rs_MapViewController()
        mapVC.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tabbar_2")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "tabbar_2s")?.withRenderingMode(.alwaysOriginal)
        )
        let mapNav = rs_RootNavigationController(rootViewController: mapVC)
        mapNav.setNavigationBarHidden(true, animated: false)
        
        // Live页
        let liveVC = rs_SkateShowViewController()
        liveVC.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tabbar_3")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "tabbar_3s")?.withRenderingMode(.alwaysOriginal)
        )
        let liveNav = rs_RootNavigationController(rootViewController: liveVC)
        liveNav.setNavigationBarHidden(true, animated: false)
        
        // 训练页
        let trainingVC = rs_SkateFeedViewController()
        trainingVC.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tabbar_4")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "tabbar_4s")?.withRenderingMode(.alwaysOriginal)
        )
        let trainingNav = rs_RootNavigationController(rootViewController: trainingVC)
        trainingNav.setNavigationBarHidden(true, animated: false)
        
        // 个人页
        let profileVC = rs_MyProfileViewController()
        profileVC.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tabbar_5")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "tabbar_5s")?.withRenderingMode(.alwaysOriginal)
        )
        let profileNav = rs_RootNavigationController(rootViewController: profileVC)
        profileNav.setNavigationBarHidden(true, animated: false)
        
        // 调整图标位置
        let navControllers = [homeNav, mapNav, liveNav, trainingNav, profileNav]
        navControllers.forEach { nav in
            nav.viewControllers.first?.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        }
        
        viewControllers = navControllers
    }
}

// MARK: - 占位ViewController

class rs_PlaceholderViewController: UIViewController {
    
    private let rs_titleText: String
    
    init(title: String) {
        self.rs_titleText = title
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 18/255, green: 0/255, blue: 48/255, alpha: 1)
        
        let label = UILabel()
        label.text = rs_titleText
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        view.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

// MARK: - 主导航控制器

final class rs_RootNavigationController: UINavigationController {
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if !viewControllers.isEmpty {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
}
