---
name: health
description: 综合健康分析技能 - 分析健康数据（运动、睡眠、营养、减重、心理、口腔、皮肤、职业、性健康、中医体质、家族遗传）、生成紧急医疗信息卡、旅行健康风险评估、健康趋势与相关性分析、个性化健康建议。触发词：健康分析、健康趋势、体检报告解读、运动记录、睡眠分析、减肥/减重、营养/饮食/食物热量、BMR/TDEE代谢、心理健康/情绪/焦虑/抑郁、PHQ-9/GAD-7、口腔/牙齿、皮肤/护肤/痣、职业病/久坐/用眼健康、体检/筛查、中医体质/体质辨识、性健康/避孕/STD筛查、家族病史/遗传、健康目标、紧急医疗卡片、急救信息、旅行健康、疫苗、travel health、health trend、fitness、sleep、nutrition、weight loss、mental health、emergency card。
risk: critical
source: consolidated
---

# 健康分析技能 (Health Analysis)

统一的健康数据分析工作流:读取健康数据 → 趋势/相关性/变化检测分析 → 风险与模式识别 → 个性化建议与报告。所有分析仅供参考,**不构成医疗诊断或治疗建议**。

## When to Use (何时使用)

- 用户要求分析某方面的健康数据(运动、睡眠、营养、体重、心理、口腔、皮肤、职业、性健康、中医体质、家族病史、健康目标)。
- 用户询问健康趋势("我的健康状况有什么变化?")、相关性("我的症状和什么相关?")、风险评估或目标进度。
- 用户需要生成紧急医疗信息卡、旅行前健康评估或疫苗接种建议。
- 涉及体检报告/化验解读、BMR/TDEE计算、食物营养查询。

## Core Workflow (通用分析流程)

所有子领域的分析遵循同一骨架(详见 `references/analysis-core.md`):

1. **确定范围**:分析类型(趋势/评估/相关性/建议)与时间范围(默认3个月)。
2. **读取数据**:从本地JSON读取(`data/`或`data-example/`),主文件 + 每日日志(`data/*-logs/YYYY-MM/YYYY-MM-DD.json`)。
3. **数据验证**:检查文件存在、结构完整、数据点足够(趋势分析至少需1个月数据)。
4. **趋势分析**:线性回归、移动平均、趋势方向(改善/稳定/下降)、变化幅度百分比。
5. **相关性分析**:Pearson相关系数、滞后相关性、多变量回归;强度划分(弱<0.3/中等0.3-0.7/强>0.7,p<0.05为显著)。
6. **变化检测**:异常值检测、阈值警报、改善/恶化识别。
7. **风险与模式识别**:按子领域专用评分(见各reference)。
8. **生成报告**:文本报告 + 独立HTML报告(ECharts图表,CDN依赖,可打印可分享)。
9. **建议与行动计划**:优先级排序(立即行动 P0 → 本周 → 本月),量化目标。

## Selection Routing (按任务路由)

| 用户需求 | 使用 reference |
|---------|---------------|
| 跨维度趋势、相关性、变化检测、一般健康总结 | `references/analysis-core.md` |
| 饮食摄入、营养素评估、RDA对比、食物查询/对比/推荐、营养密度评分 | `references/nutrition-food.md` |
| 减重、BMI/体脂/围度、BMR/TDEE、能量缺口、平台期 | `references/weightloss.md` |
| 睡眠时长/效率/规律性、PSQI、失眠、STOP-BANG、睡眠卫生 | `references/sleep.md` |
| 情绪、PHQ-9/GAD-7、心理治疗进展、危机风险 | `references/mental-health.md` |
| 运动记录、健身进展、康复训练、依从性、ROM、疼痛 | `references/fitness-rehab.md` |
| 久坐/VDT/倒班风险、人机工程、职业病筛查 | `references/occupational-health.md` |
| 口腔(龋齿/牙周/口腔癌)与皮肤(皮肤癌/痤疮/日晒)风险评估 | `references/oral-skin.md` |
| 性健康:IIEF-5、STD筛查、避孕管理、性活动日志 | `references/sexual-health.md` |
| 中医体质辨识、养生建议、季节调养 | `references/tcm-constitution.md` |
| 紧急医疗信息卡、旅行健康风险、疫苗、多语言医疗卡片 | `references/emergency-travel.md` |
| 家族病史、遗传风险、SMART健康目标、习惯养成 | `references/family-goals.md` |

## Medical Safety Boundaries (医学安全边界)

所有健康分析必须遵守以下边界(来源整合自全部17个源技能):

### 能做 ✅
- 数据统计、趋势识别、关联分析、风险评估(低/中/高分级)
- RDA/标准对比、预防性建议、筛查提醒、就医建议
- 提供教育资源与专业资源信息、一般生活方式建议

### 不能做 ❌
- **不进行疾病诊断**(不依据家谱/症状诊断疾病)
- **不作用药处方或剂量建议**(仅列出当前用药,旅行用药须由医生制定)
- **不预测个体发病概率或生死预后**
- **不开心理/精神药物处方、不预测自杀行为**
- **不替代中医师辨证、不开中药处方**
- **不处理急性危机**(急性精神危机、严重过敏休克等直接引导就医)

