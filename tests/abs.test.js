import { test } from "node:test";
import assert from "node:assert/strict";
import { abs } from "../src/index.js";

test("abs: 正数原值返回", () => {
  assert.equal(abs(5), 5);
  assert.equal(abs(42.5), 42.5);
});

test("abs: 负数返回相反数", () => {
  assert.equal(abs(-5), 5);
  assert.equal(abs(-0.5), 0.5);
});

test("abs: 零返回零", () => {
  assert.equal(abs(0), 0);
});
