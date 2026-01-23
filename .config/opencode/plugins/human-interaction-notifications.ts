import type { Plugin } from "@opencode-ai/plugin";

const escape_script_value = (value: string) =>
  value
    .replace(/\\/g, "\\\\")
    .replace(/"/g, '\\"')
    .replace(/\r/g, " ")
    .replace(/\n/g, " ")
    .replace(/\t/g, " ");

const notify_human_interaction = async (
  $,
  message: string,
  title = "OpenCode needs your input",
) => {
  const safe_message = escape_script_value(message);
  const safe_title = escape_script_value(title);
  const script = `display notification "${safe_message}" with title "${safe_title}"`;
  await $`osascript -e ${script}`;
};

const format_message = (event: Record<string, unknown>) => {
  if (event.type === "permission.updated") {
    const permission = event.permission as Record<string, unknown> | undefined;
    const action =
      (permission?.action as string | undefined) ||
      (permission?.tool as string | undefined) ||
      "permission request";
    return `Action required: ${action}`;
  }

  if (event.type === "session.error") {
    return "Session error - review OpenCode";
  }

  if (event.type === "session.status") {
    const status = event.status as string | undefined;
    if (status === "waiting" || status === "blocked") {
      return "Session waiting for input";
    }
    if (
      status === "idle" ||
      status === "completed" ||
      status === "done" ||
      status === "success"
    ) {
      return "Session idle - review output";
    }
  }

  return null;
};

const is_human_interaction_event = (event: Record<string, unknown>) => {
  if (event.type === "permission.updated") {
    const permission = event.permission as Record<string, unknown> | undefined;
    const status = permission?.status as string | undefined;
    return (
      status === "requested" || status === "pending" || status === "waiting"
    );
  }

  if (event.type === "session.error") {
    return true;
  }

  if (event.type === "session.status") {
    const status = event.status as string | undefined;
    return (
      status === "waiting" ||
      status === "blocked" ||
      status === "idle" ||
      status === "completed" ||
      status === "done" ||
      status === "success"
    );
  }

  return false;
};

export const NotificationsPlugin: Plugin = async ({ $ }) => {
  return {
    event: async ({ event }) => {
      if (!is_human_interaction_event(event)) {
        return;
      }

      const message = format_message(event);
      if (!message) {
        return;
      }

      await notify_human_interaction($, message);
    },
  };
};
