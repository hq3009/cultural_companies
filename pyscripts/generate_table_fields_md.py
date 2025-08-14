import pandas as pd
import os

def generate_table_fields_md():
    """根据Excel文件生成table_fields.md文档"""
    excel_file = "resources/cc20250715_宁波市金融主题库标准表_指标表.xlsx"

    try:
        # 读取Excel文件的所有sheet
        excel_data = pd.read_excel(excel_file, sheet_name=None)

        # 创建markdown内容
        md_content = []
        md_content.append("# 宁波市金融主题库标准表字段映射")
        md_content.append("")
        md_content.append("本文档根据 `cc20250715_宁波市金融主题库标准表_指标表.xlsx` 生成，用于清晰呈现各数据表的字段信息。")
        md_content.append("")

        # 收集所有表信息用于生成目录
        table_list = []

        # 遍历所有sheet
        for sheet_name, df in excel_data.items():
            # 查找表名行
            table_name = None
            table_info = {}

            for idx, row in df.iterrows():
                row_str = ' '.join(str(cell) for cell in row if pd.notna(cell))

                # 查找表名信息
                if '表名' in row_str or 'TABLE' in row_str.upper():
                    for col_idx, cell in enumerate(row):
                        if pd.notna(cell) and ('表名' in str(cell) or 'TABLE' in str(cell).upper()):
                            if col_idx + 1 < len(row) and pd.notna(row[col_idx + 1]):
                                table_name = str(row[col_idx + 1])
                                break

                # 查找其他表信息
                if '主键' in row_str:
                    for col_idx, cell in enumerate(row):
                        if pd.notna(cell) and '主键' in str(cell):
                            if col_idx + 1 < len(row) and pd.notna(row[col_idx + 1]):
                                table_info['主键'] = str(row[col_idx + 1])

                if '中文名称' in row_str:
                    for col_idx, cell in enumerate(row):
                        if pd.notna(cell) and '中文名称' in str(cell):
                            if col_idx + 1 < len(row) and pd.notna(row[col_idx + 1]):
                                table_info['中文名称'] = str(row[col_idx + 1])

            # 收集表信息用于目录
            if table_name:
                table_list.append({
                    'sheet_name': sheet_name,
                    'table_name': table_name,
                    'table_info': table_info
                })

        # 生成目录
        md_content.append("## 目录")
        md_content.append("")
        for i, table in enumerate(table_list, 1):
            table_name = table['table_name']
            sheet_name = table['sheet_name']
            table_info = table['table_info']

            # 生成目录项
            if '中文名称' in table_info:
                md_content.append(f"{i}. [{table_info['中文名称']} ({table_name})](#{i})")
            else:
                md_content.append(f"{i}. [{table_name}](#{i})")
        md_content.append("")
        md_content.append("---")
        md_content.append("")

        # 重新遍历生成详细内容
        for i, table in enumerate(table_list, 1):
            sheet_name = table['sheet_name']
            table_name = table['table_name']
            table_info = table['table_info']

            df = excel_data[sheet_name]

            # 添加锚点
            md_content.append(f"<a name=\"{i}\"></a>")
            md_content.append(f"## {i}. {sheet_name}")
            md_content.append("")

            # 添加表信息
            if table_name:
                md_content.append(f"**表名**: `{table_name}`")
                md_content.append("")

            if table_info:
                for key, value in table_info.items():
                    md_content.append(f"**{key}**: {value}")
                md_content.append("")

            # 查找字段信息
            field_headers = None
            field_data = []

            for idx, row in df.iterrows():
                row_str = ' '.join(str(cell) for cell in row if pd.notna(cell))

                # 查找字段表头
                if any(keyword in row_str for keyword in ['中文字段名', '标准化字段名', '字段名', '数据类型', '源表字段名']):
                    field_headers = [str(cell) for cell in row if pd.notna(cell)]
                    continue

                # 如果有字段表头，收集字段数据
                if field_headers and len(row) >= len(field_headers):
                    field_row = []
                    for i, header in enumerate(field_headers):
                        if i < len(row) and pd.notna(row[i]):
                            field_row.append(str(row[i]))
                        else:
                            field_row.append('')

                    # 检查是否是有意义的字段数据（至少前两列不为空）
                    if field_row[0] and field_row[1] and not field_row[0].startswith('Unnamed'):
                        field_data.append(field_row)

            # 生成字段表格
            if field_headers and field_data:
                md_content.append("### 字段信息")
                md_content.append("")

                # 创建表格头部
                table_header = "| " + " | ".join(field_headers) + " |"
                md_content.append(table_header)

                # 创建表格分隔线
                separator = "| " + " | ".join(["---"] * len(field_headers)) + " |"
                md_content.append(separator)

                # 添加字段数据
                for field_row in field_data:
                    # 确保字段行长度与表头一致
                    while len(field_row) < len(field_headers):
                        field_row.append('')

                    table_row = "| " + " | ".join(field_row[:len(field_headers)]) + " |"
                    md_content.append(table_row)

                md_content.append("")
            else:
                md_content.append("**注意**: 未找到字段信息或字段信息格式不标准")
                md_content.append("")

            md_content.append("---")
            md_content.append("")

        # 写入文件
        output_file = "table_fields.md"
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write('\n'.join(md_content))

        print(f"成功生成 {output_file}")
        print(f"共处理了 {len(table_list)} 个表")

    except Exception as e:
        print(f"处理Excel文件时出错: {e}")
        print(f"文件路径: {os.path.abspath(excel_file)}")
        print(f"文件是否存在: {os.path.exists(excel_file)}")

if __name__ == "__main__":
    generate_table_fields_md()