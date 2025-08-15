# SQL 字段注释模板和最佳实践

## 1. 标准 COMMENT 语法（推荐）

### 为表添加注释
```sql
COMMENT ON TABLE table_name IS '表的用途和功能描述';
```

### 为字段添加注释
```sql
COMMENT ON COLUMN table_name.column_name IS '字段的详细说明，包括数据类型、取值范围、业务含义等';
```

## 2. 在 CREATE TABLE 中直接添加注释

### MySQL 语法
```sql
CREATE TABLE table_name (
    id INT PRIMARY KEY COMMENT '主键ID，自增',
    name VARCHAR(100) NOT NULL COMMENT '用户姓名，不能为空',
    email VARCHAR(255) COMMENT '用户邮箱地址',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间，自动设置为当前时间'
) COMMENT '用户信息表，存储系统用户的基本信息';
```

### PostgreSQL 语法
```sql
CREATE TABLE table_name (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE table_name IS '用户信息表，存储系统用户的基本信息';
COMMENT ON COLUMN table_name.id IS '主键ID，自增';
COMMENT ON COLUMN table_name.name IS '用户姓名，不能为空';
COMMENT ON COLUMN table_name.email IS '用户邮箱地址';
COMMENT ON COLUMN table_name.created_at IS '创建时间，自动设置为当前时间';
```

## 3. 注释内容的最佳实践

### 字段注释应包含的信息
1. **字段用途**：该字段存储什么信息
2. **数据类型说明**：如果是代码或标识符，说明其含义
3. **取值范围**：可能的值及其含义
4. **业务规则**：相关的业务逻辑和约束
5. **示例值**：典型的数据示例

### 好的注释示例
```sql
-- 好的注释
COMMENT ON COLUMN users.status IS '用户状态：1-正常，2-冻结，3-删除，默认为1';

-- 更好的注释
COMMENT ON COLUMN users.status IS '用户状态标识：1-正常（可正常使用系统），2-冻结（暂时无法使用），3-删除（已删除用户），默认为1，影响用户登录和权限';

-- 包含业务规则的注释
COMMENT ON COLUMN orders.total_amount IS '订单总金额，单位：分，必须大于0，包含商品价格、运费、税费等所有费用';
```

### 避免的注释
```sql
-- 避免这样的注释
COMMENT ON COLUMN users.name IS '姓名';

-- 避免过于技术性的注释
COMMENT ON COLUMN users.created_at IS 'TIMESTAMP类型，默认值CURRENT_TIMESTAMP';
```

## 4. 常见字段类型的注释模板

### 标识符字段
```sql
COMMENT ON COLUMN table_name.id IS '主键ID，自增，唯一标识每条记录';
COMMENT ON COLUMN table_name.code IS '业务编码，格式：YYYYMMDD-XXX，用于业务查询和引用';
COMMENT ON COLUMN table_name.uuid IS '全局唯一标识符，用于跨系统数据同步';
```

### 状态字段
```sql
COMMENT ON COLUMN table_name.status IS '状态标识：0-禁用，1-启用，2-待审核，3-已删除';
COMMENT ON COLUMN table_name.is_active IS '是否激活：1-是，0-否，影响数据可见性和业务逻辑';
```

### 时间字段
```sql
COMMENT ON COLUMN table_name.created_at IS '创建时间，记录首次插入数据的时间';
COMMENT ON COLUMN table_name.updated_at IS '更新时间，记录最后一次修改数据的时间';
COMMENT ON COLUMN table_name.deleted_at IS '删除时间，软删除时记录删除时间，硬删除时为NULL';
```

### 金额字段
```sql
COMMENT ON COLUMN table_name.amount IS '金额，单位：分，精确到分，避免浮点数精度问题';
COMMENT ON COLUMN table_name.price IS '价格，单位：元，保留2位小数，用于显示和计算';
```

### 关联字段
```sql
COMMENT ON COLUMN table_name.user_id IS '用户ID，关联users表的主键，外键约束';
COMMENT ON COLUMN table_name.category_id IS '分类ID，关联categories表，可为NULL表示未分类';
```

## 5. 批量添加注释的脚本示例

### 为现有表添加注释
```sql
-- 批量添加字段注释
DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN (
        SELECT column_name, data_type, is_nullable
        FROM information_schema.columns
        WHERE table_name = 'your_table_name'
        AND table_schema = 'public'
    ) LOOP
        EXECUTE format('COMMENT ON COLUMN your_table_name.%I IS %L',
                      r.column_name,
                      '字段说明：' || r.column_name || '，类型：' || r.data_type || '，是否可空：' || r.is_nullable);
    END LOOP;
END $$;
```

## 6. 注释维护建议

1. **版本控制**：将注释作为代码的一部分，纳入版本控制
2. **定期审查**：定期检查和更新注释，确保与业务逻辑一致
3. **团队规范**：制定团队注释规范，保持注释风格一致
4. **文档同步**：注释应与数据字典、API文档等保持同步
5. **多语言支持**：如果系统支持多语言，考虑添加多语言注释

## 7. 工具推荐

- **数据库管理工具**：Navicat、DBeaver、pgAdmin等
- **代码生成工具**：MyBatis Generator、JPA等
- **文档生成工具**：SchemaSpy、DBDoc等
- **版本控制**：Git、SVN等
