/**
 * 构建冒烟脚本 —— 替换为真实构建（esbuild / tsc / docker build ...）。
 */
import { cpSync, mkdirSync, rmSync } from "node:fs";

rmSync("dist", { recursive: true, force: true });
mkdirSync("dist", { recursive: true });
cpSync("src", "dist", { recursive: true });

console.log("✓ 构建完成 → dist/");
