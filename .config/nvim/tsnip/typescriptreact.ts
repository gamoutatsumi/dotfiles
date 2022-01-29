import { Snippet } from "https://deno.land/x/tsnip_vim@v0.2/mod.ts";

const state: Snippet = {
  name: "useState",
  text: "const [${1:state}, set${State}] = useState(${2:default_value})",
  params: [
    {
      name: "state",
      type: "single_line",
    },
    {
      name: "default_value",
      type: "single_line",
    },
  ],
  render: ({ state, default_value }) =>
    `const [${state?.text ?? ""}, set${
      state != null
        ? `${state.text?.charAt(0).toUpperCase()}${state.text?.slice(1)}`
        : ""
    }] = useState(${default_value?.text ?? ""})`,
};

export default {
  state
}
