module.exports = {
  $schema: 'https://semantic-release.org/schema/semantic-release.schema.json',
  branches: ['main'],
  repositoryUrl: 'https://github.com/rapaglaz/own-dark-001',
  plugins: [
    [
      '@semantic-release/commit-analyzer',
      {
        preset: 'conventionalcommits',
        releaseRules: [
          {
            type: 'feat',
            release: 'minor',
          },
          {
            type: 'fix',
            release: 'patch',
          },
          {
            type: 'style',
            release: 'patch',
          },
          {
            type: 'perf',
            release: false,
          },
          {
            type: 'docs',
            release: false,
          },
          {
            type: 'refactor',
            release: false,
          },
          {
            type: 'test',
            release: false,
          },
          {
            type: 'chore',
            release: false,
          },
        ],
      },
    ],
    [
      '@semantic-release/release-notes-generator',
      {
        preset: 'conventionalcommits',
        presetConfig: {
          types: [
            {
              type: 'feat',
              section: 'Changes',
            },
            {
              type: 'fix',
              section: 'Changes',
            },
            {
              type: 'style',
              section: 'Changes',
            },
            {
              type: 'perf',
              hidden: true,
            },
            {
              type: 'docs',
              hidden: true,
            },
            {
              type: 'chore',
              hidden: true,
            },
            {
              type: 'refactor',
              hidden: true,
            },
            {
              type: 'ci',
              hidden: true,
            },
            {
              type: 'test',
              hidden: true,
            },
          ],
        },
      },
    ],
    [
      '@semantic-release/changelog',
      {
        changelogFile: 'CHANGELOG.md',
      },
    ],
    [
      '@semantic-release/npm',
      {
        npmPublish: false,
      },
    ],
    [
      'semantic-release-vsce',
      {
        packageVsix: true,
      },
    ],
    [
      '@semantic-release/github',
      {
        assets: '*.vsix',
        releaseNameTemplate: '<%= nextRelease.version %>',
        releaseBodyTemplate: '<%= nextRelease.notes %>',
        releasedLabels: false,
        successCommentCondition: "<% return issue.user.type !== 'Bot'; %>",
      },
    ],
  ],
};
