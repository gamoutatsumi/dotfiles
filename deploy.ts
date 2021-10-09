import { dotfiles } from "./deploy/dotfiles.ts";

if (Deno.build.os === "windows") Deno.exit();

switch (Deno.args[0]) {
  case "dotfiles":
    await dotfiles()
    Deno.exit(0)
  default:
    const msg = `Available deployments: dotfiles`
    console.log(msg)
    Deno.exit(0)
}
