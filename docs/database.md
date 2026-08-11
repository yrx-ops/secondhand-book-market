# 数据库设计文档

## 概述

本文档描述二手图书交易平台 MVP 阶段的核心数据库设计。

技术栈：MySQL 8

---

## 核心表

### 1. 用户表 (users)

**用途**：存储平台用户基本信息。

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| id | BIGINT | PK, AUTO_INCREMENT | 主键 |
| username | VARCHAR(50) | NOT NULL, UNIQUE | 用户名，用于登录 |
| password_hash | VARCHAR(255) | NOT NULL | BCrypt 加密后的密码 |
| nickname | VARCHAR(100) | NOT NULL | 昵称 |
| avatar_url | VARCHAR(500) | NULL | 头像 URL |
| status | TINYINT | NOT NULL, DEFAULT 1 | 状态：1=正常，0=禁用 |
| created_at | DATETIME | NOT NULL | 创建时间 |
| updated_at | DATETIME | NOT NULL | 更新时间 |

**索引**：
- `idx_username` ON (`username`) - 唯一索引，用于登录查询

**说明**：
- `status` 字段用于账户禁用功能，未来可扩展封号原因等
- 暂不包含邮箱、手机号，后续扩展

---

### 2. 图书表 (books)

**用途**：存储二手图书发布信息。

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| id | BIGINT | PK, AUTO_INCREMENT | 主键 |
| seller_id | BIGINT | NOT NULL, FK | 卖家用户 ID |
| title | VARCHAR(200) | NOT NULL | 图书标题 |
| author | VARCHAR(100) | NOT NULL | 作者 |
| isbn | VARCHAR(20) | NULL | ISBN 国际标准书号 |
| description | TEXT | NULL | 图书描述详情 |
| cover_url | VARCHAR(500) | NULL | 封面图片 URL |
| original_price | DECIMAL(10,2) | NOT NULL | 图书原价 |
| sale_price | DECIMAL(10,2) | NOT NULL | 出售价格 |
| condition_level | TINYINT | NOT NULL | 成色等级：1-5（1=较差，5=几乎全新） |
| status | VARCHAR(20) | NOT NULL, DEFAULT 'AVAILABLE' | 状态：AVAILABLE/SOLD/OFF_SHELF |
| created_at | DATETIME | NOT NULL | 创建时间 |
| updated_at | DATETIME | NOT NULL | 更新时间 |

**索引**：
- `idx_seller_id` ON (`seller_id`) - 查询某用户发布的图书
- `idx_status` ON (`status`) - 筛选可用图书
- `idx_status_seller` ON (`status`, `seller_id`) - 查询某用户的在售图书

**图书状态说明**：
- `AVAILABLE`：可购买，在售
- `SOLD`：已售出
- `OFF_SHELF`：已下架（非售出状态，用户主动下架）

**说明**：
- 每本图书默认只有一件库存（库存设计在后续扩展）
- `original_price` 用于展示原价，辅助买家判断性价比
- `condition_level` 采用整数而非枚举，便于后续扩展等级描述

---

### 3. 订单表 (orders)

**用途**：记录图书交易订单。

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| id | BIGINT | PK, AUTO_INCREMENT | 主键 |
| order_no | VARCHAR(32) | NOT NULL, UNIQUE | 订单号，唯一标识 |
| book_id | BIGINT | NOT NULL, FK | 关联图书 ID |
| buyer_id | BIGINT | NOT NULL, FK | 买家用户 ID |
| seller_id | BIGINT | NOT NULL, FK | 卖家用户 ID |
| snapshot_title | VARCHAR(200) | NOT NULL | 图书标题快照 |
| snapshot_cover | VARCHAR(500) | NULL | 封面 URL 快照 |
| snapshot_price | DECIMAL(10,2) | NOT NULL | 成交价格快照 |
| status | VARCHAR(20) | NOT NULL, DEFAULT 'PENDING' | 状态：PENDING/COMPLETED/CANCELLED |
| created_at | DATETIME | NOT NULL | 创建时间 |
| updated_at | DATETIME | NOT NULL | 更新时间 |

