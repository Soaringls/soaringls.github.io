---
title: Terminator Shortcuts Usage
date: 2020-10-30 10:11:12
mathjax: true
categories:
  - tools
---

- **compile command**
compile all modules
`colcon build --cmake-args -DCMAKE_BUILD_TYPE=Debug Release`
compile special module
`colcon build --packages-select ekf_localizer`

- **open rviz using special rviz config**
`rviz -d ./data/ces_mapping.rviz`