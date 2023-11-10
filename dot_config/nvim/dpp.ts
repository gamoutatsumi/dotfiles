import {
  BaseConfig,
  ConfigReturn,
  ContextBuilder,
  Dpp,
  Plugin,
} from "https://deno.land/x/dpp_vim@v0.0.7/types.ts";
import { Denops, fn } from "https://deno.land/x/dpp_vim@v0.0.7/deps.ts";
import { is } from "https://deno.land/x/unknownutil@v3.10.0/mod.ts";

export class Config extends BaseConfig {
  override async config(args: {
    denops: Denops;
    contextBuilder: ContextBuilder;
    basePath: string;
    dpp: Dpp;
  }): Promise<ConfigReturn> {
    const hasNvim = args.denops.meta.host === "nvim";
    args.contextBuilder.setGlobal({
      extParams: {
        installer: {
          checkDiff: true,
        },
      },
      protocols: ["git"],
    });

    type Toml = {
      hooks_file?: string | string[];
      ftplugins?: Record<string, string>;
      plugins?: Plugin[];
    };

    type LazyMakeStateResult = {
      plugins: Plugin[];
      stateLines: string[];
    };

    const [context, options] = await args.contextBuilder.get(args.denops);

    const tomls: Toml[] = [];

    for (
      const toml of [
        "$BASE_DIR/dpp.toml",
        "$BASE_DIR/dpp_lazy.toml",
        "$BASE_DIR/denops.toml",
        "$BASE_DIR/ddc.toml",
        "$BASE_DIR/ddu.toml",
        hasNvim ? "$BASE_DIR/treesitter.toml" : null,
        hasNvim ? "$BASE_DIR/nvim_dap.toml" : null,
        hasNvim ? "$BASE_DIR/nvim_lsp.toml" : "$BASE_DIR/vim_lsp.toml",
        hasNvim ? "$BASE_DIR/neovim.toml" : "$BASE_DIR/vim.toml",
      ].filter(is.String)
    ) {
      tomls.push(
        await args.dpp.extAction(
          args.denops,
          context,
          options,
          "toml",
          "load",
          {
            path: toml,
            options: {
              lazy: toml.includes("lazy"),
            },
          },
        ) as Toml,
      );
    }

    const recordPlugins: Record<string, Plugin> = {};
    const ftplugins: Record<string, string> = {};
    const hooksFiles: string[] = [];

    tomls.forEach((toml) => {
      for (const plugin of toml.plugins ?? []) {
        recordPlugins[plugin.name] = plugin;
      }

      if (toml.ftplugins) {
        for (const filetype of Object.keys(toml.ftplugins)) {
          if (ftplugins[filetype]) {
            ftplugins[filetype] += `\n${toml.ftplugins[filetype]}`;
          } else {
            ftplugins[filetype] = toml.ftplugins[filetype];
          }
        }
      }

      if (toml.hooks_file) {
        if (is.Array(toml.hooks_file)) {
          hooksFiles.push(...toml.hooks_file);
        } else {
          hooksFiles.push(toml.hooks_file);
        }
      }
    });

    const lazyResult = await args.dpp.extAction(
      args.denops,
      context,
      options,
      "lazy",
      "makeState",
      {
        plugins: Object.values(recordPlugins),
      },
    ) as LazyMakeStateResult;

    return {
      checkFiles: await fn.globpath(
        args.denops,
        Deno.env.get("BASE_DIR"),
        "*",
        1,
        1,
      ) as unknown as string[],
      plugins: lazyResult.plugins,
      stateLines: lazyResult.stateLines,
      hooksFiles,
      ftplugins,
    };
  }
}
