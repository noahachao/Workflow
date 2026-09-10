import { test } from "node:test";
import assert from "node:assert/strict";
import { multiply } from "../src/index.js";

test("multiply: 正数乘法", () => {
  assert.equal(multiply(2, 3), 6);
  assert.equal(multiply(1.5, 4), 6);
});

test("multiply: 负数乘法", () => {
  assert.equal(multiply(-2, 3), -6);
  assert.equal(multiply(-2, -3), 6);
});

test("multiply: 零乘法", () => {
  assert.equal(multiply(0, 5), 0);
  assert.equal(multiply(5, 0), 0);
  assert.equal(multiply(0, 0), 0);
});
