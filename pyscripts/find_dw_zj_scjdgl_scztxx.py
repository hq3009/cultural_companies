import pandas as pd
import os

def find_dw_zj_scjdgl_scztxx():
    """查找dw_zj_scjdgl_scztxx表的字段信息"""

    # 文件路径
    excel_file = "../raw_data/cc20250715_宁波市金融主题库标准表_指标表.xlsx"

    try:
        # 读取Excel文件的所有sheet
        excel_data = pd.read_excel(excel_file, sheet_name=None)

        print("查找dw_zj_scjdgl_scztxx表...")

        # 遍历每个sheet查找目标表
        for sheet_name, df in excel_data.items():
            # 检查是否包含目标表名
            if df.astype(str).apply(lambda x: x.str.contains('dw_zj_scjdgl_scztxx', case=False, na=False)).any().any():
                print(f"\n找到目标表在Sheet: {sheet_name}")
                print(f"数据形状: {df.shape}")
                print(f"列名: {list(df.columns)}")

                # 显示包含目标表名的行
                mask = df.astype(str).apply(lambda x: x.str.contains('dw_zj_scjdgl_scztxx', case=False, na=False))
                target_rows = df[mask.any(axis=1)]
                print(f"\n包含目标表名的行:")
                print(target_rows)

                # 显示整个sheet的内容
                print(f"\n整个Sheet内容:")
                print(df)
                break
        else:
            print("未找到dw_zj_scjdgl_scztxx表")

            # 显示所有包含"scztxx"的表
            print("\n查找包含'scztxx'的表:")
            for sheet_name, df in excel_data.items():
                if df.astype(str).apply(lambda x: x.str.contains('scztxx', case=False, na=False)).any().any():
                    print(f"Sheet {sheet_name} 包含 'scztxx'")
                    mask = df.astype(str).apply(lambda x: x.str.contains('scztxx', case=False, na=False))
                    target_rows = df[mask.any(axis=1)]
                    print(target_rows)

    except Exception as e:
        print(f"读取文件时出错: {e}")

if __name__ == "__main__":
    find_dw_zj_scjdgl_scztxx()