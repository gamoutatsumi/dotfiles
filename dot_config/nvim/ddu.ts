import {
  BaseConfig,
  ContextBuilder,
} from "https://deno.land/x/ddu_vim@v3.0.0/types.ts";
import { Denops, op } from "https://deno.land/x/ddu_vim@v3.0.0/deps.ts";

export class Config extends BaseConfig {
  override async config(args: {
    denops: Denops;
    contextBuilder: ContextBuilder;
  }): Promise<void> {
    const columns = await op.columns.get(args.denops);
    const lines = await op.lines.get(args.denops);
    const width = Math.floor(columns * 0.8);
    args.contextBuilder.patchGlobal({
      ui: "ff",
      sync: true,
      sourceOptions: {
        _: {
          ignoreCase: true,
          matchers: ["merge"],
          converters: ["converter_devicon"],
        },
      },
      uiParams: {
        ff: {
          startFilter: true,
          split: "floating",
          prompt: "> ",
          floatingBorder: "rounded",
          previewFloating: true,
          previewWidth: Math.round(width / 2),
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
          winHeight: Math.floor(lines * 0.8),
          winRow: Math.floor(lines * 0.1),
          winWidth: width,
          winCol: Math.floor(columns * 0.1),
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
        nvim_lsp: {
          defaultAction: "open",
        },
        action: {
          defaultAction: "do",
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
          filters: [
            { name: "matcher_kensaku", weight: 2.0 },
            "matcher_fzf",
          ],
          unique: true,
        },
      },
    });
  }
}
