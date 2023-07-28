import { Snippet } from "https://deno.land/x/tsnip_vim@v0.5/mod.ts";

const reftypes: Snippet = {
  name: "referenceTypes",
  text: '/// <reference types="${1:module}" />',
  params: [
    {
      name: "module",
      type: "single_line",
    },
  ],
  render: ({ module }) => `/// <reference types="${module?.text ?? ""}" />`,
};

export default {
  reftypes,
};