**索引**：
- `idx_order_no` ON (`order_no`) - 唯一索引，用于订单查询
- `idx_book_id` ON (`book_id`) - 查询某图书的订单
- `idx_buyer_id` ON (`buyer_id`) - 查询买家订单
- `idx_seller_id` ON (`seller_id`) - 查询卖家订单

**订单状态说明**：
- `PENDING`：待处理/待确认
- `COMPLETED`：已完成
- `CANCELLED`：已取消

**说明**：
- `snapshot_*` 字段保存下单时刻的图书信息快照，防止图书信息变更影响历史订单
- 订单金额从数据库图书表读取，不信任前端传入的价格

---

## 表关系

```
┌─────────────┐       ┌─────────────┐       ┌─────────────┐
│    users    │       │    books    │       │   orders    │
├─────────────┤       ├─────────────┤       ├─────────────┤
│ id (PK)     │───┐   │ id (PK)     │───┐   │ id (PK)     │
│             │   │   │ seller_id   │   │   │ book_id     │
│             │   └──►│             │   └──►│ buyer_id    │
│             │       │             │       │ seller_id   │
└─────────────┘       └─────────────┘       └─────────────┘
     1                   N                       N
```

- 1 个用户可以发布多本图书 (users.id → books.seller_id)
- 1 本图书可以产生多个订单，但业务规则要求只允许 1 个有效订单 (books.id → orders.book_id)
- 1 个用户可以是多本图书的卖家 (users.id → orders.seller_id)
- 1 个用户可以购买多本图书 (users.id → orders.buyer_id)

---

## 外键约束

| 关系 | 外键字段 | 引用表 | 被引用字段 | ON DELETE |
|------|----------|--------|------------|-----------|
| 图书 → 用户 | `seller_id` | `users` | `id` | RESTRICT |
| 订单 → 图书 | `book_id` | `books` | `id` | RESTRICT |
| 订单 → 买家 | `buyer_id` | `users` | `id` | RESTRICT |
| 订单 → 卖家 | `seller_id` | `users` | `id` | RESTRICT |

---

## 业务规则（应用层实现，不依赖数据库约束）

### 用户相关
1. 用户不能修改其他用户的数据
2. 密码使用 BCrypt 加密存储

### 图书相关
1. 每本图书默认只有一件库存
2. 用户不能编辑或删除别人发布的图书
3. 只有 `AVAILABLE` 状态的图书可以购买
4. 同一本图书不能同时产生两个有效订单
5. 已售出（`SOLD`）的图书不能再次购买

### 订单相关
1. 用户不能购买自己发布的图书
2. 下单时必须在服务端重新检查图书状态
3. 订单金额必须从数据库读取，不信任前端传入的价格
4. 订单必须保存下单时的图书信息快照
5. 已完成（`COMPLETED`）的订单不能随意修改状态

---

## 未来扩展方向

以下功能未在 MVP 阶段实现，但数据库设计时预留了扩展空间：

1. **收藏功能**：可新增 `favorites` 表，包含 `user_id`、`book_id`、`created_at`

2. **消息/聊天功能**：可新增 `conversations`、`messages` 表

3. **评价功能**：可新增 `reviews` 表，包含 `order_id`、`rater_id`、`ratee_id`、`rating`、`comment`

4. **图书分类**：可新增 `categories`、`book_categories` 表，或在 `books` 表增加 `category_id` 字段

5. **管理员**：可在 `users` 表增加 `role` 字段区分普通用户和管理员

6. **库存管理**：可将 `books` 表的 `stock` 字段从隐式 1 改为显式整数字段

7. **收货地址**：可新增 `addresses` 表关联用户

8. **物流信息**：可在 `orders` 表增加 `shipping_address`、`tracking_number` 等字段
