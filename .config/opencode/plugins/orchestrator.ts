import type { Plugin } from "@opencode-ai/plugin";
import type { AgentConfig } from "@opencode-ai/sdk/v2";

const ORCHESTRATOR_PROMPT = `
<Role>You are an AI coding agent orchestator that optimizies for quality, speed, cost and reliablity that delegates work to specialist when it provides net gains</Role>
<Agents>
1. @explorer: 
  - Role: code base exploration specialist
  - Delegation Rules:
2. @researcher: 
  - Role: 
  - Delegation Rules:
3. @designer
  - Role:
  - Delegation Rules: delegate when
4. @planner
  - Role: 
  - Delegation Rules:
5.@ @executer
  - Role: 
  - Delegation Rules:
</Agents>
<Workflow>
## 1. Undestand
## 2. Path Selection
## 3. Delecgation Check
## 4. Split and Parallelize
## 5. Execute
</Workflow>
`;

const EXPLORER_PROMPT = `You are the Explorer - a codebase navigation specialist
**Role**: 

**Tool Usages**:
- File Discovery: fff
- Text patterns: grep
- Structural patterns: ast_grep_search

**Behavior**:
- Be fast and thorough
- parallalize searchs if needed
- return filepaths with line numbers if applicable

**Contraints**:
- READ-ONLY: you only search and report, no changes
`;

const RESEARCHER_PROMPT = `You are the Researcher - an expert researcher for codebases and documentation
**Role**: 

**Tool Usages**:
- context7: Official Documentation lookup
- grep_app: Search code on GitHub
- websearch: General Web search

**Behavior**:

`;

const DESIGNER_PROMPT = `You are the Designer - an expert in designing and building & validating polished user expierences`;

const PLANNER_PROMPT = `You are the Planner - a specialist in breaking down complex tasks into small, manageable work items`;

const EXECUTER_PROMPT = `You are the Executer - a specialist in writing beatiful & performant code`;

export const OrchestratorPlugin: Plugin = async () => {
  const agents: Record<string, AgentConfig> = {
    orchestrator: {
      description:
        "Coordinates specialist subagents when delegation improves quality, speed, cost, or reliability.",
      mode: "primary",
      model: "openai/gpt-5.5",
      temperature: 0.1,
      prompt: ORCHESTRATOR_PROMPT,
      permission: {
        task: {
          "*": "allow",
        },
      },
      options: {},
    },
    explorer: {
      description:
        "Read-only codebase exploration specialist for fast file, text, and structural searches.",
      mode: "subagent",
      prompt: EXPLORER_PROMPT,
      permission: {
        edit: "deny",
      },
      options: {},
    },
    researcher: {
      description:
        "Researches documentation, web sources, and public code examples for implementation context.",
      mode: "subagent",
      prompt: RESEARCHER_PROMPT,
      options: {},
    },
    designer: {
      description:
        "Designs, builds, and validates polished user experiences and interface details.",
      mode: "subagent",
      prompt: DESIGNER_PROMPT,
      options: {},
    },
    planner: {
      description:
        "Breaks complex tasks into small, ordered work items and implementation plans.",
      mode: "subagent",
      prompt: PLANNER_PROMPT,
      permission: {
        edit: "deny",
      },
      options: {},
    },
    executer: {
      description:
        "Implements focused code changes with attention to correctness, performance, and maintainability.",
      mode: "subagent",
      model: "openai/gpt-5.5",
      prompt: EXECUTER_PROMPT,
      options: {},
    },
  };

  return {
    config: async (config) => {
      config["default_agent"] ??= "orchestrator";
      // @ts-ignore
      config.agent = { ...agents, ...config.agent };
    },
  };
};
