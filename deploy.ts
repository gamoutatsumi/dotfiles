import { dotfiles } from "./deploy/dotfiles.ts";

if (Deno.build.os === "windows") Deno.exit();

switch (Deno.args[0]) {
  case "dotfiles":
    await dotfiles();
    break;
  default:
    console.log("Available deployments: dotfiles");
}
