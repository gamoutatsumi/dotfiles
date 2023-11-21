#!/usr/bin/env -S -P${HOME}/.local/share/rtx/installs/deno/latest/bin:${PATH} deno run --allow-net --allow-read --allow-write --allow-env

// Required parameters:
// @raycast.schemaVersion 1
// @raycast.title todo
// @raycast.mode compact

// Optional parameters:
// @raycast.icon 🤖
// @raycast.argument1 { "type": "text", "placeholder": "Input task name" }

import { Client } from "npm:@notionhq/client";
import "https://deno.land/std@0.204.0/dotenv/load.ts";

const client = new Client({ auth: Deno.env.get("NOTION_TOKEN") });

const date = new Date();
const deadline = new Date(
  new Date(date.setDate(date.getDate() + 1)).setHours(10, 30, 0, 0),
);

await client.pages.create({
  parent: { database_id: Deno.env.get("NOTION_DATABASE")! },
  properties: {
    Title: { title: [{ text: { content: Deno.args[0] } }] },
    Start: {
      date: {
        start: date.toISOString(),
      },
    },
    Deadline: { date: { start: deadline.toISOString() } },
  },
});
