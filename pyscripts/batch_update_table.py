#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
批量修改数据库表内容
"""

import mysql.connector
from typing import Dict, Any

class TableBatchUpdater:
    def __init__(self, user='hq', password='ll1119', database='cultural_companies_db'):
        self.connection = mysql.connector.connect(
            user=user,
            password=password,
            database=database,
            charset='utf8mb4'
        )
        self.cursor = self.connection.cursor()

    def batch_update(self, table_name: str, updates: Dict[str, Any],
                    where_condition: str = None):
        """批量更新"""
        set_clause = ", ".join([f"{k} = %s" for k in updates.keys()])
        values = list(updates.values())

        sql = f"UPDATE {table_name} SET {set_clause}"
        if where_condition:
            sql += f" WHERE {where_condition}"

        try:
            self.cursor.execute(sql, values)
            self.connection.commit()
            print(f"✅ 更新成功，影响行数: {self.cursor.rowcount}")
            return self.cursor.rowcount
        except Exception as e:
            self.connection.rollback()
            print(f"❌ 更新失败: {e}")
            return 0

    def backup_table(self, table_name: str):
        """备份表"""
        import datetime
        backup_suffix = datetime.datetime.now().strftime('%Y%m%d_%H%M%S')
        backup_table = f"{table_name}_backup_{backup_suffix}"

        try:
            self.cursor.execute(f"CREATE TABLE {backup_table} AS SELECT * FROM {table_name}")
            self.connection.commit()
            print(f"✅ 备份成功: {backup_table}")
            return backup_table
        except Exception as e:
            print(f"❌ 备份失败: {e}")
            return None

def main():
    updater = TableBatchUpdater()

    # 示例：批量更新企业类型
    print("批量更新企业类型...")
    updates = {'COMP_TYPE': '有限责任公司(自然人投资或控股)'}
    updater.batch_update('dw_zj_scjdgl_scztxx', updates,
                        where_condition="COMP_TYPE = '个人独资企业'")

if __name__ == "__main__":
    main()