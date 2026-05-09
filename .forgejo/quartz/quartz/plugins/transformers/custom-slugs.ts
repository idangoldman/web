import { QuartzTransformerPlugin } from "../types";
import { FullSlug } from "../../util/path";

const Slugs: QuartzTransformerPlugin = () => ({
  name: "Slugs",
  markdownPlugins() {
    return [
      () => async (_tree, file) => {
        const slug = file.data.slug as FullSlug | undefined;
        if (!slug) return;

        if (slug === "/home/content") {
          file.data.slug = "index" as FullSlug;
        }

        if (slug.endsWith("/content")) {
          file.data.slug = slug.replace(/\/content$/, "/index") as FullSlug;
        }
      }
    ];
  }
});

export default Slugs;
