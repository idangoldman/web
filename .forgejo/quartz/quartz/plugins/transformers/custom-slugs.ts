import { QuartzTransformerPlugin } from "../types";
import { FullSlug } from "../../util/path";

const Slugs: QuartzTransformerPlugin = () => ({
  name: "Slugs",
  markdownPlugins() {
    return [
      () => async (_tree, file) => {
        const slug = file.data.slug as FullSlug | undefined;
        if (!slug) return;
        console.log("Original slug:", slug);
        if (slug === "home/content") {
          file.data.slug = "index" as FullSlug;
        }
        console.log("Transformed slug:", file.data.slug);

        if (slug.endsWith("/content")) {
          file.data.slug = slug.replace(/\/content$/, "/index") as FullSlug;
        }
      }
    ];
  }
});

export default Slugs;
