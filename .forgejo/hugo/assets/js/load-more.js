(() => {
  const nav = document.querySelector(".pagination.load-more");
  const btn = nav?.querySelector(".page-link");
  const LIST_SELECTOR = '[class^="article-list"]';
  const list = document.querySelector(LIST_SELECTOR);
  if (!nav || !btn || !list) return;

  async function fetchPage(url) {
    const res = await fetch(url, { headers: { Accept: "text/html" } });
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    return new DOMParser().parseFromString(await res.text(), "text/html");
  }

  btn.addEventListener("click", async (event) => {
    event.preventDefault();
    const url = btn.dataset.nextUrl;
    if (!url || btn.dataset.loading === "true") return;

    btn.dataset.loading = "true";
    btn.setAttribute("aria-busy", "true");

    try {
      const doc = await fetchPage(url);
      list.append(...doc.querySelectorAll(`${LIST_SELECTOR} > article`));

      const nextUrl = doc.querySelector(".pagination.load-more .page-link")?.dataset.nextUrl;
      if (nextUrl) {
        btn.dataset.nextUrl = nextUrl;
        btn.href = nextUrl;
      } else {
        nav.remove();
      }
    } catch (err) {
      console.error("Load more failed:", err);
      btn.dataset.error = "true";
    } finally {
      btn.dataset.loading = "false";
      btn.removeAttribute("aria-busy");
    }
  });
})();
