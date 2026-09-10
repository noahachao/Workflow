import { test } from "node:test";
import assert from "node:assert/strict";
import { divide } from "../src/index.js";

test("divide: 正数除法", () => {
  assert.equal(divide(6, 3), 2);
  assert.equal(divide(7, 2), 3.5);
  assert.equal(divide(0, 5), 0);
});

test("divide: 负数除法", () => {
  assert.equal(divide(-6, 3), -2);
  assert.equal(divide(6, -3), -2);
  assert.equal(divide(-6, -3), 2);
});

test("divide: 除数为 0 抛出 Error", () => {
  assert.throws(() => divide(1, 0), {
    name: "Error",
    message: "除数不能为 0",
  });
  assert.throws(() => divide(0, 0), /除数不能为 0/);
  assert.throws(() => divide(-5, 0), /除数不能为 0/);
});
