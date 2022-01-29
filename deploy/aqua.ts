import { $ } from "https://deno.land/x/zx_deno@1.2.2/mod.mjs";

export async function aqua() {
  await $`curl -sSfL \
  https://raw.githubusercontent.com/aquaproj/aqua-installer/v0.7.0/aqua-installer |
  bash`
}
