import { test } from "node:test";
import assert from "node:assert/strict";
import { add, greet } from "../src/index.js";

test("add: 基础加法", () => {
  assert.equal(add(1, 2), 3);
  assert.equal(add(-1, 1), 0);
});

test("add: 浮点安全场景", () => {
  assert.ok(Number.isFinite(add(0.1, 0.2)));
});

test("greet: 返回问候语", () => {
  assert.ok(greet("世界").includes("世界"));
});
