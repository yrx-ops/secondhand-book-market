-- =============================================
-- 二手图书交易平台 MVP 数据库建表脚本
-- 数据库：MySQL 8.0
-- =============================================

-- 创建数据库（如果不存在）
CREATE DATABASE IF NOT EXISTS secondhand_book_market
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

USE secondhand_book_market;

-- =============================================
-- 1. 用户表
-- =============================================
DROP TABLE IF EXISTS users;

CREATE TABLE users (
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

-- =============================================
-- 2. 图书表
-- =============================================
DROP TABLE IF EXISTS books;

CREATE TABLE books (
    id BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
    seller_id BIGINT NOT NULL COMMENT '卖家用户 ID',
    title VARCHAR(200) NOT NULL COMMENT '图书标题',
    author VARCHAR(100) NOT NULL COMMENT '作者',
    isbn VARCHAR(20) NULL COMMENT 'ISBN 国际标准书号',
    description TEXT NULL COMMENT '图书描述详情',
    cover_url VARCHAR(500) NULL COMMENT '封面图片 URL',
    original_price DECIMAL(10,2) NOT NULL COMMENT '图书原价',
    sale_price DECIMAL(10,2) NOT NULL COMMENT '出售价格',
    condition_level TINYINT NOT NULL COMMENT '成色等级：1-5（1=较差，5=几乎全新）',
    status VARCHAR(20) NOT NULL DEFAULT 'AVAILABLE' COMMENT '状态：AVAILABLE=在售，SOLD=已售出，OFF_SHELF=已下架',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (id),
    KEY idx_seller_id (seller_id),
    KEY idx_status (status),
    KEY idx_status_seller (status, seller_id),
    CONSTRAINT fk_books_seller FOREIGN KEY (seller_id) REFERENCES users(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='图书表';

-- =============================================
-- 3. 订单表
-- =============================================
DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    id BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
    order_no VARCHAR(32) NOT NULL COMMENT '订单号，唯一标识',
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
    KEY idx_seller_id (seller_id),
    CONSTRAINT fk_orders_book FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE RESTRICT,
    CONSTRAINT fk_orders_buyer FOREIGN KEY (buyer_id) REFERENCES users(id) ON DELETE RESTRICT,
    CONSTRAINT fk_orders_seller FOREIGN KEY (seller_id) REFERENCES users(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='订单表';

-- =============================================
-- 注释说明
-- =============================================
-- 字符集：utf8mb4 支持完整 emoji 和特殊字符
-- 存储引擎：InnoDB 支持事务和外键
-- 时间戳：使用 DATETIME 类型，时区由应用层控制
-- 金额：DECIMAL(10,2) 精确存储，避免浮点误差
-- 外键：ON DELETE RESTRICT 防止误删关联数据
