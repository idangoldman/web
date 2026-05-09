import { PageLayout, SharedLayout } from "./quartz/cfg";
import * as Component from "./quartz/components";
import CustomFooter from "./quartz/components/CustomFooter"

// Components shared across all pages: head, header, footer
export const sharedPageComponents: SharedLayout = {
  head: Component.Head(),
  header: [],
  afterBody: [],
  footer: CustomFooter({
    links: {
      GitHub: "https://github.com/idangoldman",
      LinkedIn: "https://www.linkedin.com/in/idangoldman/",
      RSS: "/index.xml",
    }
  })
};

// Layout for content pages (your notebook posts, /about, /studio)
export const defaultContentPageLayout: PageLayout = {
  beforeBody: [Component.Breadcrumbs(), Component.ArticleTitle(), Component.ContentMeta(), Component.TagList()],
  left: [
    Component.PageTitle(),
    Component.MobileOnly(Component.Spacer()),
    Component.Flex({
      components: [{ Component: Component.Search(), grow: true }, { Component: Component.Darkmode() }]
    }),
    Component.DesktopOnly(
      Component.Explorer({
        folderClickBehavior: "link",
        folderDefaultState: "open",
        useSavedState: true,
        // Only show the notebook folder in the sidebar — hide top-level pages like about/studio
        filterFn: (node) => node.slugSegment !== "tags",
        mapFn: (node) => {
          if (node.isFolder && node.children.length === 0 && node.data) {
            node.isFolder = false
          }
        }
      })
    )
  ],
  right: [Component.DesktopOnly(Component.TableOfContents()), Component.Backlinks()]
};

// Layout for folder listings and tag pages
export const defaultListPageLayout: PageLayout = {
  beforeBody: [Component.Breadcrumbs(), Component.ArticleTitle(), Component.ContentMeta()],
  left: [
    Component.PageTitle(),
    Component.MobileOnly(Component.Spacer()),
    Component.Flex({
      components: [{ Component: Component.Search() }, { Component: Component.Darkmode() }]
    })
  ],
  right: []
};
