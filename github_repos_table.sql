-- GitHub仓库管理表
CREATE TABLE `sys_github_repos` (
  `repo_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '仓库ID',
  `repo_name` varchar(100) NOT NULL COMMENT '仓库名称',
  `username` varchar(50) NOT NULL COMMENT 'GitHub用户名',
  `html_url` varchar(500) NOT NULL COMMENT '仓库地址',
  `description` text COMMENT '仓库描述',
  `language` varchar(50) DEFAULT NULL COMMENT '编程语言',
  `stargazers_count` int(11) DEFAULT 0 COMMENT '星标数',
  `forks_count` int(11) DEFAULT 0 COMMENT '分支数',
  `open_issues_count` int(11) DEFAULT 0 COMMENT '开放问题数',
  `watchers_count` int(11) DEFAULT 0 COMMENT '关注者数',
  `size` bigint(20) DEFAULT 0 COMMENT '仓库大小(KB)',
  `default_branch` varchar(50) DEFAULT 'main' COMMENT '默认分支',
  `created_at` datetime DEFAULT NULL COMMENT 'GitHub创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT 'GitHub更新时间',
  `pushed_at` datetime DEFAULT NULL COMMENT '最后推送时间',
  `status` char(1) DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`repo_id`),
  UNIQUE KEY `uk_repo_username` (`repo_name`, `username`),
  KEY `idx_username` (`username`),
  KEY `idx_language` (`language`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='GitHub仓库管理表';

-- 插入示例数据
INSERT INTO `sys_github_repos` (
  `repo_name`, `username`, `html_url`, `description`, `language`, 
  `stargazers_count`, `forks_count`, `status`, `create_by`, `create_time`
) VALUES 
('RuoYi-Vue3', 'yangzongzhuan', 'https://github.com/yangzongzhuan/RuoYi-Vue3', '基于SpringBoot+Vue3的快速开发平台', 'Vue', 1000, 500, '0', 'admin', NOW()),
('spring-boot-demo', 'zhangyd', 'https://github.com/zhangyd/spring-boot-demo', 'Spring Boot 学习教程', 'Java', 500, 200, '0', 'admin', NOW());

-- 菜单权限数据
INSERT INTO `sys_menu` (
  `menu_name`, `parent_id`, `order_num`, `path`, `component`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`
) VALUES 
('GitHub仓库', 1, 10, 'github', 'system/github/index', 1, 0, 'C', '0', '0', 'system:github:list', 'github', 'admin', NOW());

-- 获取刚插入的菜单ID
SET @menu_id = LAST_INSERT_ID();

-- 插入子菜单权限
INSERT INTO `sys_menu` (
  `menu_name`, `parent_id`, `order_num`, `path`, `component`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`
) VALUES 
('仓库查询', @menu_id, 1, '#', '', 1, 0, 'F', '0', '0', 'system:github:query', '#', 'admin', NOW()),
('仓库新增', @menu_id, 2, '#', '', 1, 0, 'F', '0', '0', 'system:github:add', '#', 'admin', NOW()),
('仓库修改', @menu_id, 3, '#', '', 1, 0, 'F', '0', '0', 'system:github:edit', '#', 'admin', NOW()),
('仓库删除', @menu_id, 4, '#', '', 1, 0, 'F', '0', '0', 'system:github:remove', '#', 'admin', NOW()),
('仓库同步', @menu_id, 5, '#', '', 1, 0, 'F', '0', '0', 'system:github:sync', '#', 'admin', NOW());

