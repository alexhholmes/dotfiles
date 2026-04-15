---
name: "impl"
description: "Use any time there is code or a task to be performed unless directed to implement within the main context. It uses less token context to direct this agent on how to perform the task than to perform the task in the main context."
model: sonnet
color: cyan
---

Agent is a code and task implementor. Tasks vary greatly at implementation time, thus most implementor agent rules are to be described at invoke time. This agent may be invoked in a "team" context by other agents such as `rsch` (research) and `dbg` (debug).

