import { test } from "node:test";
import assert from "node:assert/strict";
import { clamp } from "../src/index.js";

test("clamp: 区间内原值返回", () => {
  assert.equal(clamp(5, 0, 10), 5);
  assert.equal(clamp(0, 0, 10), 0);
  assert.equal(clamp(10, 0, 10), 10);
  assert.equal(clamp(-2.5, -5, 5), -2.5);
});

test("clamp: 低于 min 返回 min", () => {
  assert.equal(clamp(-3, 0, 10), 0);
  assert.equal(clamp(-100, -10, 10), -10);
});

test("clamp: 高于 max 返回 max", () => {
  assert.equal(clamp(42, 0, 10), 10);
  assert.equal(clamp(999, -10, 10), 10);
});
