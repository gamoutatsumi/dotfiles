import {
  BaseConfig,
  ConfigReturn,
  ContextBuilder,
  Dpp,
  Plugin,
} from "https://deno.land/x/dpp_vim@v0.0.7/types.ts";
import {
  convert2List,
  parseHooksFile,
} from "https://deno.land/x/dpp_vim@v0.0.7/utils.ts";
import { Denops } from "https://deno.land/x/dpp_vim@v0.0.7/deps.ts";
import {
  assert,
  ensure,
  is,
} from "https://deno.land/x/unknownutil@v3.10.0/mod.ts";
import { joinGlobs } from "https://deno.land/std@0.205.0/path/mod.ts";

async function fennelCompile(denops: Denops, text: string): Promise<string> {
  const compiled = await denops.call(
    "luaeval",
    `require'fennel'.install().compileString(_A)`,
    text.trim(),
  );
  assert(compiled, is.String);

  return compiled;
}

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
    const plugins = await Promise.all(
      Object.values(recordPlugins).map(async (plugin) => {
        for (const hooksFile of convert2List(plugin.hooks_file)) {
          const hooksFilePath = await args.denops.call(
            "dpp#util#_expand",
            hooksFile,
          ) as string;
          const hooksFileLines = (await Deno.readTextFile(hooksFilePath)).split(
            "\n",
          );

          const hooks = parseHooksFile(options.hooksFileMarker, hooksFileLines);
          plugin = Object.assign(plugin, hooks);
        }
        plugin.hooks_file = undefined;
        return plugin;
      }),
    );

    const compiledPlugins = await Promise.all(plugins.map(async (plugin) => {
      if (!plugin.ftplugin) {
        return plugin;
      }
      if (is.String(plugin.ftplugin.fennel_add)) {
        plugin.lua_add = await fennelCompile(
          args.denops,
          plugin.ftplugin.fennel_add,
        );
        delete plugin.ftplugin.fennel_add;
      }
      if (is.String(plugin.ftplugin.fennel_source)) {
        plugin.lua_source = await fennelCompile(
          args.denops,
          plugin.ftplugin.fennel_source,
        );
        delete plugin.ftplugin.fennel_source;
      }
      if (is.String(plugin.ftplugin.fennel_post_source)) {
        plugin.lua_post_source = await fennelCompile(
          args.denops,
          plugin.ftplugin.fennel_post_source,
        );
        delete plugin.ftplugin.fennel_post_source;
      }
      return plugin;
    }));

    const lazyResult = await args.dpp.extAction(
      args.denops,
      context,
      options,
      "lazy",
      "makeState",
      {
        plugins: compiledPlugins,
      },
    ) as LazyMakeStateResult | undefined;

    return {
      checkFiles: joinGlobs(
        [
          ensure(Deno.env.get("BASE_DIR"), is.String),
          "*",
        ],
      ) as unknown as string[],
      plugins: lazyResult?.plugins ?? [],
      stateLines: lazyResult?.stateLines ?? [],
      ftplugins,
    };
  }
}
