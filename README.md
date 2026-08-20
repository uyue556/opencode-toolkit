# OpenCode Toolkit

opencode 工具集备份仓库，包含 skills、plugins、MCP 配置等。

## 目录结构

```
├── skills/                    # 技能库（30个分类，100+技能）
│   ├── ai-agents/            # AI Agent 开发
│   ├── ai-ml/                # AI/ML 机器学习
│   ├── automation/           # 自动化脚本
│   ├── backend/              # 后端开发
│   ├── web-frontend/         # 前端开发
│   ├── devops-reliability/   # DevOps/运维
│   ├── skill-creator/        # 技能创建器
│   └── ...                   # 更多分类
├── plugins/                   # 插件
│   ├── notification.js       # 任务完成通知
│   └── skill-evolution/      # 技能自动演进
├── category-pointers-archive/ # 分类指针归档
├── opencode.json              # 主配置（providers、MCP、plugins）
└── dcp.jsonc                  # 动态上下文剪枝配置
```

## 安装使用

1. 克隆仓库：

```bash
git clone git@github.com:uyue556/opencode-toolkit.git
```

2. 复制 skills 到 opencode 配置目录：

```bash
cp -r opencode-toolkit/skills/* ~/.config/opencode/skills/
```

3. 复制 plugins：

```bash
cp -r opencode-toolkit/plugins/* ~/.config/opencode/plugins/
```

## 包含的技能分类

| 分类 | 说明 |
|------|------|
| ai-agents | AI Agent 开发 |
| AI-Animation-Skill | AI 动画制作 |
| ai-ml | AI/ML 机器学习 |
| automation | 自动化脚本 |
| backend | 后端开发 |
| blockchain | 区块链/Web3 |
| business | 商业/创业 |
| cloud | 云服务 |
| content-writing | 内容写作 |
| data-database | 数据库 |
| design | 设计 |
| devops-reliability | DevOps/运维 |
| education-research | 教育/研究 |
| engineering-architecture | 架构工程 |
| find-skills | 技能发现工具 |
| game-dev | 游戏开发 |
| health | 健康 |
| legal | 法律 |
| marketing-growth | 营销增长 |
| media | 媒体 |
| misc-uncategorized | 未分类 |
| mobile | 移动端 |
| productivity-memory | 效率/记忆 |
| project-planning | 项目规划 |
| scenes-gathered-zine-v1-3 | 拼贴海报风格图片生成 |
| security | 安全 |
| skill-creator | 技能创建器 |
| testing-quality | 测试质量 |
| web-frontend | 前端开发 |
| workflow-orchestration | 工作流编排 |

## MCP 工具配置

- **context7**: 文档检索
- **firecrawl**: 网页爬取
- **playwright**: 浏览器自动化
- **sqlite**: SQLite 数据库

## 模型提供商

- Agnes Image: 图片生成
- DeepSeek: V4 Pro
- Xiaomi MiMo: V2.5
- Grok: 4.5 (xAI)
- Faro API: Grok 4.5 中转
