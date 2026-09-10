import { test } from "node:test";
import assert from "node:assert/strict";
import { subtract } from "../src/index.js";

test("subtract: 基础减法", () => {
  assert.equal(subtract(5, 3), 2);
});

test("subtract: 负数场景", () => {
  assert.equal(subtract(-5, -3), -2);
  assert.equal(subtract(3, 5), -2);
});
