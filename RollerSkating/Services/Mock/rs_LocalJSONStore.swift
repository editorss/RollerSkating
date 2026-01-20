//
//  rs_LocalJSONStore.swift
//  RollerSkating
//
//  本地JSON模拟服务器数据（可读写）
//

import Foundation

struct rs_LocalUserDB: Codable {
    var users: [rs_UserProfile]
}

struct rs_UserProfile: Codable {
    let id: String
    var nickname: String
    var avatar: String
    var gender: String
    var heatValue: Int
    var isFollowed: Bool
    var isBlocked: Bool
    var followers: Int
    var following: Int
    var videos: [rs_ShortVideo]
    var posts: [rs_UserPost]
    var conversations: [rs_Conversation]
    
    enum CodingKeys: String, CodingKey {
        case id, nickname, avatar, gender, heatValue, isFollowed, isBlocked, followers, following, videos, posts, conversations
    }
    
    init(id: String, nickname: String, avatar: String, gender: String, heatValue: Int, isFollowed: Bool, isBlocked: Bool, followers: Int, following: Int, videos: [rs_ShortVideo], posts: [rs_UserPost], conversations: [rs_Conversation]) {
        self.id = id
        self.nickname = nickname
        self.avatar = avatar
        self.gender = gender
        self.heatValue = heatValue
        self.isFollowed = isFollowed
        self.isBlocked = isBlocked
        self.followers = followers
        self.following = following
        self.videos = videos
        self.posts = posts
        self.conversations = conversations
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        nickname = try container.decode(String.self, forKey: .nickname)
        avatar = try container.decode(String.self, forKey: .avatar)
        gender = try container.decode(String.self, forKey: .gender)
        heatValue = (try? container.decode(Int.self, forKey: .heatValue)) ?? 0
        isFollowed = (try? container.decode(Bool.self, forKey: .isFollowed)) ?? false
        isBlocked = (try? container.decode(Bool.self, forKey: .isBlocked)) ?? false
        followers = (try? container.decode(Int.self, forKey: .followers)) ?? 0
        following = (try? container.decode(Int.self, forKey: .following)) ?? 0
        videos = (try? container.decode([rs_ShortVideo].self, forKey: .videos)) ?? []
        posts = (try? container.decode([rs_UserPost].self, forKey: .posts)) ?? []
        conversations = (try? container.decode([rs_Conversation].self, forKey: .conversations)) ?? []
    }
}

struct rs_ShortVideo: Codable {
    let id: String
    var videoName: String
    var caption: String
    var comments: Int
    var likes: Int
    var isLiked: Bool
    var commentList: [rs_VideoComment]

    enum CodingKeys: String, CodingKey {
        case id, videoName, caption, comments, likes, isLiked, commentList
    }

    init(id: String, videoName: String, caption: String, comments: Int, likes: Int, isLiked: Bool, commentList: [rs_VideoComment]) {
        self.id = id
        self.videoName = videoName
        self.caption = caption
        self.comments = comments
        self.likes = likes
        self.isLiked = isLiked
        self.commentList = commentList
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        videoName = try container.decode(String.self, forKey: .videoName)
        caption = (try? container.decode(String.self, forKey: .caption)) ?? ""
        comments = (try? container.decode(Int.self, forKey: .comments)) ?? 0
        likes = (try? container.decode(Int.self, forKey: .likes)) ?? 0
        isLiked = (try? container.decode(Bool.self, forKey: .isLiked)) ?? false
        commentList = (try? container.decode([rs_VideoComment].self, forKey: .commentList)) ?? []
    }
}

struct rs_VideoComment: Codable {
    let id: String
    var userName: String
    var avatar: String
    var text: String
    var timeAgo: String
}

struct rs_UserPost: Codable {
    let id: String
    var avatar: String
    var nickname: String
    var isFollowed: Bool
    var timeAgo: String
    var content: String
    var imageName: String
    var comments: Int
    var likes: Int
    var isLiked: Bool
    var tags: [String]
    var commentList: [rs_PostComment]

    enum CodingKeys: String, CodingKey {
        case id, avatar, nickname, isFollowed, timeAgo, content, imageName, comments, likes, isLiked, tags, commentList
    }

