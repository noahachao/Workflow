/**
 * 示例模块 —— 整体替换为你的真实业务代码。
 * 保持零依赖 + 纯函数风格，方便 AI agent 理解与测试。
 */

export function add(a, b) {
  return a + b;
}

export function clamp(value, min, max) {
  return Math.min(Math.max(value, min), max);
}

export function divide(a, b) {
  if (b === 0) {
    throw new Error("除数不能为 0");
  }
  return a / b;
}

export function greet(name) {
  return `你好，${name}！`;
}

export function modulo(a, b) {
  if (b === 0) {
    throw new Error("除数不能为 0");
  }
  return ((a % b) + b) % b;
}

export function multiply(a, b) {
  return a * b;
}

export function power(a, b) {
  return a ** b;
}

export function subtract(a, b) {
  return a - b;
}
