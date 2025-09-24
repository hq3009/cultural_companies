#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
文旅企业假数据生成器
生成用于测试Step1→Step2→Step3流程的模拟数据
"""

import random
import string
import datetime
import json
from typing import List, Dict, Any

class FakeDataGenerator:
    def __init__(self):
        # 文旅行业代码列表
        self.cultural_tourism_codes = [
            '0141', '0143', '0149', '0151', '0152', '0153', '0154', '0159',
            '0412', '1784', '1922', '2221', '2222', '2311', '2312', '2319',
            '2320', '2330', '2411', '2412', '2414', '2421', '2422', '2423',
            '2429', '2431', '2432', '2433', '2434', '2435', '2436', '2437',
            '2438', '2439', '2441', '2442', '2449', '2451', '2452', '2453',
            '2454', '2455', '2456', '2459', '2461', '2462', '2469', '2642',
            '2644', '2664', '2672', '3075', '3076', '3471', '3472', '3473',
            '3474', '3542', '3733', '3780', '3873', '3931', '3932', '3933',
            '3934', '3939', '3951', '3952', '3953', '3961', '3963', '3969',
            '5137', '5141', '5143', '5144', '5145', '5146', '5147', '5149',
            '5175', '5178', '5181', '5183', '5184', '5211', '5212', '5213',
            '5219', '5221', '5222', '5223', '5224', '5225', '5226', '5227',
            '5229', '5231', '5232', '5233', '5234', '5235', '5236', '5237',
            '5238', '5239', '5241', '5242', '5243', '5244', '5245', '5246',
            '5247', '5248', '5249', '5261', '5262', '5263', '5264', '5265',
            '5266', '5267', '5271', '5311', '5312', '5313', '5331', '5333',
            '5339', '5411', '5412', '5413', '5414', '5419', '5421', '5422',
            '5429', '5441', '5442', '5443', '5449', '5511', '5512', '5513',
            '5531', '5539', '5611', '5622', '5631', '5632', '5639', '5822',
            '5910', '6110', '6121', '6129', '6130', '6140', '6190', '6210',
            '6220', '6231', '6232', '6233', '6239', '6241', '6291', '6319',
            '6321', '6322', '6331', '6421', '6422', '6429', '6432', '6434',
            '6439', '6440', '6450', '6513', '6572', '6579', '6621', '6623',
            '6624', '6629', '6634', '6635', '6636', '6637', '6639', '6813',
            '6814', '6820', '6999', '7111', '7115', '7119', '7121', '7122',
            '7123', '7124', '7125', '7129', '7130', '7211', '7212', '7215',
            '7219', '7221', '7222', '7223', '7224', '7229', '7251', '7259',
            '7271', '7272', '7281', '7282', '7283', '7284', '7289', '7291',
            '7294', '7297', '7298', '7299', '7350', '7484', '7491', '7492',
            '7520', '7711', '7712', '7713', '7714', '7715', '7716', '7719',
            '7850', '7861', '7862', '7869', '8051', '8052', '8053', '8060',
            '8070', '8336', '8341', '8342', '8391', '8393', '8399', '8412',
            '8413', '8414', '8415', '8416', '8511', '8512', '8610', '8621',
            '8622', '8623', '8624', '8625', '8626', '8629', '8710', '8720',
            '8730', '8740', '8750', '8760', '8770', '8810', '8820', '8831',
            '8832', '8840', '8850', '8860', '8870', '8890', '8921', '8929',
            '8930', '9011', '9012', '9013', '9019', '9020', '9030', '9051',
            '9053', '9059', '9090', '9221', '9222', '9521', '9522', '9542'
        ]

        # 宁波市各区县
        self.areas = ['海曙区', '江北区', '北仑区', '镇海区', '鄞州区', '奉化区', '余姚市', '慈溪市', '宁海县', '象山县']

        # 企业类型
        self.company_types = [
            '有限责任公司(自然人投资或控股)',
            '有限责任公司(自然人独资)',
            '股份有限公司(非上市)',
            '个人独资企业',
            '合伙企业',
            '个体工商户',
            '外商投资企业',
            '国有企业'
        ]

        # 文旅相关经营范围关键词
        self.business_keywords = [
            '文化', '多媒体', '游戏', '动漫', '数字出版', '建筑设计', '舞台', '婚庆', '娱乐', '版权',
            '会议', '展览', '广告', '工艺美术', '旅游', '出行', '游客', '观光', '游览', '旅行',
            '体育', '休闲', '公共交通', '健康', '休养', '会展', '翻译', '健身', '保健', '酒店'
        ]

        # 企业名称前缀
        self.company_prefixes = [
            '宁波', '浙江', '杭州', '温州', '嘉兴', '湖州', '绍兴', '金华', '衢州', '舟山', '台州', '丽水'
        ]

        # 企业名称后缀
        self.company_suffixes = [
            '文化传媒', '旅游开发', '酒店管理', '餐饮服务', '娱乐休闲', '体育健身', '广告设计', '会展服务',
            '旅行社', '景区管理', '文化创意', '影视制作', '游戏开发', '动漫制作', '工艺品', '艺术品',
            '教育培训', '健身俱乐部', '温泉度假', '民宿客栈', '主题公园', '博物馆', '图书馆', '剧院'
        ]

    def generate_social_credit_code(self) -> str:
        """生成统一社会信用代码"""
        # 简化版本：913302 + 6位随机数字 + 1位校验码
        base = "913302" + ''.join(random.choices(string.digits, k=6))
        # 简单的校验码生成
        check_digit = random.choice(string.ascii_uppercase + string.digits)
        return base + check_digit

    def generate_company_name(self) -> str:
        """生成企业名称"""
        prefix = random.choice(self.company_prefixes)
        suffix = random.choice(self.company_suffixes)
        middle = ''.join(random.choices(string.ascii_letters + string.digits, k=random.randint(2, 6)))
        return f"{prefix}{middle}{suffix}有限公司"

    def generate_business_scope(self) -> str:
        """生成经营范围"""
        keywords = random.sample(self.business_keywords, random.randint(2, 5))
        scope_parts = []
        for keyword in keywords:
            scope_parts.append(f"{keyword}服务")
        scope_parts.append("其他相关业务")
        return "；".join(scope_parts) + "。(依法须经批准的项目，经相关部门批准后方可开展经营活动)"

    def generate_date(self, start_year: int = 2000, end_year: int = 2024) -> str:
        """生成随机日期"""
        start_date = datetime.date(start_year, 1, 1)
        end_date = datetime.date(end_year, 12, 31)
        time_between_dates = end_date - start_date
        days_between_dates = time_between_dates.days
        random_number_of_days = random.randrange(days_between_dates)
        random_date = start_date + datetime.timedelta(days=random_number_of_days)
        return random_date.strftime('%Y-%m-%d')

    def generate_financial_data(self) -> Dict[str, float]:
        """生成财务数据"""
        base_assets = random.uniform(10, 10000) * 10000  # 10万到1亿
        debt_ratio = random.uniform(0.1, 0.8)  # 负债率10%-80%
        profit_margin = random.uniform(0.05, 0.3)  # 利润率5%-30%

        total_assets = base_assets
        total_liabilities = total_assets * debt_ratio
        owner_equity = total_assets - total_liabilities
        total_revenue = total_assets * random.uniform(0.5, 2.0)  # 营收是资产的0.5-2倍
        total_profit = total_revenue * profit_margin
        net_profit = total_profit * random.uniform(0.7, 0.9)  # 净利润是利润总额的70%-90%
        total_tax = total_revenue * random.uniform(0.05, 0.15)  # 税率5%-15%

        return {
            'total_assets': round(total_assets, 2),
            'total_liabilities': round(total_liabilities, 2),
            'owner_equity': round(owner_equity, 2),
            'total_revenue': round(total_revenue, 2),
            'total_profit': round(total_profit, 2),
            'net_profit': round(net_profit, 2),
            'total_tax': round(total_tax, 2)
        }

    def generate_social_security_data(self) -> Dict[str, Any]:
        """生成社保数据"""
        has_social_security = random.random() < 0.8  # 80%的企业有社保

        if has_social_security:
            employee_count = random.randint(5, 200)
            pension_count = int(employee_count * random.uniform(0.8, 1.0))
            medical_count = int(employee_count * random.uniform(0.8, 1.0))
            unemployment_count = int(employee_count * random.uniform(0.7, 0.9))
            injury_count = int(employee_count * random.uniform(0.6, 0.8))
            maternity_count = int(employee_count * random.uniform(0.3, 0.6))

            payment_months = random.randint(1, 12)
            personal_payment_base = random.uniform(3000, 15000)
            payment_amount = personal_payment_base * employee_count * 0.1
            corporate_payment_amount = payment_amount * random.uniform(1.5, 2.0)
            personal_payment_amount = payment_amount * random.uniform(0.8, 1.2)
        else:
            employee_count = pension_count = medical_count = unemployment_count = injury_count = maternity_count = 0
            payment_months = personal_payment_base = payment_amount = corporate_payment_amount = personal_payment_amount = 0

        return {
            'pension_count': pension_count,
            'medical_count': medical_count,
            'unemployment_count': unemployment_count,
            'injury_count': injury_count,
            'maternity_count': maternity_count,
            'payment_months': payment_months,
            'personal_payment_base': round(personal_payment_base, 2),
            'payment_amount': round(payment_amount, 2),
            'corporate_payment_amount': round(corporate_payment_amount, 2),
            'personal_payment_amount': round(personal_payment_amount, 2)
        }

    def generate_enterprise_data(self, count: int = 3000) -> List[Dict[str, Any]]:
        """生成企业基础数据"""
        company = []

        for i in range(count):
            social_credit_code = self.generate_social_credit_code()
            company_name = self.generate_company_name()
            establishment_date = self.generate_date(2000, 2024)

            # 基础信息
            enterprise = {
                'social_credit_code': social_credit_code,
                'company_name': company_name,
                'reg_authority': f"宁波市{random.choice(self.areas)}市场监督管理局",
                'company_type': random.choice(self.company_types),
                'reg_address': f"浙江省宁波市{random.choice(self.areas)}",
                'legal_rep': f"{random.choice(['张', '李', '王', '陈', '刘', '赵', '孙', '周', '吴', '徐'])}{random.choice(['伟', '强', '勇', '军', '杰', '磊', '敏', '静', '丽', '艳'])}",
                'industry_code': random.choice(self.cultural_tourism_codes),
                'business_scope': self.generate_business_scope(),
                'approval_date': self.generate_date(2020, 2024),
                'establishment_date': establishment_date,
                'domicile_district_code': random.choice(self.areas),
                'business_district_code': random.choice(self.areas),
                'reg_capital': random.uniform(10, 1000) * 10000,  # 注册资本
                'reg_state': '开业'
            }

            # 财务数据
            financial_data = self.generate_financial_data()
            enterprise.update(financial_data)

            # 社保数据
            social_data = self.generate_social_security_data()
            enterprise.update(social_data)

            # 风险标记（基于概率）
            enterprise['has_business_abnormal'] = random.random() < 0.05  # 5%经营异常
            enterprise['has_serious_violation'] = random.random() < 0.02  # 2%严重违法
            enterprise['is_dishonest_person'] = random.random() < 0.03   # 3%失信被执行人
            enterprise['has_penalty'] = random.random() < 0.08           # 8%行政处罚
            enterprise['has_license'] = random.random() < 0.7           # 70%有行政许可
            enterprise['has_equity_change'] = random.random() < 0.15    # 15%有股权变更
            enterprise['has_external_guarantee'] = random.random() < 0.1 # 10%有对外担保
            enterprise['has_website_shop'] = random.random() < 0.6      # 60%有网站网店
            enterprise['is_tech_small_enterprise'] = random.random() < 0.2 # 20%科技型小微企业
            enterprise['is_grade_a_taxpayer'] = random.random() < 0.3   # 30%A级纳税人

            # 变更信息
            if enterprise['has_equity_change']:
                enterprise['change_date'] = self.generate_date(2023, 2024)
            else:
                enterprise['change_date'] = None

            company.append(enterprise)

        return company

    def generate_sql_insert_statements(self, company: List[Dict[str, Any]]) -> str:
        """生成SQL插入语句"""
        sql_statements = []

        # 主表数据
        for enterprise in company:
            sql = f"""INSERT INTO dw_zj_scjdgl_scztxx (
                UNI_SOCIAL_CRD_CD, COMP_NM, REG_ORG, COMP_TYPE, ADDR, LEGAL_REPRE,
                INDV_NM, OPT_SCOP, APPR_DT, EST_DT, DOMDI_STRICT, OPT_STRICT,
                REG_CAPT, REG_STATE
            ) VALUES (
                '{enterprise['social_credit_code']}', '{enterprise['company_name']}',
                '{enterprise['reg_authority']}', '{enterprise['company_type']}',
                '{enterprise['reg_address']}', '{enterprise['legal_rep']}',
                '{enterprise['industry_code']}', '{enterprise['business_scope']}',
                '{enterprise['approval_date']}', '{enterprise['establishment_date']}',
                '{enterprise['domicile_district_code']}', '{enterprise['business_district_code']}',
                {enterprise['reg_capital']}, '{enterprise['reg_state']}'
            );"""
            sql_statements.append(sql)

        return '\n'.join(sql_statements)

    def save_to_files(self, company: List[Dict[str, Any]], output_dir: str = 'fake_database'):
        """保存数据到文件"""
        import os
        os.makedirs(output_dir, exist_ok=True)

        # 保存JSON格式的完整数据
        with open(f'{output_dir}/company_data.json', 'w', encoding='utf-8') as f:
            json.dump(company, f, ensure_ascii=False, indent=2)

        # 保存SQL插入语句
        sql_content = self.generate_sql_insert_statements(company)
        with open(f'{output_dir}/03_insert_sample_data.sql', 'w', encoding='utf-8') as f:
            f.write("-- 文旅企业假数据插入脚本\n")
            f.write("-- 生成时间: " + datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S') + "\n\n")
            f.write(sql_content)

        print(f"数据已保存到 {output_dir}/ 目录")
        print(f"生成了 {len(company)} 条企业记录")

def main():
    """主函数"""
    print("开始生成文旅企业假数据...")

    generator = FakeDataGenerator()
    company = generator.generate_enterprise_data(3000)  # 生成3000条记录

    generator.save_to_files(company)

    print("数据生成完成！")
    print(f"总计生成 {len(company)} 条企业记录")

    # 统计信息
    areas_count = {}
    types_count = {}
    for enterprise in company:
        area = enterprise['domicile_district_code']
        company_type = enterprise['company_type']
        areas_count[area] = areas_count.get(area, 0) + 1
        types_count[company_type] = types_count.get(company_type, 0) + 1

    print("\n=== 数据分布统计 ===")
    print("按区县分布:")
    for area, count in sorted(areas_count.items()):
        print(f"  {area}: {count} 家")

    print("\n按企业类型分布:")
    for company_type, count in sorted(types_count.items()):
        print(f"  {company_type}: {count} 家")

if __name__ == "__main__":
    main()