    init(id: String, avatar: String, nickname: String, isFollowed: Bool, timeAgo: String, content: String, imageName: String, comments: Int, likes: Int, isLiked: Bool, tags: [String], commentList: [rs_PostComment]) {
        self.id = id
        self.avatar = avatar
        self.nickname = nickname
        self.isFollowed = isFollowed
        self.timeAgo = timeAgo
        self.content = content
        self.imageName = imageName
        self.comments = comments
        self.likes = likes
        self.isLiked = isLiked
        self.tags = tags
        self.commentList = commentList
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        avatar = try container.decode(String.self, forKey: .avatar)
        nickname = try container.decode(String.self, forKey: .nickname)
        isFollowed = (try? container.decode(Bool.self, forKey: .isFollowed)) ?? false
        timeAgo = try container.decode(String.self, forKey: .timeAgo)
        content = try container.decode(String.self, forKey: .content)
        imageName = try container.decode(String.self, forKey: .imageName)
        comments = (try? container.decode(Int.self, forKey: .comments)) ?? 0
        likes = (try? container.decode(Int.self, forKey: .likes)) ?? 0
        isLiked = (try? container.decode(Bool.self, forKey: .isLiked)) ?? false
        tags = (try? container.decode([String].self, forKey: .tags)) ?? []
        commentList = (try? container.decode([rs_PostComment].self, forKey: .commentList)) ?? []
    }
}

struct rs_PostComment: Codable {
    let id: String
    var userName: String
    var avatar: String
    var text: String
    var timeAgo: String
}

struct rs_Conversation: Codable {
    let id: String
    var peerName: String
    var lastMessage: String
    var avatar: String
    var isUnread: Bool
    var messages: [rs_ConversationMessage]

    enum CodingKeys: String, CodingKey {
        case id, peerName, lastMessage, avatar, isUnread, messages
    }

    init(id: String, peerName: String, lastMessage: String, avatar: String, isUnread: Bool, messages: [rs_ConversationMessage]) {
        self.id = id
        self.peerName = peerName
        self.lastMessage = lastMessage
        self.avatar = avatar
        self.isUnread = isUnread
        self.messages = messages
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        peerName = try container.decode(String.self, forKey: .peerName)
        lastMessage = try container.decode(String.self, forKey: .lastMessage)
        avatar = try container.decode(String.self, forKey: .avatar)
        isUnread = (try? container.decode(Bool.self, forKey: .isUnread)) ?? false
        messages = (try? container.decode([rs_ConversationMessage].self, forKey: .messages)) ?? []
    }
}

struct rs_ConversationMessage: Codable {
    let id: String
    var text: String
    var isFromMe: Bool
    var timeAgo: String
}

class rs_LocalJSONStore {
    
    static let shared = rs_LocalJSONStore()
    private init() {}
    
    private let rs_fileName = "rs_mock_users.json"
    private var rs_currentUserId: String {
        return rs_UserManager.shared.rs_userId
    }
    
    private var rs_documentsURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private var rs_writableFileURL: URL {
        rs_documentsURL.appendingPathComponent(rs_fileName)
    }
    
    // MARK: - Public API
    
    /// 加载用户数据（优先读取可写文件）
    func rs_loadUsers() -> [rs_UserProfile] {
        rs_prepareWritableJSONIfNeeded()
        
        do {
            print("[rs_LocalJSONStore] Read file:", rs_writableFileURL.path)
            let data = try Data(contentsOf: rs_writableFileURL)
            print("[rs_LocalJSONStore] Data size:", data.count)
            let db = try JSONDecoder().decode(rs_LocalUserDB.self, from: data)
            print("[rs_LocalJSONStore] Users count:", db.users.count)
            return db.users
        } catch {
            print("[rs_LocalJSONStore] Decode error:", error.localizedDescription)
            return rs_recoverAndReload()
        }
    }

