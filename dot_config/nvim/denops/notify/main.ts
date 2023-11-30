import { assert, Denops, fn, is, notify } from "./deps.ts";

export function main(denops: Denops): Promise<void> {
  denops.dispatcher = {
    async notify(message: unknown): Promise<void> {
      assert(message, is.String);
      new notify.Notification({
        macos: await fn.has(denops, "mac"),
        windows: await fn.has(denops, "win32"),
        linux: await fn.has(denops, "linux"),
      })
        .title("Neovim").body(message).show();
    },
  };
  return Promise.resolve();
}
