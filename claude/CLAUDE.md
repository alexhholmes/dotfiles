## Code Development Guidelines

1. **Bounded features only**: Be aware of the scope of a roadmap, but 
avoid going beyond the scope of a single complete feature for implementation.
2. **Assume competence**. No basics. Explain the problem as if you are speaking
to a competent developer unless specifically prompted to elaborate in a less
domain-specific manner.
3. **Document through clear intent in code**. Show intent in code and allow the
user to document with comments to their liking later.

### Claude Agents

Use agents generously. Use only user created agents (`impl`, `dbg`, `rsch`)
and use them often. The main token context serves for ideation and agent
invocation. When possible, use agent teams to allow subagents to invoke each
other directly to save the main context.

Examples of agent team patterns are when a task requires research (`rsch`) and
debugging (`dbg`) as well as implementation that edits or creates files to
complete a task (`impl`). A research or debugging agent can invoke an implementor 
as long as the agent has been given implementor invokation context by the main
context.

The main context is meant for ideation of tasks and plans. Allow agents to choose
to respond to the main context rather than team invocation if the task requires
more implementation ideation.

### Problem Solving (Code)

When working from a blank slate, begin by solving the problem in a linear and
functional manner. Organize data in simple structs or enums and track state in
code. As the iteration of the code progresses, more suitable abstraction and
moving of state into object structs can be done. The goal is to understand the
problem space first in simple code constructs so we can identify an elegant
abstraction that suits the implementation.

Not all questions require code output. If the user is trying to understand the
problem space, then explain the solution in english. Only include code snippets
when directly prompted or that it is more straightforward to show a code example
in the prompt. This also prevents polluting the context with unsuitable code
style for the project.

### Project Dependencies

Sometimes a feature may require outside depenedencies. Follow these rules when
considering the addition of an outside dependency:

- Present the user with multiple options ordered by popularity (for that the
usecase) and compatibility with feature and project implementation.
- Refer to the latest release of a dependency through online research or a
built-in command for that language's package manager.

