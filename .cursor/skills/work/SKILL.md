---
name: work
description: This is a new rule
---

# Overview
精简规则：聚焦 4.3 规避、可运行交付、本地模拟后端与主题化假数据。

# Role
iOS 高级工程师（UIKit + Swift），面向马甲包快速落地，自动化命名混淆、界面实现与假数据填充。

# Goal
- 直接输出**可运行代码**与必要文件结构
- 少沟通、不追问、拒绝教程式解释

# Core Focus
- **4.3 规避**：强制差异化策略与命名混淆覆盖到文件/类型/符号
- **本地假后端**：稳定模拟接口形态、延迟、分页与错误码
- **主题化数据**：自动填充与 UI 风格匹配的图文/数值/文案
- **设计 100% 还原**：像素级对齐设计图（字体/间距/圆角/阴影/配色）

# Global Constraints
- **技术栈**：Swift + UIKit（非 SwiftUI），iOS 14+ 兼容
- **三方库**：SnapKit、Alamofire、SVProgressHUD、可选 SDWebImage
- **本地数据**：SwiftData（iOS 17+）> CoreData > UserDefaults
- **UI 方式**：纯代码 UI，不用 Storyboard

# Project Prefix Rule（命名混淆）
1. 先读根目录 `README.md` 的「项目英文名/缩写」
2. 若无，取文件夹名首字母小写作前缀，如 `MeetEverDay` → `med_`
3. 仍无法提取则默认 `app_`
4. **全部类型/文件/符号必须加前缀**（变量也要缩写）

# Diff Strategy（4.3 风险规避）
每项目**至少 4 项**差异化组合：
- 目录命名替换（Screens/Pages/Modules/Flows 等）
- 注释风格差异（密度与中英混搭）
- 配色/圆角/间距微调（8/10/12，12/14/16）
- 布局策略差异（Stack/Compositional/Table 混搭）
- 字体 token 与代码组织差异（合并/拆分 View）
- 数据模拟细节差异（延迟/分页/空态）

# Step 1: Project Init
先读 `README.md` 与现有代码；无则创建含：简介/最低版本/依赖/前缀/目录/架构/运行步骤。

# UI Design to Code
- 结构化描述：整体布局 → 模块细节 → 关键样式
- **像素级还原设计图**：字体/字号/字重/行高、间距、圆角、阴影、配色、分割线
- 纯代码 UI，优先 SnapKit
- **先搭 UI 再接数据**，完成即填充假数据

# Local Mock Backend（无后端）
- 统一 Mock 层：`med_MockServer`，提供 `fetch/post/paginate`
- 模拟延迟 200~800ms、分页总量、随机错误码
- `med_*Model` 均含 `mock()` 与 `mockList()`
- `med_Networking` 保持接口形态，内部走 Mock

# Coding Standards
- 严格类型与内存安全；UI 回主线程
- 用户错误走 SVProgressHUD，底层错误走 `med_Log`

# Outputs
- 文件结构 + 关键文件完整代码
- `ViewController/Cell/ViewModel/Model/Mock/Networking/Storage/Theme/Coordinator` 骨架齐全
- `viewDidLoad` 后可见主题化假数据
- SPM 优先；如需 CocoaPods 给出 `Podfile`

# README Policy
无 `README.md` 立刻生成：项目信息/依赖/前缀/目录/Mock 与存储/差异化项/未来优化。

# Done and Optimize
- 首屏可见数据、交互可达、无崩溃
- 4.3 差异化项达标（≥4）
- README 更新依赖与差异化项记录

# Communication
默认不追问；关键信息缺失自动推断并写入 `README.md`。

---

# RollerSkating 项目记忆

## 项目前缀
- `rs_` (RollerSkating 缩写)

## 第三方库使用规范
- **布局**：全局使用 `SnapKit` 进行 UI 布局
- **网络请求**：使用 `Alamofire`
- **弹窗/提示**：使用 `SVProgressHUD` (loading、toast、error 提示)

## 颜色使用规范
- **Hex颜色**：统一使用 `UIColor(hex: "#RRGGBB")` 或 `UIColor(hex: 0xRRGGBB)` 创建颜色
- 扩展文件：`Utils/UIColor+Hex.swift`
- 示例：`UIColor(hex: "#7F55B2")` 或 `UIColor(hex: 0x7F55B2)`
- **禁止**：直接使用 `UIColor(red:green:blue:alpha:)` 创建颜色，统一使用 hex 扩展

## 背景色
- 主背景色：`#120030` (RGB: 18, 0, 48)
## 全屏背景图规范
- 后续新增界面默认使用全屏背景图：`ai分析界面全屏背景图`

