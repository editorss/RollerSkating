//
//  rs_UserManager.swift
//  RollerSkating
//
//  用户数据管理 - 本地持久化
//

import Foundation

class rs_UserManager {
    
    // MARK: - Singleton
    
    static let shared = rs_UserManager()
    private init() {}
    
    // MARK: - Keys
    
    private enum rs_Keys {
        static let isLoggedIn = "rs_isLoggedIn"
        static let gender = "rs_gender"
        static let age = "rs_age"
        static let playStyle = "rs_playStyle"
        static let stylePreference = "rs_stylePreference"
        static let userId = "rs_userId"
        static let nickname = "rs_nickname"
        static let avatar = "rs_avatar"
        
        // 用户数据
        static let weeklyGoal = "rs_weeklyGoal"
        static let weeklyGoalTotal = "rs_weeklyGoalTotal"
        static let dayStreak = "rs_dayStreak"
        static let personalBest = "rs_personalBest"
        static let todaySession = "rs_todaySession"
        static let respect = "rs_respect"
        static let mapSpotJoined = "rs_mapSpotJoined"
        static let coins = "rs_coins"
    }
    
    // MARK: - Login State
    
    var rs_isLoggedIn: Bool {
        get { UserDefaults.standard.bool(forKey: rs_Keys.isLoggedIn) }
        set { UserDefaults.standard.set(newValue, forKey: rs_Keys.isLoggedIn) }
    }
    
    // MARK: - Profile Data
    
    var rs_gender: String? {
        get { UserDefaults.standard.string(forKey: rs_Keys.gender) }
        set { UserDefaults.standard.set(newValue, forKey: rs_Keys.gender) }
    }
    
    var rs_age: Int {
        get { UserDefaults.standard.integer(forKey: rs_Keys.age) }
        set { UserDefaults.standard.set(newValue, forKey: rs_Keys.age) }
    }
    
    var rs_playStyle: String? {
        get { UserDefaults.standard.string(forKey: rs_Keys.playStyle) }
        set { UserDefaults.standard.set(newValue, forKey: rs_Keys.playStyle) }
    }
    
    var rs_stylePreference: String? {
        get { UserDefaults.standard.string(forKey: rs_Keys.stylePreference) }
        set { UserDefaults.standard.set(newValue, forKey: rs_Keys.stylePreference) }
    }

    // MARK: - Current User Profile

    var rs_userId: String {
        if let val = UserDefaults.standard.string(forKey: rs_Keys.userId), !val.isEmpty {
            return val
        }
        let newId = "me_\(UUID().uuidString.prefix(6))"
        UserDefaults.standard.set(newId, forKey: rs_Keys.userId)
        return newId
    }

    var rs_nickname: String {
        if let val = UserDefaults.standard.string(forKey: rs_Keys.nickname), !val.isEmpty {
            return val
        }
        let num = Int.random(in: 10000...99999)
        let newName = "user\(num)"
        UserDefaults.standard.set(newName, forKey: rs_Keys.nickname)
        return newName
    }

    var rs_avatar: String {
        if let val = UserDefaults.standard.string(forKey: rs_Keys.avatar), !val.isEmpty {
            return val
        }
        let newAvatar = "默认avatar"
        UserDefaults.standard.set(newAvatar, forKey: rs_Keys.avatar)
        return newAvatar
    }

    func rs_updateProfile(nickname: String? = nil, avatar: String? = nil) {
        if let nickname, !nickname.isEmpty {
            UserDefaults.standard.set(nickname, forKey: rs_Keys.nickname)
        }
        if let avatar, !avatar.isEmpty {
            UserDefaults.standard.set(avatar, forKey: rs_Keys.avatar)
        }
    }
    
    // MARK: - User Stats Data
    
    var rs_weeklyGoal: Int {
        get { UserDefaults.standard.integer(forKey: rs_Keys.weeklyGoal) }
        set { UserDefaults.standard.set(newValue, forKey: rs_Keys.weeklyGoal) }
    }
    
    var rs_weeklyGoalTotal: Int {
        get {
            let val = UserDefaults.standard.integer(forKey: rs_Keys.weeklyGoalTotal)
            return val == 0 ? 7 : val
        }
        set { UserDefaults.standard.set(newValue, forKey: rs_Keys.weeklyGoalTotal) }
    }
    
    var rs_dayStreak: Int {
        get { UserDefaults.standard.integer(forKey: rs_Keys.dayStreak) }
        set { UserDefaults.standard.set(newValue, forKey: rs_Keys.dayStreak) }
    }
    
    var rs_personalBest: Double {
        get { UserDefaults.standard.double(forKey: rs_Keys.personalBest) }
        set { UserDefaults.standard.set(newValue, forKey: rs_Keys.personalBest) }
    }
    
    var rs_todaySession: Int {
        get { UserDefaults.standard.integer(forKey: rs_Keys.todaySession) }
        set { UserDefaults.standard.set(newValue, forKey: rs_Keys.todaySession) }
    }
    
    var rs_respect: Int {
        get { UserDefaults.standard.integer(forKey: rs_Keys.respect) }
        set { UserDefaults.standard.set(newValue, forKey: rs_Keys.respect) }
    }

    // MARK: - Map Join State

    var rs_mapSpotJoined: Bool {
        get { UserDefaults.standard.bool(forKey: rs_Keys.mapSpotJoined) }
        set { UserDefaults.standard.set(newValue, forKey: rs_Keys.mapSpotJoined) }
    }

    // MARK: - Coins (金币)

    var rs_coins: Int {
        get { UserDefaults.standard.integer(forKey: rs_Keys.coins) }
        set { UserDefaults.standard.set(newValue, forKey: rs_Keys.coins) }
    }

    /// 添加金币
    func rs_addCoins(_ amount: Int) {
        rs_coins += amount
    }

    /// 消费金币
    func rs_spendCoins(_ amount: Int) -> Bool {
        guard rs_coins >= amount else { return false }
        rs_coins -= amount
        return true
    }

    /// 检查金币是否足够
    func rs_hasEnoughCoins(_ amount: Int) -> Bool {
        return rs_coins >= amount
    }
    
    // MARK: - Methods
    
    /// 完成注册流程
    func rs_completeOnboarding(gender: String, age: Int, playStyle: String, stylePreference: String) {
        rs_gender = gender
        rs_age = age
        rs_playStyle = playStyle
        rs_stylePreference = stylePreference
        rs_isLoggedIn = true
        _ = rs_userId
        _ = rs_nickname
        _ = rs_avatar
    }
    
    /// 登出/重置
    func rs_logout() {
        rs_isLoggedIn = false
        rs_gender = nil
        rs_age = 0
        rs_playStyle = nil
        rs_stylePreference = nil
        UserDefaults.standard.removeObject(forKey: rs_Keys.userId)
        UserDefaults.standard.removeObject(forKey: rs_Keys.nickname)
        UserDefaults.standard.removeObject(forKey: rs_Keys.avatar)
        rs_weeklyGoal = 0
        rs_dayStreak = 0
        rs_personalBest = 0
        rs_todaySession = 0
        rs_respect = 0
    }
    
    /// 获取格式化的数据显示
    func rs_getWeeklyGoalText() -> String {
        return "\(rs_weeklyGoal)/\(rs_weeklyGoalTotal)"
    }
    
    func rs_getDayStreakText() -> String {
        return "\(rs_dayStreak)/day"
    }
    
    func rs_getPersonalBestText() -> String {
        return String(format: "%.1f/km·h", rs_personalBest)
    }
    
    func rs_getTodaySessionText() -> String {
        return "\(rs_todaySession)/min"
    }
}
