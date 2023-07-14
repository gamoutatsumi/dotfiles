import markdownItEmoji from "https://esm.sh/markdown-it-emoji@2.0.2";
import MarkdownIt from "https://esm.sh/markdown-it@13.0.1";

export function createMarkdownRenderer(md: MarkdownIt): MarkdownIt {
  return md.use(markdownItEmoji);
}
