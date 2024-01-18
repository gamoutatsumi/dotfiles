import markdownItEmoji from "https://esm.sh/markdown-it-emoji@3.0.0/";
import MarkdownIt from "https://esm.sh/markdown-it@14.0.0/";

export function createMarkdownRenderer(md: MarkdownIt): MarkdownIt {
  return md.use(markdownItEmoji);
}