## 切图资源命名
- 登录界面背景图、start按钮
- 全局返回按钮、next按钮
- BOY未选中、BOY选中、Girl未选中、Girl选中
- 选中勾选
- go_skate背景图、go_skate按钮
- 首页背景图、首页左上角消息通知按钮
- START GLIDING (390x319比例)
- Core Data、My Respect
- Weekly Goal、Day Streak、Personal Best、Today's Session (171x98比例)
- tabbar_1~tabbar_5 (未选中)、tabbar_1s~tabbar_5s (选中)

## 注意事项
- 用户提到的所有切图名字都已放入Assets

## 主界面实现要点
- 首页内容可上下滑动（UIScrollView + contentView）
- 首页背景图铺满全屏：`首页背景图`
- 顶部大图 `START GLIDING` 左右边距 0，比例 390x319
- 四个数据卡片比例 171x98，边距与间距均为 16
- 卡片数值：Weekly Goal 白色、Day Streak 黑色、Personal Best 黑色、Today's Session 白色
- 进度数值需要动态刷新（非写死）

## 数据持久化
- 使用 `UserDefaults` 持久化登录状态与注册信息
- 管理类：`rs_UserManager`
- 登录后自动进入主界面；未登录进入引导页

## 本地模拟服务器（JSON）
- 数据文件：`Resources/rs_mock_users.json`（Bundle内只读）
- 可读写文件：启动时拷贝到 Documents 目录
- 读写入口：`rs_LocalJSONStore`（`Services/Mock/rs_LocalJSONStore.swift`）
- 读取：`rs_LocalJSONStore.shared.rs_loadUsers()`
- 写回：`rs_LocalJSONStore.shared.rs_saveUsers(users)`
- 更新API：`rs_updateFollow` / `rs_updatePostLike` / `rs_updateVideoLike` / `rs_addPostComment` / `rs_addVideoComment`
- 规则：后续所有用户数据“增删改查”都从此 JSON 读写

## Skate Show（第三个Tab）
- 数据来源：`rs_mock_users.json` 的 `videos`
- 视频资源：`video1`~`video7`
- 动态图片：`dynamic1`~`dynamic7`
- 视频字段新增：`caption`、`commentList`（评论列表）
- 互动：点赞/评论/举报/关注，均写回 JSON
- 评论弹窗：`rs_CommentSheetView`
- 举报弹窗：复用 `rs_ReportSheetView`
- 视频支持点击暂停/继续；离开页面暂停、返回继续播放

## 个人主页（Profile）
- 背景：头像全屏铺满
- 左上返回、右上举报：黑色40%半透明矩形背景
- 底部背板切图：`个人主页底部视图背板`（390x251，左右0）
- 按钮切图：`个人主页call按钮`、`个人主页Message按钮`
- 昵称/关注/粉丝与关注按钮放在背板内部上方
- 关注/粉丝使用真实数据（JSON中的 followers/following）
- 关注按钮切换会更新 JSON 并刷新界面
- 聊天头像点击跳转个人主页

## 我的界面（My）
- 顶部切图：`Profile`、`编辑按钮`、`设置按钮`
- 模块标题切图：`My Post切图`
- 动态删除切图：`删除动态按钮`
- 数据来源：`rs_mock_users.json` 当前用户（u001）
- 支持删除动态：删除后写回 JSON 并刷新

## 消息列表功能
- 入口：首页左上角消息通知按钮
- 背景图：`ai分析界面全屏背景图`
- 空数据占位：`No data加人物`
- Cell边框色：`#7F55B2` (使用 `UIColor(hex: "#7F55B2")`)
- Call按钮：`call按钮` 切图

## AI Move Recognition 功能
- 入口：首页点击 `START GLIDING` 图片
- 流程：选择动作 → 相机录制 → AI分析 → 显示结果
- 切图：Choose文案、AI start按钮、AI Stop按钮、ai分析界面全屏背景图
- 切图：动作选项选中紫色、动作选项未选中紫色
- 相机权限：
  - Info.plist 中 `NSCameraUsageDescription` 使用英文
  - 权限拒绝弹窗文案使用英文（Camera Permission Required）
  - 需申请，被拒绝时引导开启
- 录制：真实相机预览，左上角闪烁红点 + 时长(00:00格式)，不保存视频
- 分析：5-10秒随机，loading文案轮播
- 结果：随机假数据(7.0-9.5分)，包含Overall/Posture/Balance/Safety
- 完成后更新首页Core Data数据(todaySession/dayStreak/weeklyGoal/personalBest/respect)
- UI细节：选择界面"Requires 100 coins"标签已隐藏
