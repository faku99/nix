import { expect, mock, test } from 'claude-code/testing'

test('a review dropped in the inbox is claimed and submitted as the user', async ($, on) => {
  const clock = mock.clock(on)
  const files: Record<string, string> = { '.review/inbox/20261002-101500.md': '## src/a.ts:12\nWhy does this import b?' }
  const submitted: string[] = []
  // The engine hands hooks absolute paths; keep the fake file system relative.
  const rel = (p: string) => p.replace(/^.*?(\.review\/)/, '$1')

  on('session.start', () => ({ cwd: '/repo' }))
  on('command.register', () => ({ value: undefined }))
  on('fs.exists', (_, e) => ({ value: Object.keys(files).some(p => p.startsWith(rel(e.path))) }))
  on('fs.list', () => ({
    value: Object.keys(files)
      .filter(p => p.startsWith('.review/inbox/'))
      .map(p => ({ name: p.slice('.review/inbox/'.length), kind: 'file', size: 1, mtimeMs: 1, isLink: false })),
  }))
  on('fs.write', (_, e) => { files[rel(e.path)] = e.text; return { value: undefined } })
  on('fs.read', (_, e) => ({ value: files[rel(e.path)] }))
  on('process.run', (_, e) => {
    if (e.argv[0] === 'git') return { value: { exitCode: 0, stdout: '/repo\n', stderr: '' } }
    const [from, to] = e.argv.slice(1).map(rel)
    if (!(from in files)) return { value: { exitCode: 1, stdout: '', stderr: 'gone' } }
    files[to] = files[from]
    delete files[from]
    return { value: { exitCode: 0, stdout: '', stderr: '' } }
  })
  on('prompt.submit', (_, e) => { submitted.push(e.text); return { text: e.text } })
  on('ui.status', () => ({ value: undefined }))
  on('ui.toast', () => ({ value: undefined }))

  await $.session.start({ cwd: '/repo', surface: 'terminal', isInteractive: true })
  await clock.advance(1500)

  expect(submitted.length).toBe(1)
  expect(submitted[0]).toContain('Why does this import b?')
  expect(submitted[0]).toContain('answer it with your reasoning')
  expect('.review/done/20261002-101500.md' in files).toBe(true)

  // Nothing left: later ticks submit nothing more.
  await clock.advance(3000)
  expect(submitted.length).toBe(1)
})
