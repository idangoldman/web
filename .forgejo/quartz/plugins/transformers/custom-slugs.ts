import { QuartzTransformerPlugin } from "../types";
import { FullSlug } from "../../util/path";

export const CustomSlugs: QuartzTransformerPlugin = () => ({
  name: "CustomSlugs",
  markdownPlugins() {
    return [
      () => async (_tree, file) => {
        const slug = file.data.slug as FullSlug | undefined;
        if (!slug) return;

        if (slug.endsWith("/content")) {
          file.data.slug = slug.replace(/\/content$/, "/index") as FullSlug;
        }
      }
    ];
  }
});
