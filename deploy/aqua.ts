import { $ } from "https://deno.land/x/dzx@0.3.0/mod.ts";

export async function aqua() {
  console.log(
    await $`curl -sSfL \
  https://raw.githubusercontent.com/aquaproj/aqua-installer/v0.7.0/aqua-installer |
  bash`,
  );
}
