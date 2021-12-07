import { dotfiles } from "./deploy/dotfiles.ts";
import { aqua } from "./deploy/aqua.ts";

if (Deno.build.os === "windows") Deno.exit();

switch (Deno.args[0]) {
  case "dotfiles":
    await dotfiles();
    break;
  case "aqua":
    await aqua();
    break;
  default:
    console.log("Available deployments: dotfiles aqua");
}
