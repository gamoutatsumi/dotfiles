import { Snippet } from "https://deno.land/x/tsnip_vim@v0.2/mod.ts";

const plugins: Snippet = {
  name: "plugins",
  text: "[[plugins]]\nrepo = '${1:repo}'",
  params: [
    {
      name: "repo",
      type: "single_line",
    },
  ],
  render: ({ repo }) => `[[plugins]]\nrepo='${repo?.text ?? ""}'`,
};

export default {
  plugins
}