### 危险信号识别(必须提示就医)
- 心理:PHQ-9第9项≥2分、PHQ-9/GAD-7≥15分、快速恶化≥5分/月、出现自伤/自杀计划
- 营养:持续<1200卡(女)/<1500卡(男)、维生素A/D过量(VA>3000μg、VD>100μg长期)、钠持续>2300mg
- 睡眠:失眠>3个月、STOP-BANG≥3分、严重嗜睡影响驾驶
- 皮肤:痣短期内变化(ABCDE法则)、多个异常痣、黑色素瘤家族史
- 减重:BMI>35、孕期哺乳期、慢性病多重用药者先咨询医生

### 每次都需包含的免责声明
⚠️ 本分析基于记录数据统计,仅供参考,不替代专业医疗诊断。如有健康问题请咨询医生。

### 隐私保护
- 数据仅存本地,无外部API调用;电话号码部分隐藏(138\*\*\*\*1234);敏感信息可选隐藏;HTML报告独立运行(无数据外传)。

## Data Sources (数据源约定)

各子领域主数据文件(在`data/`或`data-example/`下):
`profile.json`(基础信息)、`allergies.json`、`medications/medications.json`、`nutrition-tracker.json`、`sleep-tracker.json`、`fitness-tracker.json`、`mental-health-tracker.json`、`food-database.json`、`tcm-constitution-tracker.json`、`family-health-tracker.json`、`occupational-health-tracker.json`、`travel-health-tracker.json`、`hypertension/diabetes-tracker.json`(慢性病)、`health-logs/*`(每日日志)。
读取失败时:使用默认值或跳过该维度,不因单个文件失败而中断,并提示缺失。

## Report Formats (报告格式)

所有报告遵循统一结构(详见 `references/analysis-core.md`):

1. **摘要**:总体评估(改善中/稳定/需关注)
2. **趋势**:各维度起始值→当前值、变化幅度%、趋势线图
3. **相关性**:相关系数、强度、实践建议
4. **风险**:风险等级(🟢低/🟡中/🔴高)、风险因素列表
5. **洞察**:关键发现(逐条,附数据证据)
6. **优先级行动计划**:P0立即→本周→本月,量化目标与预期效果
7. **免责声明 + 数据质量说明**(数据完整性、记录数、周期)

文本报告适合命令行输出;HTML报告(ECharts)适合完整可视化、分享给医生、打印。

## Best Practices (最佳实践)

- **仅基于已记录数据分析,不推测缺失信息**;标注数据来源与时间范围。
- 关联分析时区分**相关性≠因果**,措辞用"识别出中等相关(r=0.62)",不用"导致"。
- 建议需**可执行**:给出具体动作、频率、时长、预期效果,而非空泛"注意健康"。
- 跨模块联动:营养↔睡眠↔运动↔心理的关联分析是价值最高的输出。
- 数值类计算(BMR/TDEE/能量缺口/一致性评分)给出**公式与代入过程**,便于核对。
- 高风险项输出"建议就医 X天内"的具体时间框(24h/48h/1月),并保留紧急资源信息。

## Common Pitfalls (常见错误)

- ❌ 数据不足仍下结论:至少3次量表评估或7天日记(心理)、1个月数据(趋势)。
- ❌ 把家系聚集当作个体发病概率预测。
- ❌ 用补充剂/睡眠药/中药"处方"口吻建议:改为"可考虑……请咨询医生"。
- ❌ 忽略隐私(直接显示完整手机号、护照号)。
- ❌ 几个疾病共病关联(如糖尿病-心理)时只列单向影响,忽略双向。
- ❌ 在HTML报告中内嵌用户真实姓名与敏感信息,而不做脱敏或提供"隐藏敏感信息"开关。

## Examples (示例)

**例1 - 健康趋势**:用户"过去3个月我的健康有什么变化?" → 读取症状/情绪/饮食/用药/化验数据 → 逐维度趋势结论 → 睡眠↔情绪r=0.78 → "体重管理改善、用药依从性需关注" → 行动计划。

**例2 - 危机风险**:用户"/crisis assessment" → 计算风险评分 → 高风险时输出:立即联系心理危机热线/精神科急诊/急救电话120 + 风险因素清单。

**例3 - 减重**:用户给出体重/身高/年龄/性别 → BMR(Mifflin公式) → TDEE(活动系数) → 能量缺口500/750/1000kcal三档方案 → 安全检查(不低于BMR×1.2、男1500/女1200kcal)。

**例4 - 旅行**:用户"计划8月去东南亚14天" → 目的地风险(登革热等) → 疫苗(甲肝/伤寒)时间线(出发前4-6周) → 旅行药箱 → 多语言紧急卡片。

## References (参考资料)

- `references/analysis-core.md` — 通用工作流、算法、报告模板、安全边界细节
- `references/nutrition-food.md` — 营养分析与食物数据库
- `references/weightloss.md` — 减重与代谢计算
- `references/sleep.md` — 睡眠分析
- `references/mental-health.md` — 心理健康与危机干预
- `references/fitness-rehab.md` — 运动与康复
- `references/occupational-health.md` — 职业健康
- `references/oral-skin.md` — 口腔与皮肤健康
- `references/sexual-health.md` — 性健康
- `references/tcm-constitution.md` — 中医体质
- `references/emergency-travel.md` — 紧急卡片与旅行健康
- `references/family-goals.md` — 家族遗传与健康目标

> 维护说明:本技能由17个独立技能整合而成,去重与合并记录见 `dedup-notes.md`。