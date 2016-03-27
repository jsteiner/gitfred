# Gitfred

A CLI for searching GitHub repos, formatted for [Alfred].

[Alfred]: https://www.alfredapp.com/

Supports the following commands:

1. Cache GitHub repos: stores repo data in a CSV file in the current directory

   ```
   $ gitfred cache
   ```

1. Search GitHub repos: returns all repos matching the given query in
   Alfred's XML format.
   ```
   $ gitfred search foobar
   ```

1. Increment repo visits: used to sort boards by frequency of visits

   ```
   gitfred increment https://github.com/repo_owner/repo
   ```

## Credentials

Gitfred expects your [GitHub OAuth token] to be exposed in a `.env` file in the current directory. The file should have the following structure:

[GitHub OAuth token]: https://github.com/settings/tokens/new

```
GITHUB_OAUTH_TOKEN=your-token
```

## License

Gitfred is Copyright © 2016 Josh Steiner. It is free software, and
may be redistributed under the terms specified in the LICENSE file.
