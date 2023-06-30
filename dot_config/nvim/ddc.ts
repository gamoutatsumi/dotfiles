import {
  BaseConfig,
  ContextBuilder,
} from "https://deno.land/x/ddc_vim@v3.5.0/types.ts";
import { Denops } from "https://deno.land/x/ddc_vim@v3.5.0/deps.ts";

export class Config extends BaseConfig {
  override config(args: {
    denops: Denops;
    contextBuilder: ContextBuilder;
  }): Promise<void> {
    args.contextBuilder.patchGlobal({
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
          converters: ["converter_fuzzy"],
        },
        "nvim-lsp": {
          mark: "lsp",
          forceCompletionPattern:
            '\\.\\w*|:\\w*|->\\w*|"\\w*|\\w*|\\+\\w*|/\\w*',
          ignoreCase: true,
          isVolatile: true,
          converters: ["converter_lsp-kinds", "converter_fuzzy"],
          dup: "keep",
        },
        around: {
          mark: "A",
          isVolatile: true,
        },
        vsnip: {
          mark: "VS",
          dup: "keep",
        },
        file: {
          mark: "F",
          isVolatile: true,
          forceCompletionPattern: "\\S/\\S*",
          converters: [],
          ignoreCase: true,
        },
        cmdline: {
          mark: "C",
          ignoreCase: true,
        },
      },
    });
    for (const filetype of ["sql", "mysql", "plsql"]) {
      args.contextBuilder.patchFiletype(filetype, {
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
