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
    const inlineVimrcs = [
      "$BASE_DIR/init/core/vars.vim",
      "$BASE_DIR/init/core/opts.vim",
      "$BASE_DIR/init/core/keys.vim",
    ];
    const hasNvim = args.denops.meta.host === "nvim";
    args.contextBuilder.setGlobal({
      inlineVimrcs,
      extParams: {
        installer: {
          githubAPIToken: Deno.env.get("GITHUB_API_TOKEN"),
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
        "$BASE_DIR/merge.toml",
        hasNvim ? "$BASE_DIR/treesitter.toml" : null,
        hasNvim ? "$BASE_DIR/nvim_dap.toml" : null,
        hasNvim ? "$BASE_DIR/nvim_lsp.toml" : "$BASE_DIR/vim_lsp.toml",
        hasNvim ? null : "$BASE_DIR/vim.toml",
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
              lazy: false,
            },
          },
        ) as Toml,
      );
    }

    for (
      const toml of [
        "$BASE_DIR/lazy.toml",
        "$BASE_DIR/denops.toml",
        "$BASE_DIR/ddc.toml",
        "$BASE_DIR/ddu.toml",
        hasNvim ? "$BASE_DIR/neovim.toml" : null,
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
              lazy: true,
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

    const packSpecPlugins = await args.dpp.extAction(
      args.denops,
      context,
      options,
      "packspec",
      "load",
      {
        basePath: args.basePath,
        plugins: Object.values(recordPlugins),
      },
    ) as Plugin[] | undefined;

    if (packSpecPlugins) {
      for (const plugin of packSpecPlugins) {
        if (plugin.name in recordPlugins) {
          recordPlugins[plugin.name] = Object.assign(
            recordPlugins[plugin.name],
            plugin,
          );
        } else {
          recordPlugins[plugin.name] = plugin;
        }
      }
    }

    const lazyResult = await args.dpp.extAction(
      args.denops,
      context,
      options,
      "lazy",
      "makeState",
      {
        plugins: Object.values(recordPlugins),
      },
    ) as LazyMakeStateResult | undefined;

    return {
      checkFiles: await fn.globpath(
        args.denops,
        Deno.env.get("BASE_DIR"),
        "*",
        1,
        1,
      ) as unknown as string[],
      plugins: lazyResult?.plugins ?? [],
      stateLines: lazyResult?.stateLines ?? [],
      hooksFiles,
      ftplugins,
    };
  }
}
