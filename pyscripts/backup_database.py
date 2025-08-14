#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
数据库备份脚本
定期备份文旅企业数据库
"""

import os
import datetime
import subprocess
import zipfile

class DatabaseBackup:
    def __init__(self, user='hq', password='ll1119', database='cul_comp'):
        self.user = user
        self.password = password
        self.database = database
        self.backup_dir = 'backups'

    def create_backup_dir(self):
        """创建备份目录"""
        if not os.path.exists(self.backup_dir):
            os.makedirs(self.backup_dir)

    def backup_database(self):
        """备份整个数据库"""
        timestamp = datetime.datetime.now().strftime('%Y%m%d_%H%M%S')
        backup_file = f"{self.backup_dir}/cul_comp_{timestamp}.sql"

        cmd = f'mysqldump -u {self.user} -p{self.password} {self.database} > {backup_file}'

        try:
            subprocess.run(cmd, shell=True, check=True)
            print(f"✅ 数据库备份成功: {backup_file}")
            return backup_file
        except subprocess.CalledProcessError as e:
            print(f"❌ 数据库备份失败: {e}")
            return None

    def backup_main_table(self):
        """备份主表数据"""
        timestamp = datetime.datetime.now().strftime('%Y%m%d_%H%M%S')
        backup_file = f"{self.backup_dir}/main_table_{timestamp}.sql"

        cmd = f'mysqldump -u {self.user} -p{self.password} {self.database} dw_zj_scjdgl_scztxx > {backup_file}'

        try:
            subprocess.run(cmd, shell=True, check=True)
            print(f"✅ 主表备份成功: {backup_file}")
            return backup_file
        except subprocess.CalledProcessError as e:
            print(f"❌ 主表备份失败: {e}")
            return None

    def compress_backup(self, backup_file):
        """压缩备份文件"""
        if not backup_file or not os.path.exists(backup_file):
            return None

        zip_file = backup_file.replace('.sql', '.zip')

        with zipfile.ZipFile(zip_file, 'w', zipfile.ZIP_DEFLATED) as zipf:
            zipf.write(backup_file, os.path.basename(backup_file))

        # 删除原SQL文件
        os.remove(backup_file)
        print(f"✅ 备份文件已压缩: {zip_file}")
        return zip_file

    def cleanup_old_backups(self, keep_days=30):
        """清理旧备份文件"""
        cutoff_date = datetime.datetime.now() - datetime.timedelta(days=keep_days)

        for filename in os.listdir(self.backup_dir):
            file_path = os.path.join(self.backup_dir, filename)
            if os.path.isfile(file_path):
                file_time = datetime.datetime.fromtimestamp(os.path.getctime(file_path))
                if file_time < cutoff_date:
                    os.remove(file_path)
                    print(f"🗑️ 删除旧备份: {filename}")

    def restore_database(self, backup_file):
        """恢复数据库"""
        if not os.path.exists(backup_file):
            print(f"❌ 备份文件不存在: {backup_file}")
            return False

        cmd = f'mysql -u {self.user} -p{self.password} {self.database} < {backup_file}'

        try:
            subprocess.run(cmd, shell=True, check=True)
            print(f"✅ 数据库恢复成功: {backup_file}")
            return True
        except subprocess.CalledProcessError as e:
            print(f"❌ 数据库恢复失败: {e}")
            return False

def main():
    """主函数"""
    print("开始数据库备份...")

    backup = DatabaseBackup()
    backup.create_backup_dir()

    # 备份整个数据库
    backup_file = backup.backup_database()
    if backup_file:
        backup.compress_backup(backup_file)

    # 备份主表
    main_table_backup = backup.backup_main_table()
    if main_table_backup:
        backup.compress_backup(main_table_backup)

    # 清理旧备份
    backup.cleanup_old_backups()

    print("备份完成！")

if __name__ == "__main__":
    main()