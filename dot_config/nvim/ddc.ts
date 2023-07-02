import {
  BaseConfig,
  ContextBuilder,
} from "https://deno.land/x/ddc_vim@v3.8.1/types.ts";
import { Denops } from "https://deno.land/x/ddc_vim@v3.8.1/deps.ts";

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
          confirmBehavior: "insert",
        },
      },
      sourceOptions: {
        "_": {
          matchers: ["matcher_fuzzy"],
          sorters: ["sorter_fuzzy"],
          converters: CONVERTERS,
        },
        "cmdline-history": {
          mark: "[History]",
        },
        "nvim-lsp": {
          mark: "[LSP]",
          forceCompletionPattern:
            '\\.\\w*|:\\w*|->\\w*|"\\w*|\\w*|\\+\\w*|/\\w*',
          ignoreCase: true,
          isVolatile: true,
          converters: ["converter_lsp-kinds", ...CONVERTERS],
          dup: "keep",
          keywordPattern: "\\k*",
        },
        around: {
          mark: "[Around]",
          dup: "keep",
          isVolatile: true,
        },
        vsnip: {
          mark: "[VSnip]",
          dup: "keep",
          isVolatile: true,
          converters: ["converter_lsp-kinds", ...CONVERTERS],
        },
        file: {
          mark: "[File]",
          isVolatile: true,
          forceCompletionPattern: "\\S/\\S*",
          ignoreCase: true,
          dup: "keep",
        },
        cmdline: {
          mark: "[Cmd]",
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
