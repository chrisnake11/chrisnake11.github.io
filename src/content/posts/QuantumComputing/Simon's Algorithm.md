---
title: Simon's Algorithm
published: 2024-05-11T10:00:00Z
description: "Simon's Algorithm。"
image: ''
tags: ['Quantum Computing']
category: 'Quantum Computing'
draft: false
---

# Simon's Algorithm

## 1. Simon‘s problem

- Deutsch-Jozsa Problem:

  - Consider a function $f:\{0, 1\}^n \to \{0,1\}$
  - 判断一个函数是Constant Function or Balanced Function

- Simon's Problem

  - Consider a function $f: \{0, 1\}^n \to X, |X| \ge 2^{n - 1}$, A structured 2-to-1 function.
  -  Promise  $\exist S \in \{0, 1\}^n, S \ne 0^n, such \space that: f(x) = f(y), iif, x = y, or,  x = y \oplus s$
  - Problem: find S

  
