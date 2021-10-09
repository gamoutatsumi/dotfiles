import { join } from "https://deno.land/std@0.110.0/path/mod.ts";
import { $ } from "https://deno.land/x/zx_deno@1.2.2/mod.mjs";

const DOT_DIRECTORY = join((Deno.env.get("HOME") ?? "/root"), "dotfiles");

export async function getEntries(currentPath: string): Promise<string[]> {
  const entries: string[] = [];

  for await (const dirEntry of Deno.readDir(currentPath)) {
    const entryPath = join(currentPath, dirEntry.name);
    switch (dirEntry.name) {
      case ".git":
      case ".gitignore":
      case ".github":
      case "deploy.ts":
      case "deploy":
        continue;
      case ".hammerspoon":
        if (Deno.build.os !== "darwin") {
          continue;
        }
    }
    if (dirEntry.isDirectory) {
      if (dirEntry.name === ".config") {
        entries.push(...await getEntries(entryPath));
        continue;
      }
      if (entryPath.match(/^.*systemd.*$/)) {
        entries.push(...await getEntries(entryPath));
        continue;
      }
    }
    entries.push(entryPath);
  }
  return entries;
}

export async function dotfiles() {
  const entries = await getEntries(DOT_DIRECTORY);
  for await (const entry of entries) {
    const dest = entry.replace(/dotfiles\//, "");
    await $`ln -snfv ${entry} ${dest}`;
  }
  console.log(`completed.`);
}
