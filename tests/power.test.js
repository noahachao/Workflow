import { test } from "node:test";
import assert from "node:assert/strict";
import { power } from "../src/index.js";

test("power: 正幂", () => {
  assert.equal(power(2, 3), 8);
  assert.equal(power(5, 1), 5);
  assert.equal(power(10, 2), 100);
});

test("power: 零次幂", () => {
  assert.equal(power(2, 0), 1);
  assert.equal(power(0, 0), 1);
  assert.equal(power(-3, 0), 1);
});

test("power: 负底数", () => {
  assert.equal(power(-2, 3), -8);
  assert.equal(power(-2, 2), 4);
  assert.equal(power(-1, 5), -1);
});
