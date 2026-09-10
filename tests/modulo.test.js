import { test } from "node:test";
import assert from "node:assert/strict";
import { modulo } from "../src/index.js";

test("modulo: 正数取余", () => {
  assert.equal(modulo(7, 3), 1);
  assert.equal(modulo(6, 3), 0);
  assert.equal(modulo(0, 5), 0);
});

test("modulo: 负被除数归一为非负", () => {
  assert.equal(modulo(-7, 3), 2);
  assert.equal(modulo(-6, 3), 0);
  assert.equal(modulo(-1, 5), 4);
});

test("modulo: 除数为 0 抛出 Error", () => {
  assert.throws(() => modulo(1, 0), {
    name: "Error",
    message: "除数不能为 0",
  });
  assert.throws(() => modulo(0, 0), /除数不能为 0/);
  assert.throws(() => modulo(-5, 0), /除数不能为 0/);
});
