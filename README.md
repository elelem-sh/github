# elelem-github

A [GitHub Models](https://github.com/settings/tokens) provider plugin for [elelem](https://elelem.sh).
It talks to GitHub Models' OpenAI-compatible Chat Completions API
through [elelem-openai](https://github.com/elelem-sh/openai).

## Install

```sh
gem install elelem-github
```

## Use

```sh
export GITHUB_API_KEY=...
elelem -p github --model MODEL
```

* `GITHUB_API_KEY` (required): a GitHub token with the `models:read` permission, from https://github.com/settings/tokens
* `GITHUB_MODEL`: the model, when `--model` is not given
* `GITHUB_BASE_URL`: overrides `https://models.github.ai/inference`

There is no default model, since free model lists change often. With
no model set, elelem stops and names `GITHUB_MODEL`. A variable that is
set but empty counts as unset.

Free tier limits are on GitHub Models' own page: https://docs.github.com/en/github-models/use-github-models/prototyping-with-ai-models#rate-limits

## Development

```sh
bin/setup
bin/test
bin/lint
```

## License

MIT. See LICENSE.txt.
