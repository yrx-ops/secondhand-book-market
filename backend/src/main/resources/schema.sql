-- =============================================
-- 二手图书交易平台 MVP 数据库建表脚本
-- 数据库：MySQL 8.0
-- =============================================

CREATE TABLE IF NOT EXISTS users (
    id BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
    username VARCHAR(50) NOT NULL COMMENT '用户名，用于登录',
    password_hash VARCHAR(255) NOT NULL COMMENT 'BCrypt 加密后的密码',
    nickname VARCHAR(100) NOT NULL COMMENT '昵称',
    avatar_url VARCHAR(500) NULL COMMENT '头像 URL',
    status TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1=正常，0=禁用',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (id),
    UNIQUE KEY uk_username (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

CREATE TABLE IF NOT EXISTS books (
    id BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
    seller_id BIGINT NOT NULL COMMENT '卖家用户 ID',
    title VARCHAR(200) NOT NULL COMMENT '图书标题',
    author VARCHAR(100) NOT NULL COMMENT '作者',
    isbn VARCHAR(20) NULL COMMENT 'ISBN 国际标准书号',
    description TEXT NULL COMMENT '图书描述详情',
    cover_url VARCHAR(500) NULL COMMENT '封面图片 URL',
    original_price DECIMAL(10,2) NOT NULL COMMENT '图书原价',
    sale_price DECIMAL(10,2) NOT NULL COMMENT '出售价格',
    condition_level TINYINT NOT NULL COMMENT '成色等级：1-5',
    status VARCHAR(20) NOT NULL DEFAULT 'AVAILABLE' COMMENT '状态：AVAILABLE=在售，SOLD=已售出，OFF_SHELF=已下架',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (id),
    KEY idx_seller_id (seller_id),
    KEY idx_status (status),
    KEY idx_status_seller (status, seller_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='图书表';

CREATE TABLE IF NOT EXISTS orders (
    id BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
    order_no VARCHAR(32) NOT NULL COMMENT '订单号',
    book_id BIGINT NOT NULL COMMENT '关联图书 ID',
    buyer_id BIGINT NOT NULL COMMENT '买家用户 ID',
    seller_id BIGINT NOT NULL COMMENT '卖家用户 ID',
    snapshot_title VARCHAR(200) NOT NULL COMMENT '图书标题快照',
    snapshot_cover VARCHAR(500) NULL COMMENT '封面 URL 快照',
    snapshot_price DECIMAL(10,2) NOT NULL COMMENT '成交价格快照',
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING' COMMENT '状态：PENDING=待处理，COMPLETED=已完成，CANCELLED=已取消',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (id),
    UNIQUE KEY uk_order_no (order_no),
    KEY idx_book_id (book_id),
    KEY idx_buyer_id (buyer_id),
    KEY idx_seller_id (seller_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='订单表';
