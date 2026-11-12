# Credits

Everything stored in this repository is original work, released under the MIT licence
(see `LICENSE`).

The installer can also fetch the projects below. **None of them is copied into this
repository.** Each is downloaded from its author's own repository at install time, stays under
its own licence, and is maintained by its own authors. Thank you to the people who built them.

Licences were read from each repository in November 2026. Check the source for the current
terms before you redistribute any of them.

## Tool sets installed by `setup.sh`

| Project | Author | Licence | Source |
|---|---|---|---|
| ECC | Affaan Mustafa | MIT | https://github.com/affaan-m/ECC |
| gstack | Garry Tan | MIT | https://github.com/garrytan/gstack |
| superpowers, context7, frontend-design, code-simplifier | via the official Claude plugin marketplace | each plugin carries its own | https://github.com/anthropics/claude-plugins-official |
| Document skills (Word, PDF, PowerPoint, Excel) | Anthropic | see the repository; licences differ per skill | https://github.com/anthropics/skills |
| genjutsu | Adrien Thevon | MIT | https://github.com/AThevon/genjutsu |
| gsap-skills | GreenSock | MIT | https://github.com/greensock/gsap-skills |
| gitleaks (used by the secret guard when installed) | gitleaks contributors | MIT | https://github.com/gitleaks/gitleaks |

## Community skills installed by `scripts/install-extra-skills.sh`

The exact skill-by-skill list, with paths, is in `catalog/extra-skills.tsv`. Each installed
skill gets a `.source` file recording the repository and commit it came from, and a copy of
the upstream licence file where the repository has one.

| Repository | Licence | Skills |
|---|---|---|
| https://github.com/alirezarezvani/claude-skills | MIT | senior-architect, senior-backend, senior-frontend, senior-fullstack, senior-qa, senior-secops, senior-security, code-reviewer, aws-solution-architect, azure-cloud-architect, ci-cd-pipeline-builder, database-designer, observability-designer, secrets-vault-manager, helm-chart-builder, terraform-patterns |
| https://github.com/CloudAI-X/threejs-skills | MIT | ten three.js skills: animation, fundamentals, geometry, interaction, lighting, loaders, materials, postprocessing, shaders, textures |
| https://github.com/Leonxlnx/taste-skill | MIT | design-taste-frontend, high-end-visual-design, industrial-brutalist-ui, minimalist-ui, redesign-existing-projects, image-to-code, imagegen-frontend-web, imagegen-frontend-mobile, brandkit |
| https://github.com/nextlevelbuilder/ui-ux-pro-max-skill | MIT | ui-ux-pro-max, brand, banner-design, design-system, slides, ui-styling |
| https://github.com/google-labs-code/stitch-skills | Apache-2.0 | design-md, enhance-prompt, taste-design, shadcn-ui, react-vite-dashboard |
| https://github.com/LottieFiles/motion-design-skill | MIT | motion-design |
| https://github.com/Dammyjay93/interface-design | MIT | interface-design |
| https://github.com/dominikmartn/nothing-design-skill | MIT | nothing-design |
| https://github.com/axiaoge2/Apple-Hig-Designer | MIT | apple-hig-designer |
| https://github.com/alonw0/web-asset-generator | MIT | web-asset-generator |
| https://github.com/microsoft/playwright-cli | Apache-2.0 | playwright-cli |
| https://github.com/rebelytics/one-skill-to-rule-them-all | CC-BY-4.0 (attribution required) | task-observer |

### Listed but not installed by default

These repositories state no licence, so the installer skips them unless you pass
`--include-unlicensed`. With no licence, you may read and use them from the source but have no
stated right to redistribute them.

| Repository | Skill |
|---|---|
| https://github.com/chrisvoncsefalvay/claude-d3js-skill | d3-viz |
| https://github.com/vercel-labs/agent-skills | web-design-guidelines (its README says MIT, but there is no licence file) |

## Worth knowing about, installed separately

- **graphify** (https://github.com/Graphify-Labs/graphify, Apache-2.0) turns a codebase into a
  knowledge graph. It is a Python package with its own installer, so follow its README.

## If you are an author listed here

If anything above is wrong, or you would rather your project was not listed, open an issue and
it will be fixed or removed.
