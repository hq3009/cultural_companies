# 数据准备

import re
import pandas as pd


def is_valid_code(code):
    """
    检查是否为有效的社会信用代码。
    这里假设有效的代码是18位字符，由数字和大写字母组成（允许字母X）。
    """
    return bool(re.match(r"^[0-9A-Z]{2}\d{6}[0-9A-Z]{10}$", code))


def read_and_clean_codes(path):
    with open(path, "r", encoding="utf-8") as file:
        lines = file.readlines()

    # 清理并过滤数据
    cleaned_codes = [
        line.strip() for line in lines if line.strip() and not re.search("[\u4e00-\u9fff]", line)
    ]
    valid_codes = [code for code in cleaned_codes if is_valid_code(code)]

    return valid_codes


filepath = "../credit_codes.txt"
valid_social_credit_codes = read_and_clean_codes(filepath)

# 保存结果

valid_social_credit_codes = pd.Series(valid_social_credit_codes, name="social_credit_code")

df = valid_social_credit_codes.to_frame()

df.to_csv("../data/valid_social_credit_codes.csv", index=False)