    private func rs_recoverAndReload() -> [rs_UserProfile] {
        do {
            if FileManager.default.fileExists(atPath: rs_writableFileURL.path) {
                try FileManager.default.removeItem(at: rs_writableFileURL)
                print("[rs_LocalJSONStore] Removed writable JSON, will recopy from bundle.")
            }
        } catch {
            print("[rs_LocalJSONStore] Remove error:", error.localizedDescription)
        }
        rs_prepareWritableJSONIfNeeded()
        do {
            let data = try Data(contentsOf: rs_writableFileURL)
            let db = try JSONDecoder().decode(rs_LocalUserDB.self, from: data)
            print("[rs_LocalJSONStore] Reload users count:", db.users.count)
            return db.users
        } catch {
            print("[rs_LocalJSONStore] Reload decode error:", error.localizedDescription)
            return []
        }
    }
    
    /// 保存用户数据到可写JSON
    func rs_saveUsers(_ users: [rs_UserProfile]) {
        let db = rs_LocalUserDB(users: users)
        do {
            let data = try JSONEncoder().encode(db)
            try data.write(to: rs_writableFileURL, options: .atomic)
        } catch {
            // ignore
        }
    }
    
    /// 更新某个用户的关注状态
    func rs_updateFollow(userId: String, isFollowed: Bool) {
        var users = rs_loadUsers()
        if let index = users.firstIndex(where: { $0.id == userId }) {
            users[index].isFollowed = isFollowed
            rs_saveUsers(users)
        }
    }
    
    /// 更新动态点赞
    func rs_updatePostLike(userId: String, postId: String, isLiked: Bool) {
        var users = rs_loadUsers()
        if let uIndex = users.firstIndex(where: { $0.id == userId }) {
            if let pIndex = users[uIndex].posts.firstIndex(where: { $0.id == postId }) {
                users[uIndex].posts[pIndex].isLiked = isLiked
                let delta = isLiked ? 1 : -1
                users[uIndex].posts[pIndex].likes = max(0, users[uIndex].posts[pIndex].likes + delta)
                rs_saveUsers(users)
            }
        }
    }
    
    /// 更新视频点赞
    func rs_updateVideoLike(userId: String, videoId: String, isLiked: Bool) {
        var users = rs_loadUsers()
        if let uIndex = users.firstIndex(where: { $0.id == userId }) {
            if let vIndex = users[uIndex].videos.firstIndex(where: { $0.id == videoId }) {
                users[uIndex].videos[vIndex].isLiked = isLiked
                let delta = isLiked ? 1 : -1
                users[uIndex].videos[vIndex].likes = max(0, users[uIndex].videos[vIndex].likes + delta)
                rs_saveUsers(users)
            }
        }
    }
    
    /// 追加动态评论数
    func rs_addPostComment(userId: String, postId: String) {
        var users = rs_loadUsers()
        if let uIndex = users.firstIndex(where: { $0.id == userId }) {
            if let pIndex = users[uIndex].posts.firstIndex(where: { $0.id == postId }) {
                users[uIndex].posts[pIndex].comments += 1
                rs_saveUsers(users)
            }
        }
    }

    /// 追加动态评论内容
    func rs_appendPostComment(userId: String, postId: String, userName: String, avatar: String, text: String) {
        var users = rs_loadUsers()
        if let uIndex = users.firstIndex(where: { $0.id == userId }) {
            if let pIndex = users[uIndex].posts.firstIndex(where: { $0.id == postId }) {
                let comment = rs_PostComment(
                    id: "pc_\(UUID().uuidString.prefix(8))",
                    userName: userName,
                    avatar: avatar,
                    text: text,
                    timeAgo: "now"
                )
                users[uIndex].posts[pIndex].commentList.append(comment)
                users[uIndex].posts[pIndex].comments += 1
                rs_saveUsers(users)
            }
        }
    }
    
    /// 追加视频评论数
    func rs_addVideoComment(userId: String, videoId: String) {
        var users = rs_loadUsers()
        if let uIndex = users.firstIndex(where: { $0.id == userId }) {
            if let vIndex = users[uIndex].videos.firstIndex(where: { $0.id == videoId }) {
                users[uIndex].videos[vIndex].comments += 1
                rs_saveUsers(users)
            }
        }
    }

