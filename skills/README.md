# Skills 目录说明

本目录包含整合后的技能（skills）。原 103 个分类指针技能与 96 个技能库（~1879 个 SKILL.md）
已被合并为 26 个粗粒度领域技能，每个技能含一份 `SKILL.md`（路由表）+ `references/`（子主题参考）。

## 技能清单

| 领域技能 | 覆盖范围 | 参考文件数 |
|---|---|---|
| `ai-agents` | Agent 架构/框架/编排/评估/MCP/语音/行为护栏 | 9 |
| `ai-ml` | 提示工程/LLM 应用/RAG/训练/评估/MLOps/媒体生成 | 9 |
| `automation` | 工作流平台(n8n/Zapier/Make)/浏览器自动化/Apify/SaaS MCP | 10 |
| `backend` | API 设计/GraphQL/安全/支付/架构/队列/Node/Python/.NET/Laravel | 13 |
| `blockchain` | Solidity/DeFi/web3 测试/NFT/节点/Lightning | 7 |
| `business` | 战略/市场规模/财务/定价/产品/GTM/RevOps/创业/Odoo | 12 |
| `cloud` | AWS/Azure/GCP/多云/IaC/成本优化 | 7 |
| `content-writing` | 博客/文案/故事/技术写作/SEO 内容/编辑/学术 | 8 |
| `data-database` | SQL/数据库设计/迁移/NoSQL/向量/数工/DS/数据AI/表格/文档 | 12 |
| `design` | 48 种风格路由/色彩/UX/设计系统/动效/无障碍 | 8 |
| `devops-reliability` | CI-CD/部署/Docker/K8s/Terraform/监控/SLO/事件/复盘/MLOps | 13 |
| `education-research` | 学习教学/备考/综述/研究/文献/事实核查/科学 Python | 9 |
| `engineering-architecture` | ADR/模式/DDD/事件溯源/微服务/系统设计/C4/代码质量 | 13 |
| `game-dev` | 引擎选型/2D/3D/设计/多人/Unity/Godot/Bukkit | 18 |
| `health` | 营养/减重/睡眠/心理/康复/职业/口腔/两性/中医/急救 | 12 |
| `legal` | 巴西法律/合同/海关/FDA/拍卖/Lex | 21 |
| `marketing-growth` | SEO/文案/社交/邮件/广告/CRO/增长/竞研/ASO | 11 |
| `media` | 视频/图像生成/PPTX/HTML slides/Google Slides | 9 |
| `misc-uncategorized` | 原 uncategorized(283) 的 15 个主题簇 | 15 |
| `mobile` | iOS/Android/跨平台/Expo/上架/性能/安全 | 11 |
| `productivity-memory` | 记忆系统/上下文优化/知识管理/工作流/时间/办公 | 9 |
| `project-planning` | 计划写作/特性追踪/估算/PRD/决策/协作/SR&ED | 9 |
| `security` | Web 安全/认证授权/渗透/SAST/容器/取证/威胁建模/合规 | 20 |
| `testing-quality` | TDD/单元/E2E/质量评审/性能/调试/代码质量/发布门禁 | 9 |
| `web-frontend` | React/Next/Svelte/Astro/Angular/Tailwind/TS/性能/PWA | 18 |
| `workflow-orchestration` | 持久化执行平台/编排模式/DAG/Agent 工作流/状态机/CI | 6 |

另保留 3 个真实技能：`skill-creator`（创建/编辑技能）、`find-skills`（发现技能）、
`AI-Animation-Skill`（科普内容生成 PPT 网页）。内置技能 `customize-opencode` 不受影响。

## 目录结构约定

- `SKILL.md`：frontmatter（`name` + `description`，含中英触发词）+ 路由表 + 最佳实践 + 易错点，<500 行。
- `references/`：每个子主题一个 Markdown 文件；>300 行的文件带目录（ToC）。
- `scripts/`：可复用脚本（少量技能有）。
- `dedup-notes.md`：记录该领域的合并来源、丢弃项、脚本来源与缺口。

## 归档

- 原 96 个分类指针：`../category-pointers-archive/`（100 个 `*-category-pointer` 目录）。
- 原 96 个技能库（~1879 个 SKILL.md）：`../skill-libraries-backup/`（76MB，已校验与原始一致）。
