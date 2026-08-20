# Deduplication Notes — health 领域合并记录

来源库: `/home/administrator/.config/opencode/skill-libraries/health/` (17 个 SKILL.md, 全部读取/扫描)

## 合并策略概述

17 个源技能中,12 个 `*-analyzer` 技能共享同一套模板骨架:
**趋势分析 → 风险评估 → 相关性分析 → 个性化建议 → 预警系统 → 报告**,
且都引用相同的数据源约定(`data/*-tracker.json`、`data/*-logs/`)、相同的统计算法
(线性回归 / Pearson / 移动平均)、相同的医学免责声明结构。因此将公共骨架抽到
`references/analysis-core.md`,每个子领域保留其**独有的评分表/算法/阈值**。

## 合并映射

| 源技能 | 合并去向 | 说明 |
|--------|---------|------|
| health-trend-analyzer | `analysis-core.md` + SKILL.md | 通用工作流、算法、报告模板、数据源、安全边界的母本 |
| nutrition-analyzer | `nutrition-food.md` | RDA达成率、营养密度、危险信号 |
| food-database-query | `nutrition-food.md` | 食物查询/比较/推荐/营养计算、RDA参考值表 |
| weightloss-analyzer | `weightloss.md` | BMR/TDEE公式、能量缺口、平台期 |
| sleep-analyzer | `sleep.md` | 睡眠质量/一致性评分算法、STOP-BANG、CBT-I元素 |
| mental-health-analyzer | `mental-health.md` | 危机风险评分表(最详尽的专用算法) |
| fitness-analyzer | `fitness-rehab.md` | 运动趋势/进步/习惯 |
| rehabilitation-analyzer | `fitness-rehab.md` | 依从性、疼痛模式、ROM、改善模式 |
| occupational-health-analyzer | `occupational-health.md` | 久坐/VDT风险评分、人机工程评分 |
| oral-health-analyzer | `oral-skin.md` | 龋齿/牙周/口腔癌风险 |
| skin-health-analyzer | `oral-skin.md` | 皮肤癌/痤疮风险、ABCDE痣监测 |
| sexual-health-analyzer | `sexual-health.md` | IIEF-5、STD筛查、避孕、风险评分 |
| tcm-constitution-analyzer | `tcm-constitution.md` | 九种体质、评分公式、养生建议 |
| emergency-card | `emergency-travel.md` | 紧急医疗信息卡(优先级/格式/数据源) |
| travel-health-analyzer | `emergency-travel.md` | 目的地风险、疫苗、药箱、多语言卡片 |
| family-health-analyzer | `family-goals.md` | 遗传风险加权公式 |
| goal-analyzer | `family-goals.md` | SMART验证、习惯、动机 |

## 重复内容删除 (已合并的重复点)

1. **"When to Use / 触发条件 / 核心功能" 开篇模板**:所有 12 个 analyzer 技能各自写了几乎相同的三小节,全部压缩为 SKILL.md 的一张路由表 + 触发词列表。
2. **医学免责声明模板**:每个技能重复全文声明"仅供参考/不替代医疗诊断",合并为 SKILL.md 的统一安全边界节(能做/不能做/危险信号/隐私)。
3. **通用算法三段式**:每个技能的"趋势分析算法(线性回归/移动平均)+ 相关性分析算法(Pearson/Spearman)+ 变化检测"几乎逐字重复,只保留一份在 `analysis-core.md`。
4. **数据源列表**:`profile.json / fitness-tracker.json / nutrition-tracker.json / sleep-tracker.json / hypertension-tracker.json / diabetes-tracker.json` 在每个技能重复列出,合并为 SKILL.md 的 Data Sources 约定。
5. **HTML报告(ECharts)描述**:health-trend、mental、family、goal 各自描述了近乎相同的交互式HTML报告,合并为 `analysis-core.md` 一节。
6. **报告结构中"摘要→趋势→相关性→建议"骨架**:各 analyzer 重复,已在 `analysis-core.md` 统一模板,子领域 reference 只写差异。
7. **免责声明"本技能不能做..."列表**:nutrition/sleep/mental/tcm/travel 都各写一遍,合并进 SKILL.md 的统一边界。
8. **Limitations 三段(英文通用文本)**:17 个文件都以相同英文模板结尾,整体删除,由 SKILL.md 的 scope 说明替代。

## 被精简/未单独成节的来源

- 所有源技能的 **数据结构 JSON 示例**(sleep/nutrition/tcm/mental 等)只保留最有代表性的字段说明,不再逐文件复现完整 JSON——数据 schema 已在各 reference 中以要点形式给出。
- **示例报告全文**:源技能里每份完整 Markdown 报告模板(睡眠报告90+行、营养报告200+行等)属于"格式示例",其结构与填充规则已提炼到 `analysis-core.md` 报告模板,具体数字示例只保留有算法价值的(SMART评分、危机评分、BMR计算、能量缺口表)。

## 关键决策

- **危机风险评估表**(mental-health)是唯一明确"立即就医"行动阈值(24h/48h/1月)的评分系统,完整保留。
- **BMI 亚洲标准**(24/28 界值)与 WHO 标准并存,取源技能的亚洲标准版本并注明。
- **中医体质**内容独特(九种体质表、转化分数公式、穴位、四季调养),完整保留,但中药方剂部分明确标注"仅供中医师参考,不可自行抓药"以符合安全边界。

## 未发现的问题

- 源库无 `scripts/`、`references/`、`assets/` 子目录(仅 emergency-card 提及 `scripts/generate_emergency_card.py` 但脚本文件不存在于库内),故无脚本可搬运。
- 无图像/字体/模板资产需要忽略。