    /// 追加视频评论内容
    func rs_appendVideoComment(userId: String, videoId: String, userName: String, avatar: String, text: String) {
        var users = rs_loadUsers()
        if let uIndex = users.firstIndex(where: { $0.id == userId }) {
            if let vIndex = users[uIndex].videos.firstIndex(where: { $0.id == videoId }) {
                let comment = rs_VideoComment(
                    id: "vc_\(UUID().uuidString.prefix(8))",
                    userName: userName,
                    avatar: avatar,
                    text: text,
                    timeAgo: "now"
                )
                users[uIndex].videos[vIndex].commentList.append(comment)
                users[uIndex].videos[vIndex].comments += 1
                rs_saveUsers(users)
            }
        }
    }

    // MARK: - Conversation

    /// 读取所有会话（聚合）
    func rs_loadConversations() -> [rs_Conversation] {
        let users = rs_loadUsers()
        return users.flatMap { $0.conversations }
    }

    /// 获取或创建会话
    func rs_getOrCreateConversation(peerName: String, avatar: String) -> String {
        var users = rs_loadUsers()
        if let existing = users.flatMap({ $0.conversations }).first(where: { $0.peerName == peerName }) {
            return existing.id
        }
        guard !users.isEmpty else { return "c_unknown" }
        let newId = "c_\(UUID().uuidString.prefix(6))"
        let convo = rs_Conversation(
            id: newId,
            peerName: peerName,
            lastMessage: "",
            avatar: avatar,
            isUnread: false,
            messages: []
        )
        let result = rs_ensureCurrentUser(&users)
        if let idx = result.index {
            users[idx].conversations.append(convo)
            rs_saveUsers(users)
        }
        return newId
    }

    /// 通过昵称获取用户
    func rs_getUserByName(_ name: String) -> rs_UserProfile? {
        let users = rs_loadUsers()
        return users.first(where: { $0.nickname == name })
    }

    /// 通过ID获取用户
    func rs_getUserById(_ id: String) -> rs_UserProfile? {
        let users = rs_loadUsers()
        return users.first(where: { $0.id == id })
    }

    /// 获取当前用户
    func rs_getCurrentUser() -> rs_UserProfile? {
        var users = rs_loadUsers()
        let result = rs_ensureCurrentUser(&users)
        if result.didChange {
            rs_saveUsers(users)
        }
        return result.user
    }

    private func rs_ensureCurrentUser(_ users: inout [rs_UserProfile]) -> (user: rs_UserProfile?, index: Int?, didChange: Bool) {
        let currentId = rs_currentUserId
        let nickname = rs_UserManager.shared.rs_nickname
        let avatar = rs_UserManager.shared.rs_avatar
        let gender = rs_UserManager.shared.rs_gender ?? "unknown"
        var didChange = false
        
        if let idx = users.firstIndex(where: { $0.id == currentId }) {
            if users[idx].nickname != nickname {
                users[idx].nickname = nickname
                didChange = true
            }
            if users[idx].avatar != avatar {
                users[idx].avatar = avatar
                didChange = true
            }
            if users[idx].gender != gender {
                users[idx].gender = gender
                didChange = true
            }
            return (users[idx], idx, didChange)
        }
        
        let newUser = rs_UserProfile(
            id: currentId,
            nickname: nickname,
            avatar: avatar,
            gender: gender,
            heatValue: 0,
            isFollowed: false,
            isBlocked: false,
            followers: 0,
            following: 0,
            videos: [],
            posts: [],
            conversations: []
        )
        users.insert(newUser, at: 0)
        didChange = true
        return (newUser, 0, didChange)
    }

    /// 切换关注状态并更新粉丝/关注数量
    func rs_toggleFollow(targetUserId: String) -> Bool {
        var users = rs_loadUsers()
        guard let targetIndex = users.firstIndex(where: { $0.id == targetUserId }) else {
            return false
        }
        let result = rs_ensureCurrentUser(&users)
        guard let currentIndex = result.index else { return false }
        
        let willFollow = !users[targetIndex].isFollowed
        users[targetIndex].isFollowed = willFollow
        users[targetIndex].followers = max(0, users[targetIndex].followers + (willFollow ? 1 : -1))
        users[currentIndex].following = max(0, users[currentIndex].following + (willFollow ? 1 : -1))
        
        rs_saveUsers(users)
        return willFollow
    }

