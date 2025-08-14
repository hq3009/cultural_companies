import pandas as pd
import os

def extract_field_mapping():
    """提取dw_zj_scjdgl_scztxx表的字段映射信息"""

    # 文件路径
    excel_file = "../raw_data/cc20250715_宁波市金融主题库标准表_指标表.xlsx"

    try:
        # 读取Excel文件的所有sheet
        excel_data = pd.read_excel(excel_file, sheet_name=None)

        print("查找dw_zj_scjdgl_scztxx相关表的字段信息...")

        # 查找包含"市场主体信息"或"qyztxx"的sheet
        target_sheets = []
        for sheet_name, df in excel_data.items():
            if df.astype(str).apply(lambda x: x.str.contains('市场主体信息|qyztxx|scztxx', case=False, na=False)).any().any():
                target_sheets.append(sheet_name)
                print(f"找到相关表在Sheet: {sheet_name}")

        print(f"\n相关Sheet: {target_sheets}")

        # 遍历目标sheet
        for sheet_name in target_sheets:
            df = excel_data[sheet_name]
            print(f"\n{'='*50}")
            print(f"Sheet: {sheet_name}")
            print(f"数据形状: {df.shape}")
            print(f"列名: {list(df.columns)}")

            # 查找表名行
            table_name_row = None
            for idx, row in df.iterrows():
                if row.astype(str).str.contains('市场主体信息|qyztxx|scztxx', case=False, na=False).any():
                    table_name_row = idx
                    print(f"\n表名行索引: {idx}")
                    print(f"表名行内容: {row.values}")
                    break

            if table_name_row is not None:
                # 显示表名行及后续几行
                start_row = max(0, table_name_row - 1)
                end_row = min(len(df), table_name_row + 10)
                print(f"\n表名行及后续内容 (行 {start_row}-{end_row}):")
                print(df.iloc[start_row:end_row])

            # 查找字段名行（通常包含"中文字段名"、"标准化字段名"等）
            field_header_row = None
            for idx, row in df.iterrows():
                if row.astype(str).str.contains('中文字段名|标准化字段名|字段名', case=False, na=False).any():
                    field_header_row = idx
                    print(f"\n字段名行索引: {idx}")
                    print(f"字段名行内容: {row.values}")
                    break

            if field_header_row is not None:
                # 显示字段名行及后续几行
                start_row = field_header_row
                end_row = min(len(df), field_header_row + 20)
                print(f"\n字段信息 (行 {start_row}-{end_row}):")
                print(df.iloc[start_row:end_row])

    except Exception as e:
        print(f"读取文件时出错: {e}")

if __name__ == "__main__":
    extract_field_mapping()