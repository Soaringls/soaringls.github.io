# Code Style
install cpplint  by `pip install cpplint` and pylint by `pip install pylint`to find bugs and style problems in c++/python source
the reference is [Google Style Guide](https://google.github.io/styleguide/)
## Abseil Libs
[C++ and Python developer Guide from Abseil](https://abseil.io/docs/)
## Code Review
### 目的
- 把控质量
- 传递知识和细节
### 内容
- 整体设计: 设计是否合理
- 功能实现: 是否实现预期功能,是否经过相关充分测试
- 复杂度:设计和实现还能否简化,是否存在重复性代码
- 代码性能:是否有明显的性能问题,是否可以明显的可以优化
- 测试:是否有相关单元测试,测试是否合理
- 命名:是否清晰易懂
- 注释:必要的注释是否有缺失
- 代码风格:风格是否和已有的一致
- 文档更新:相关文档是否更新
### 基本原则
- 选取合适的reviewer,必要时选取资深的reviewer
  - 可以读个reviewer检查多个部分
  - TL帮助新同事加强代码风格和设计原则
- 质量和进度都很重要,没有完美的mr,如果整体改进了代码质量可以考虑approve
- 响应速度很重！  一个工作日内响应
- 始终遵守代码风格指导,减少纷争
### MR的准备
- 尽量写相对较小的mr,避免大的mr
  - 更容易review
  - 更容易合入和回滚
  - 更容易设计
  - 更不容易出错
- 把代码重构的修改拆出来
- MR/commit的描述要规范
  - 第一行做整体清晰的描述
  - 主体有足够的信息量
- 提交review前保证mr的健康度
- Onboardd代码的新功能如果存在风险,可以用flag保护起来
### 关于Review
- 检查每一行代码
- 多方面审查代码(参考内容)
- 响应要及时,能解决很多问题
- Be kind,评论针对代码不针人
- 有大的争议要及时沟通,包括线下沟通,若未能解决由上级仲裁
- 稍后清理？ 要马上清理
- 无伤大雅的建议? Nit:/*comment*/
### 关于性能优化
- 应该坚持的优化:
  - 算法复杂度优化
  - 顺手做的优化
    - 数据结构的选取
    - 避免不必要的拷贝
    - 任何其他不增加复杂度不影响性能和可读性的优化
- 可能需要避免的优化:
  - 过早的伤害代码可读性维护性的优化
  - 对整体性能帮助不大的复杂优化
- 性能敏感的函数/子模块最好加benchmark跟踪起来
### 问答Q&A