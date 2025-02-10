/**
 * @type {import('semantic-release').GlobalConfig}
 */
module.exports = {
	branches: ['main'],
	tagFormat: '${version}',
	plugins: [
		[
			'@semantic-release/commit-analyzer',
			{
				preset: 'angular',
				releaseRules: [
					{
						breaking: true,
						release: 'major',
					},
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
						type: 'chore',
						release: 'patch',
					},
				],
				parserOpts: {
					noteKeywords: ['BREAKING CHANGE', 'BREAKING CHANGES', 'BREAKING'],
				},
			},
		],
		[
			'@semantic-release/release-notes-generator',
			{
				preset: 'conventionalcommits',
				presetConfig: {
					types: [
						{ type: 'feat', section: 'Changes', hidden: false },
						{ type: 'fix', section: 'Changes', hidden: false },
						{ type: 'style', section: 'Changes', hidden: false },
						{ type: 'chore', section: 'Chores', hidden: true },
					],
				},
				parserOpts: {
					noteKeywords: ['BREAKING CHANGE', 'BREAKING CHANGES', 'BREAKING'],
				},
			},
		],
		['@semantic-release/npm'],
		[
			'@semantic-release/changelog',
			{
				changelogFile: 'CHANGELOG.md',
			},
		],
		[
			'@semantic-release/git',
			{
				assets: ['package.json', 'CHANGELOG.md'],
				message:
					'chore(release): ${nextRelease.version} \n\n${nextRelease.notes}',
			},
		],
		[
			'semantic-release-vsce',
			{
				packageVsix: true,
				publish: true,
			},
		],
		[
			'@semantic-release/github',
			{
				assets: '*.vsix',
			},
		],
	],
};
