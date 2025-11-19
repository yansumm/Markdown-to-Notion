#!/usr/bin/env node
// upload-md-to-notion.js
// Usage:
// 1) node upload-md-to-notion.js /path/to/file.md
// 2) echo "markdown..." | node upload-md-to-notion.js

const fs = require('fs');
const path = require('path');
const { markdownToBlocks } = require('@tryfabric/martian');
const { Client } = require('@notionhq/client');

async function readStdin() {
  return new Promise((resolve) => {
    let data = '';
    // If no stdin is piped, 'end' may never fire. Use a small timeout fallback.
    let timer = setTimeout(() => resolve(''), 50);
    process.stdin.setEncoding('utf8');
    process.stdin.on('data', (chunk) => {
      clearTimeout(timer);
      data += chunk;
    });
    process.stdin.on('end', () => resolve(data));
  });
}

function chunkArray(array, chunkSize) {
  const chunks = [];
  for (let i = 0; i < array.length; i += chunkSize) {
    chunks.push(array.slice(i, i + chunkSize));
  }
  return chunks;
}

async function main() {
  const token = process.env.NOTION_TOKEN;
  const pageId = process.env.NOTION_PAGE_ID;

  if (!token || !pageId) {
    console.error('ERROR: 缺少 NOTION_TOKEN 或 NOTION_PAGE_ID 环境变量。请从 Keychain 注入再运行。');
    process.exit(2);
  }

  let markdown = '';
  const maybeFile = process.argv[2];

  if (maybeFile && fs.existsSync(maybeFile) && fs.statSync(maybeFile).isFile()) {
    markdown = fs.readFileSync(maybeFile, 'utf8');
  } else {
    markdown = await readStdin();
  }

  if (!markdown || markdown.trim().length === 0) {
    console.error('没有读取到 Markdown 内容。');
    process.exit(0);
  }

  // 可在此进行可选的预处理，例如修复部分内联数学表达式边界问题（请谨慎启用并先测试）：
  // markdown = markdown.replace(/\$([^$\n]+)\$/g, (m, p1) => `$$${p1}$$`);

  const blocks = markdownToBlocks(markdown);
  if (!Array.isArray(blocks) || blocks.length === 0) {
    console.error('未能从 Markdown 生成 Notion blocks。');
    process.exit(1);
  }

  const notion = new Client({ auth: token });
  const batches = chunkArray(blocks, 50);

  try {
    for (const batch of batches) {
      await notion.blocks.children.append({
        block_id: pageId,
        children: batch,
      });
    }
    const fileInfo = maybeFile ? ` 文件: ${path.basename(maybeFile)}` : '';
    console.log(`上传成功，已追加到页面 ${pageId}.${fileInfo}`);
  } catch (error) {
    console.error('上传出错：');
    if (error && error.body) {
      console.error(JSON.stringify(error.body, null, 2));
    } else {
      console.error(error);
    }
    process.exit(3);
  }
}

main();
