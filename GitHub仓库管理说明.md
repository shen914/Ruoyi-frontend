# GitHub仓库管理功能说明

## 功能概述

本系统提供了完整的GitHub仓库管理功能，支持仓库信息的持久化存储、同步更新、增删改查等操作。

## 主要特性

### 1. 数据持久化
- ✅ 仓库信息保存到本地数据库
- ✅ 支持离线查看历史仓库信息
- ✅ 数据与系统用户关联，支持权限控制

### 2. 同步功能
- ✅ 一键同步GitHub用户的所有公开仓库
- ✅ 自动更新已存在仓库的最新信息
- ✅ 新增仓库自动添加到本地数据库

### 3. 完整的管理功能
- ✅ 仓库信息的增删改查
- ✅ 支持按名称、用户名、状态等条件搜索
- ✅ 分页显示，支持大量数据
- ✅ 批量删除操作

### 4. 权限控制
- ✅ 基于角色的访问控制
- ✅ 细粒度的操作权限（查询、新增、修改、删除、同步）
- ✅ 与系统权限体系完全集成

## 数据库设计

### 表结构：sys_github_repos

| 字段名 | 类型 | 说明 |
|--------|------|------|
| repo_id | bigint | 仓库ID（主键） |
| repo_name | varchar(100) | 仓库名称 |
| username | varchar(50) | GitHub用户名 |
| html_url | varchar(500) | 仓库地址 |
| description | text | 仓库描述 |
| language | varchar(50) | 编程语言 |
| stargazers_count | int | 星标数 |
| forks_count | int | 分支数 |
| open_issues_count | int | 开放问题数 |
| watchers_count | int | 关注者数 |
| size | bigint | 仓库大小(KB) |
| default_branch | varchar(50) | 默认分支 |
| created_at | datetime | GitHub创建时间 |
| updated_at | datetime | GitHub更新时间 |
| pushed_at | datetime | 最后推送时间 |
| status | char(1) | 状态（0正常 1停用） |
| create_by | varchar(64) | 创建者 |
| create_time | datetime | 创建时间 |
| update_by | varchar(64) | 更新者 |
| update_time | datetime | 更新时间 |
| remark | varchar(500) | 备注 |

## 使用方法

### 1. 初始化数据库
执行 `github_repos_table.sql` 脚本创建数据库表和初始数据。

### 2. 配置菜单权限
在系统管理 → 菜单管理中，确保GitHub仓库菜单已正确配置。

### 3. 分配用户权限
为用户角色分配相应的GitHub仓库操作权限。

### 4. 使用功能

#### 查看仓库列表
- 进入GitHub仓库管理页面
- 使用搜索功能按条件筛选仓库
- 支持分页浏览

#### 同步GitHub仓库
1. 点击"同步GitHub"按钮
2. 输入GitHub用户名
3. 点击"开始同步"
4. 系统自动获取并更新仓库信息

#### 手动管理仓库
- **新增**：点击"新增"按钮，填写仓库信息
- **修改**：点击仓库行的"修改"按钮
- **删除**：选择仓库后点击"删除"按钮

## API接口

### 基础CRUD接口
- `GET /system/github/list` - 获取仓库列表
- `GET /system/github/{id}` - 获取仓库详情
- `POST /system/github` - 新增仓库
- `PUT /system/github` - 修改仓库
- `DELETE /system/github/{id}` - 删除仓库

### 特殊功能接口
- `GET /system/github/repos` - 获取GitHub实时仓库信息
- `POST /system/github/sync` - 同步GitHub仓库到本地
- `GET /system/github/stats` - 获取仓库统计信息

## 权限配置

### 菜单权限
- `system:github:list` - 仓库查询
- `system:github:add` - 仓库新增
- `system:github:edit` - 仓库修改
- `system:github:remove` - 仓库删除
- `system:github:sync` - 仓库同步

### 角色配置示例
```sql
-- 为管理员角色分配所有权限
INSERT INTO sys_role_menu (role_id, menu_id) 
SELECT 1, menu_id FROM sys_menu WHERE perms LIKE 'system:github:%';

-- 为普通用户角色分配查询权限
INSERT INTO sys_role_menu (role_id, menu_id) 
SELECT 2, menu_id FROM sys_menu WHERE perms = 'system:github:list';
```

## 注意事项

1. **API限制**：GitHub API有访问频率限制，建议合理使用同步功能
2. **数据一致性**：同步操作会覆盖本地数据，请谨慎操作
3. **权限管理**：确保用户有相应的操作权限
4. **数据备份**：定期备份仓库数据，避免数据丢失

## 扩展功能

### 可选的增强特性
- 仓库标签管理
- 仓库变更历史记录
- 自动定时同步
- 仓库统计分析
- 多GitHub账户支持
- Webhook集成

## 技术支持

如有问题或建议，请联系系统管理员或开发团队。

