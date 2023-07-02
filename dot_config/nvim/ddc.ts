import {
  BaseConfig,
  ContextBuilder,
} from "https://deno.land/x/ddc_vim@v3.5.0/types.ts";
import { Denops } from "https://deno.land/x/ddc_vim@v3.5.0/deps.ts";

const CONVERTERS = [
  "converter_fuzzy",
  "converter_remove_overlap",
  "converter_truncate_abbr",
];

export class Config extends BaseConfig {
  override config({ contextBuilder }: {
    denops: Denops;
    contextBuilder: ContextBuilder;
  }): Promise<void> {
    contextBuilder.patchGlobal({
      ui: "pum",
      sources: ["tsnip", "vsnip", "nvim-lsp", "file", "around"],
      keywordPattern: "(\\k|-|_)*",
      autoCompleteEvents: [
        "InsertEnter",
        "TextChangedI",
        "TextChangedP",
        "CmdlineChanged",
      ],
      cmdlineSources: {
        ":": ["cmdline", "cmdline-history", "around"],
      },
      sourceParams: {
        vsnip: {
          menu: false,
        },
        file: {
          displayFile: "",
          displayDir: "",
        },
        "nvim-lsp": {
          enableAdditionalTextEdit: true,
          enableResolveItem: true,
          confirmBehavior: "replace",
        },
      },
      sourceOptions: {
        "_": {
          matchers: ["matcher_fuzzy"],
          sorters: ["sorter_fuzzy"],
          converters: CONVERTERS,
        },
        "nvim-lsp": {
          mark: "lsp",
          forceCompletionPattern:
            '\\.\\w*|:\\w*|->\\w*|"\\w*|\\w*|\\+\\w*|/\\w*',
          ignoreCase: true,
          isVolatile: true,
          converters: ["converter_lsp-kinds", ...CONVERTERS],
          dup: "keep",
        },
        around: {
          mark: "A",
          isVolatile: true,
        },
        vsnip: {
          mark: "VS",
          dup: "keep",
          isVolatile: true,
          converters: ["converter_lsp-kinds", ...CONVERTERS],
        },
        file: {
          mark: "F",
          isVolatile: true,
          forceCompletionPattern: "\\S/\\S*",
          ignoreCase: true,
        },
        cmdline: {
          mark: "C",
          ignoreCase: true,
        },
      },
    });
    for (const filetype of ["sql", "mysql", "plsql"]) {
      contextBuilder.patchFiletype(filetype, {
        sources: ["omni"],
        sourceOptions: {
          omni: {
            forceCompletionPattern: '\\w+|\\.|"|\\[|`',
            mark: "O",
          },
        },
        sourceParams: {
          omni: {
            omnifunc: "vim_dadbod_completion#omni",
          },
        },
      });
    }
    return Promise.resolve();
  }
}
