import {
  ActionArguments,
  ActionFlags,
  BaseConfig,
  ContextBuilder,
} from "https://deno.land/x/ddu_vim@v4.1.0/types.ts";
import { Denops } from "https://deno.land/x/ddu_vim@v4.1.0/deps.ts";
import * as stdpath from "jsr:@std/path@0.225.1";
import * as u from "jsr:@core/unknownutil@3.18.1";
import { ActionData as GitStatusActionData } from "https://raw.githubusercontent.com/kuuote/ddu-source-git_status/main/denops/%40ddu-kinds/git_status.ts";

type Never = Record<never, never>;

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
          converters: ["converter_devicon", "converter_hl_dir"],
        },
        mr: {
          matchers: ["matcher_relative", "converter_relativepath", "merge"],
        },
        help: { converters: [] },
        git_diff: {
          converters: [],
        },
        git_status: {
          converters: [
            "converter_hl_dir",
            "converter_git_status",
          ],
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
      },
      uiParams: {
        ff: {
          displayTree: true,
          split: "horizontal",
          prompt: "> ",
          previewWidth: "round(floor(&columns * 0.8) / 2)",
          previewSplit: "vertical",
          autoResize: true,
          startAutoAction: true,
        },
        filer: {
          split: "floating",
        },
      },
      kindOptions: {
        "ai-review-request": {
          defaultAction: "open",
        },
        "ai-review-log": {
          defaultAction: "resume",
        },
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
        lsp_codeAction: {
          defaultAction: "apply",
        },
        git_status: {
          actions: {
            // show diff of file
            // using https://github.com/kuuote/ddu-source-git_diff
            // example:
            //   call ddu#ui#do_action('itemAction', #{name: 'diff'})
            //   call ddu#ui#do_action('itemAction', #{name: 'diff', params: #{cached: v:true}})
            diff: async (args) => {
              const action = args.items[0].action as GitStatusActionData;
              const path = stdpath.join(action.worktree, action.path);
              await args.denops.call("ddu#start", {
                name: "file:git_diff",
                sources: [
                  {
                    name: "git_diff",
                    options: {
                      path,
                    },
                    params: {
                      ...(u.maybe(args.actionParams, u.isRecord) ?? {}),
                      onlyFile: true,
                    },
                  },
                ],
              });
              return ActionFlags.None;
            },
            // fire GinPatch command to selected items
            // using https://github.com/lambdalisue/vim-gin
            patch: async (args: ActionArguments<Never>) => {
              for (const item of args.items) {
                const action = item.action as GitStatusActionData;
                await args.denops.cmd("tabnew");
                await args.denops.cmd("tcd " + action.worktree);
                await args.denops.cmd("GinPatch ++no-head " + action.path);
              }
              return ActionFlags.None;
            },
          },
          defaultAction: "open",
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
