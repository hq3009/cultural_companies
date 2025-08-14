import pandas as pd
import os

def read_excel_fields():
    """读取Excel文件中的字段名和中文说明"""

    # 文件路径
    excel_file = "../resources/cc20250715_宁波市金融主题库标准表_指标表.xlsx"

    try:
        # 读取Excel文件的所有sheet
        excel_data = pd.read_excel(excel_file, sheet_name=None)

        print("Excel文件包含的sheet:")
        for sheet_name in excel_data.keys():
            print(f"- {sheet_name}")

        print("\n" + "="*50)

        # 遍历每个sheet
        for sheet_name, df in excel_data.items():
            print(f"\nSheet: {sheet_name}")
            print(f"数据形状: {df.shape}")
            print(f"列名: {list(df.columns)}")

            # 显示前几行数据
            print("\n前5行数据:")
            print(df.head())
            print("\n" + "-"*30)

    except Exception as e:
        print(f"读取文件时出错: {e}")
        print(f"文件路径: {os.path.abspath(excel_file)}")
        print(f"文件是否存在: {os.path.exists(excel_file)}")

if __name__ == "__main__":
    read_excel_fields()