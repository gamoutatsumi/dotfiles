import { TSSnippet } from "https://deno.land/x/denippet_vim@v0.5.5/loader.ts";

export const snippets: Record<string, TSSnippet> = {
  uuid: {
    prefix: "uuid",
    body: () => crypto.randomUUID(),
  },
  date: {
    prefix: "date",
    body: () => new Date().toUTCString(),
  },
};
