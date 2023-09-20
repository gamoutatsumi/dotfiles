import {
  BaseConfig,
  ContextBuilder,
} from "https://deno.land/x/ddu_vim@v3.3.3/types.ts";
import { Denops } from "https://deno.land/x/ddu_vim@v3.3.3/deps.ts";

export class Config extends BaseConfig {
  override config(args: {
    denops: Denops;
    contextBuilder: ContextBuilder;
  }): Promise<void> {
    const { contextBuilder } = args;
    contextBuilder.patchGlobal({
      ui: "ff",
      sourceOptions: {
        _: {
          ignoreCase: true,
          matchers: ["merge"],
          converters: [
            "converter_devicon",
            "converter_hl_dir",
          ],
        },
        mr: {
          matchers: ["matcher_relative", "converter_relativepath", "merge"],
        },
        help: { converters: [] },
        git_diff: {
          converters: [],
        },
        dein_update: {
          matchers: ["matcher_dein_update"],
        },
        lsp_references: {
          converters: ["converter_lsp_symbol"],
        },
        lsp_implementation: {
          converters: ["converter_lsp_symbol"],
        },
        lsp_typeHierarchy: {
          converters: ["converter_lsp_symbol"],
        },
        lsp_callHierarchy: {
          converters: ["converter_lsp_symbol"],
        },
        lsp_workspaceSymbol: {
          converters: ["converter_lsp_symbol"],
        },
        lsp_documentSymbol: {
          converters: ["converter_lsp_symbol"],
        },
        lsp_diagnostic: {
          converters: ["converter_lsp_diagnostic"],
        },
        dein: { defaultAction: "update" },
      },
      uiParams: {
        ff: {
          displayTree: true,
          startFilter: true,
          split: "floating",
          prompt: "> ",
          floatingBorder: "rounded",
          previewFloating: true,
          previewWidth: "round(floor(&columns * 0.8) / 2)",
          previewFloatingTitle: "Preview",
          previewFloatingZindex: 55,
          previewFloatingBorder: "rounded",
          previewSplit: "vertical",
          filterSplitDirection: "floating",
          filterFloatingPosition: "top",
          highlights: {
            floating: "Normal",
            floatingBorder: "Normal",
          },
          winHeight: "floor(&lines * 0.8)",
          winRow: "floor(&lines * 0.1)",
          winWidth: "floor(&columns * 0.8)",
          winCol: "floor(&columns * 0.1)",
          autoResize: true,
          startAutoAction: true,
        },
        filer: {
          split: "floating",
        },
      },
      kindOptions: {
        file: {
          defaultAction: "open",
        },
        ui_select: {
          defaultAction: "select",
        },
        help: {
          defaultAction: "open",
        },
        lsp: {
          defaultAction: "open",
        },
        action: {
          defaultAction: "do",
        },
        dein_update: {
          defaultAction: "viewDiff",
        },
        lsp_codeAction: {
          defaultAction: "apply",
        },
      },
      actionParams: {
        preview_ripgrep: {
          previewCmds: [
            "bat",
            "-n",
            "%s",
            "-r",
            "%b:%e",
            "--highlight-line",
            "%l",
          ],
        },
      },
      filterParams: {
        matcher_kensaku: {
          highlightMatched: "Search",
        },
        matcher_fzf: {
          highlightMatched: "Search",
        },
        merge: {
          filters: [{ name: "matcher_kensaku", weight: 2.0 }, "matcher_fzf"],
          unique: true,
        },
      },
      actionOptions: {
        echo: {
          quit: false,
        },
        echoDiff: {
          quit: false,
        },
      },
    });
    return Promise.resolve();
  }
}
