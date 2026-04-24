import { Plugin } from "@opencode-ai/plugin";
import { execFileSync } from "node:child_process";
import { writeFileSync } from "node:fs";

const escapeOscField = (value: string) =>
  value.replace(/[\x00-\x1f\x7f;]/g, " ").trim();

const getTmuxClientTty = () => {
  if (!process.env.TMUX_PANE) {
    return;
  }

  try {
    return execFileSync(
      "tmux",
      ["display-message", "-p", "-t", process.env.TMUX_PANE, "#{client_tty}"],
      { encoding: "utf8" },
    ).trim();
  } catch {
    return;
  }
};

const writeTerminal = (value: string) => {
  const targets = [getTmuxClientTty(), "/dev/tty"];

  for (const target of targets) {
    if (!target) {
      continue;
    }

    try {
      writeFileSync(target, value);
      return;
    } catch {
      // Try the next available terminal target.
    }
  }

  process.stdout.write(value);
};

const notifyTmux = (message: string) => {
  if (!process.env.TMUX_PANE) {
    return;
  }

  try {
    execFileSync("tmux", ["display-message", "-t", process.env.TMUX_PANE, message]);
  } catch {
    // Desktop notification still works without tmux status feedback.
  }
};

const notifyTerminal = (title: string, body: string) => {
  const sequence = `\x1b]777;notify;${escapeOscField(title)};${escapeOscField(body)}\x07`;
  writeTerminal(sequence);
};

export const NotificationPlugin: Plugin = async ({ client }) => {
  return {
    event: async ({ event }) => {
      if (event.type === "session.idle") {
        const session = await client.session.get({
          path: { id: event.properties.sessionID },
        });
        const title = session.data?.title?.trim();
        const notificationTitle = title ? `opencode: ${title}` : "opencode";

        notifyTerminal(notificationTitle, "Session completed");
        notifyTmux(`${notificationTitle}: Session completed`);
      }
    },
  };
};
