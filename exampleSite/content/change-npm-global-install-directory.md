---
title: "Change npm's Global Install Directory"
date: 2026-05-08
category: ["techne"]
tags: ["npm", "node", "权限", "配置"]
---

## 动机

默认情况下，`npm install -g` 将全局包安装到系统目录（通常是 `/usr/local/lib/node_modules` 或 `/usr/lib/node_modules`），这需要 `sudo` 权限。这不仅不安全，还可能导致权限混乱。

将全局安装目录改为用户自有路径可以：
- 避免 `sudo npm install -g` 的权限问题
- 保持全局包与用户环境一致
- 便于迁移和备份

## 操作步骤

### 1. 创建新目录

```bash
mkdir -p ~/.npm-global
```

### 2. 设置 npm prefix

```bash
npm config set prefix ~/.npm-global
```

这会写入 `~/.npmrc`，等价于：

```bash
echo 'prefix=~/.npm-global' >> ~/.npmrc
```

### 3. 更新 PATH

将以下内容添加到 shell 配置文件（bash: `~/.bashrc`，zsh: `~/.zshrc`，nu: `~/.config/nushell/config.nu`）：

```bash
export PATH=~/.npm-global/bin:$PATH
```

Nushell 用户：

```nu
$env.PATH = ($env.PATH | prepend '~/.npm-global/bin')
```

### 4. 使配置生效

```bash
source ~/.bashrc   # 或对应的配置文件
```

### 5. 验证

```bash
npm config get prefix
# 应输出: /home/<user>/.npm-global

npm install -g some-package
# 不应要求 sudo
```

## 注意事项

- 如果之前用 `sudo` 安装过全局包，旧的全局包不会自动迁移。建议先用 `sudo npm ls -g --depth=0` 列出，再重新安装。
- `npx` 也会使用 `prefix` 配置的路径，无需额外设置。
- Node.js 版本管理器（nvm、fnm 等）已自动处理此问题，如果使用它们则无需手动设置。
