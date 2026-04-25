import { Plugin } from "@opencode-ai/plugin";
import { Agent } from "@opencode-ai/sdk/v2";

export const OrchestratorPlugin: Plugin = async (ctx) => {
  const agents: Record<string, Agent> = {
    orchestrator: {
      name: "orchestrator",
      mode: "primary",
      model: { providerID: "openai", modelID: "gpt-5.5" },
      temperature: 0.1,
      prompt: "orchestrator PROMPT TODO",
      permission: [],
      options: {},
    },
    explorer: {},
    researcher: {},
    designer: {},
    planner: {},
    executer: {},
  };

  return {
    name: "orchestrator",
    agent: agents,
    config: async (config) => {
      config["default_agent"] ??= "orchestrator";
    },
  };
};
