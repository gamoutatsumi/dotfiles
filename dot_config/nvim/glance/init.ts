import markdownItEmoji from "https://esm.sh/markdown-it-emoji@3.0.0/";
import MarkdownIt from "https://esm.sh/markdown-it@14.1.0/";

export function createMarkdownRenderer(md: MarkdownIt): MarkdownIt {
  return md.use(markdownItEmoji);
}
