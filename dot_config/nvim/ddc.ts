import {
  BaseConfig,
  ContextBuilder,
} from "https://deno.land/x/ddc_vim@v4.0.5/types.ts";
import { Denops } from "https://deno.land/x/ddc_vim@v4.0.5/deps.ts";

const CONVERTERS = [
  "converter_fuzzy",
  "converter_remove_overlap",
  "converter_truncate_abbr",
];

export class Config extends BaseConfig {
  override config({ contextBuilder, denops }: {
    denops: Denops;
    contextBuilder: ContextBuilder;
  }): Promise<void> {
    contextBuilder.patchGlobal({
      ui: "pum",
      sources: ["denippet", "copilot", "nvim-lsp", "file", "around"],
      keywordPattern: "(\\k|-|_)*",
      filterParams: {
        converter_kind_labels: {
          kindLabels: {
            Text: "",
            Method: "",
            Function: "",
            Constructor: "",
            Field: "",
            Variable: "",
            Class: "",
            Interface: "",
            Module: "",
            Property: "",
            Unit: "",
            Value: "",
            Enum: "",
            Keyword: "",
            Snippet: "",
            Color: "",
            File: "",
            Reference: "",
            Folder: "",
            EnumMember: "",
            Constant: "",
            Struct: "",
            Event: "",
            Operator: "",
            TypeParameter: "",
          },
          kindHlGroups: {
            Method: "Function",
            Function: "Function",
            Constructor: "Function",
            Field: "Identifier",
            Variable: "Identifier",
            Class: "Structure",
            Interface: "Structure",
          },
        },
      },
      autoCompleteEvents: [
        "InsertEnter",
        "TextChangedI",
        "TextChangedP",
        "CmdlineChanged",
      ],
      cmdlineSources: {
        ":": ["cmdline", "cmdline-history", "around"],
        "@": ["around"],
      },
      sourceParams: {
        file: {
          displayFile: "",
          displayDir: "",
        },
        "nvim-lsp": {
          enableAdditionalTextEdit: true,
          enableResolveItem: true,
          confirmBehavior: "replace",
          snippetEngine: (body: string) => denops.call("denippet#anonymous", body),
        },
      },
      sourceOptions: {
        "_": {
          matchers: ["matcher_fuzzy"],
          sorters: ["sorter_ascii", "sorter_fuzzy"],
          converters: CONVERTERS,
        },
        copilot: {
          mark: "[Copilot]",
          matchers: [],
          minAutoCompleteLength: 0,
        },
        "cmdline-history": {
          mark: "[History]",
        },
        "nvim-lsp": {
          mark: "[LSP]",
          ignoreCase: true,
          isVolatile: true,
          converters: [...CONVERTERS, "converter_kind_labels"],
          sorters: ["sorter_ascii", "sorter_fuzzy", "sorter_lsp-kind"],
          dup: "keep",
          keywordPattern: "\\k+",
        },
        around: {
          mark: "[Around]",
          dup: "keep",
          isVolatile: true,
        },
        denippet: {
          mark: "[Denippet]",
          dup: "keep",
          isVolatile: true,
          converters: [...CONVERTERS, "converter_kind_labels"],
          sorters: ["sorter_ascii", "sorter_fuzzy", "sorter_lsp-kind"],
        },
        file: {
          mark: "[File]",
          isVolatile: true,
          forceCompletionPattern: "\\S/\\S*",
          ignoreCase: true,
          dup: "force",
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
