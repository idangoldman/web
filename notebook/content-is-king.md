---
title: 'Content is King'
date: '2026-05-12T00:00:00+03:00'
description: 'For years, I wanted a way to write and just post the damn thing…'
draft: true
---

For years, I wanted a way to write and just post the damn thing… which got me blocked from writing again and again while trying to build the damn thing.

Now, I’m trying a new thing (for me), writing about how to build the damn thing while building the damn thing, dog feeding myself if you will.

So… my current thesis is focus on content and keep everything else to a minimum.

## Focus on Content

> *Write > Publish > Read*

Pretty simple isn’t it? While it looks like any other flow of SSG there is, my peace of mind lies in the details of keeping plumbing code out of the content git repository. Let me explain what I mean by that.

In any other SSG setup, the codebase main in center and the content is just a folder that plays its part. I don’t like that because it takes my focus from writing the content into maintaining the codebase as any other ADHD developer would.

This time, content files are the main focus as they always should have been while the code setup files sit in a hidden (dot) folder at the top of the git repository. That way when I open the main folder in any editor the content right there and not in a side folder couple of clicks down.

## How it looks

```shell
web/
├── .forgejo/
├── about.md
├── home.md
└── notebook/
    ├── april-fools-beginning.md
    ├── i-want-to-tell-you-a-story.md
    ├── month-of-flying-by.md
    ├── public-beta-is-out/
    │   ├── content.md
    │   ├── staticpage-logo.png
    │   └── staticpage-landing-page.png
    ├── ready-to-go-full-time.md
    ├── …
└── studio.md
```

Well, what do you think? For my eyes the codebase clutter is gone and all I left with is structured content of files and folders translated into web paths with some underneath code plumbing like:

- `about.md` becomes `/about/index.html`
- `home.md` becomes `/index.html`
- `notebook/` redirects to`/`, because it has no `content.md` file
- `content.md` files inside folders becomes `index.html`
- Any media files (like images) related to piece of content live beside it in a folder titled by that piece of content.

## How it works

The hidden piece of code plumbing (magic) done inside `.forgejo` folder. Take a look:

```shell
web/
├── .forgejo/
│   ├── workflows/
│   │   ├── build.yml
│   │   └── deploy.yml
│   └── quartz/
│       └── custom.scss
│       ├── quartz.config.ts
│       ├── quartz.layout.ts
```

So, what do we got here? `workflows` and `quartz` folders, one for building and deploying the content you read on this website and the other for configuration and customization of this website.

### Why Forgejo and Quartz?

- **Forgejo** is easy, I’m already enjoy using it as my self-hosted git server and action runner. It runs blazing fast (in my set up) and has a snappy web ui which helps.
- **Quartz**… don’t know yet, will see. Seems like it’s made for generating websites out of *Obsidian* like content folders and comes with supporting plugins to keep same content structures on the web.

## Workflows

Last part in this piece of content before I jump into proving my thesis right, is how it all actually comes together from writing a piece of content through publishing and reading it on this website. The best way for me to explain is by a flowchart. So, here it is:

```mermaid
flowchart TD
A[“✍️ Write Content”]:::write –> B[“📂 Save Changes”]:::action

subgraph pipeline ["Automatic Pipeline"]
    direction TB
    C{"🔍 Were any\ncontent files\nchanged?"}:::decision
    C -->|No| D["⏹️ Nothing to do"]:::skip
    C -->|Yes| E["📋 What changed?"]:::action

    E --> F["➕ New file"]:::change
    E --> G["✏️ Edited file"]:::change
    E --> H["🗑️ Removed file"]:::change
    E --> I["📛 Moved / renamed file"]:::change

    F --> J{"Marked as\npublished?"}:::decision
    G --> K{"Marked as\npublished?"}:::decision
    I --> L{"Marked as\npublished?"}:::decision

    J -->|Yes| M["Add to website"]:::publish
    J -->|No| N["Skip, it's a draft"]:::skip

    K -->|Yes| O["Update on website"]:::publish
    K -->|No| P["Remove from website"]:::remove

    H --> Q["Remove from website"]:::remove

    L -->|Yes| R["Remove old location\nAdd new location"]:::publish
    L -->|No| S["Remove old location"]:::remove

    M --> T["📦 Get current\nwebsite version"]:::action
    N --> T
    O --> T
    P --> T
    Q --> T
    R --> T
    S --> T

    T --> U["🔧 Rebuild website\nwith all changes applied"]:::build
    U --> V["🏷️ Save new\nwebsite version"]:::action
end

B --> C
V --> W["🚀 Publish website"]:::deploy
W --> X["🌐 Live at\nidan.goldman.work"]:::live

classDef write fill:#4a9eff,stroke:#2d7cd6,color:#fff
classDef action fill:#6c757d,stroke:#545b62,color:#fff
classDef decision fill:#ffc107,stroke:#d4a106,color:#333
classDef skip fill:#dc3545,stroke:#b02a37,color:#fff
classDef change fill:#6c757d,stroke:#545b62,color:#fff
classDef publish fill:#198754,stroke:#13653f,color:#fff
classDef remove fill:#dc3545,stroke:#b02a37,color:#fff
classDef build fill:#6f42c1,stroke:#5a32a3,color:#fff
classDef deploy fill:#198754,stroke:#13653f,color:#fff
classDef live fill:#0dcaf0,stroke:#0aa2c0,color:#333
```

### Steps

The flowchart above can be summarized by the following steps:

1. Write (add/edit/delete) pieces of content
2. Save (commit) them into the git repository
3. Push changes to the git repository on *Forgejo*.
4. Build workflow decides if the changes are valid for a new website version and generates one or does nothing
5. Deploy workflow detects a new website version and deploys it to Cloudflare Page

## The End

…and that is it folks, thank you for reading! See you next time.