    /// 拉黑用户
    func rs_blockUser(targetUserId: String) {
        var users = rs_loadUsers()
        if let index = users.firstIndex(where: { $0.id == targetUserId }) {
            users[index].isBlocked = true
            rs_saveUsers(users)
        }
    }

    /// 取消拉黑用户
    func rs_unblockUser(targetUserId: String) {
        var users = rs_loadUsers()
        if let index = users.firstIndex(where: { $0.id == targetUserId }) {
            users[index].isBlocked = false
            rs_saveUsers(users)
        }
    }

    /// 新增动态（当前用户）
    func rs_addPostForCurrentUser(content: String, imageName: String, tags: [String]) -> rs_UserPost? {
        var users = rs_loadUsers()
        let result = rs_ensureCurrentUser(&users)
        guard let idx = result.index else { return nil }
        let user = users[idx]
        let newPost = rs_UserPost(
            id: "p_\(UUID().uuidString.prefix(8))",
            avatar: user.avatar,
            nickname: user.nickname,
            isFollowed: user.isFollowed,
            timeAgo: "just now",
            content: content,
            imageName: imageName,
            comments: 0,
            likes: 0,
            isLiked: false,
            tags: tags,
            commentList: []
        )
        users[idx].posts.insert(newPost, at: 0)
        rs_saveUsers(users)
        return newPost
    }

    /// 删除动态（当前用户）
    func rs_deletePostForCurrentUser(postId: String) {
        var users = rs_loadUsers()
        let result = rs_ensureCurrentUser(&users)
        guard let idx = result.index else { return }
        users[idx].posts.removeAll(where: { $0.id == postId })
        rs_saveUsers(users)
    }

    /// 标记会话已读
    func rs_markConversationRead(conversationId: String) {
        var users = rs_loadUsers()
        for uIndex in users.indices {
            if let cIndex = users[uIndex].conversations.firstIndex(where: { $0.id == conversationId }) {
                users[uIndex].conversations[cIndex].isUnread = false
                rs_saveUsers(users)
                return
            }
        }
    }

    /// 追加会话消息
    func rs_appendMessage(conversationId: String, text: String, isFromMe: Bool) {
        var users = rs_loadUsers()
        for uIndex in users.indices {
            if let cIndex = users[uIndex].conversations.firstIndex(where: { $0.id == conversationId }) {
                let msg = rs_ConversationMessage(
                    id: "m_\(UUID().uuidString.prefix(8))",
                    text: text,
                    isFromMe: isFromMe,
                    timeAgo: "now"
                )
                users[uIndex].conversations[cIndex].messages.append(msg)
                users[uIndex].conversations[cIndex].lastMessage = text
                users[uIndex].conversations[cIndex].isUnread = !isFromMe
                rs_saveUsers(users)
                return
            }
        }
    }
    
    // MARK: - Private
    
    /// 将Bundle内的JSON拷贝到Documents，实现可读写
    private func rs_prepareWritableJSONIfNeeded() {
        let exists = FileManager.default.fileExists(atPath: rs_writableFileURL.path)
        print("[rs_LocalJSONStore] Writable exists:", exists)
        guard !exists else { return }
        
        if let bundleURL = Bundle.main.url(forResource: "rs_mock_users", withExtension: "json") {
            print("[rs_LocalJSONStore] Bundle file:", bundleURL.path)
            do {
                try FileManager.default.copyItem(at: bundleURL, to: rs_writableFileURL)
                print("[rs_LocalJSONStore] Copy success ->", rs_writableFileURL.path)
            } catch {
                print("[rs_LocalJSONStore] Copy error:", error.localizedDescription)
                // ignore
            }
        } else {
            print("[rs_LocalJSONStore] Bundle file not found: rs_mock_users.json")
        }
    }

    /// 重置数据（退出登录时调用）
    func rs_resetData() {
        // 删除可写文件，下次启动会重新从 Bundle 拷贝
        if FileManager.default.fileExists(atPath: rs_writableFileURL.path) {
            try? FileManager.default.removeItem(at: rs_writableFileURL)
        }
    }
}
