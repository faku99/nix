import type { EngineInterface, Register } from 'claude-code'

// Neovim drops exported reviews here, under the git root.
const INBOX = '.review/inbox'
const DONE = '.review/done'
const POLL_MS = 1500

// How Claude should treat the review. Questions get answers, not code changes:
// that's the whole point of reviewing "why" the code is the way it is.
const PREAMBLE = `Here is my code review of the current changes, in the format of MR review comments.
Handle each comment in order:
- If it is a question ("why…?", "is this needed?"), answer it with your reasoning. Do NOT change code for a question unless your answer concludes the code is wrong — then say so and propose the fix.
- If it is a change request, make the change.
- If you disagree with a request, say why instead of silently complying.
Reply comment by comment, quoting the file:line each answer refers to. Finish with a short list of what you changed.

`

// Set while a review is between "picked up" and "turn started", so the timer
// never submits the same review twice or two at once.
let inFlight = false

// Git root of the session's working directory, so a subdirectory start still works.
async function reviewRoot($: EngineInterface): Promise<string> {
  const top = await $.process.run(['git', 'rev-parse', '--show-toplevel'])
  const root = top.exitCode === 0 ? top.stdout.trim() : ''
  return root === '' ? '' : `${root}/`
}

// Pick up the oldest review in the inbox, if any. Returns what happened, for /nvim-review.
async function pickUp($: EngineInterface): Promise<string> {
  if (inFlight) return 'A review is already queued for Claude.'
  const root = await reviewRoot($)
  const inbox = root + INBOX
  const done = root + DONE
  if (!(await $.fs.exists(inbox))) return `No review waiting (nothing in ${inbox}).`

  const entries = await $.fs.list(inbox)
  const pending = entries
    .filter(f => f.kind === 'file' && f.name.endsWith('.md'))
    .sort((a, b) => a.mtimeMs - b.mtimeMs)
  if (pending.length === 0) return 'No review waiting (nothing in .review/inbox).'

  // Claim it by moving it out of the inbox first. If another Claude Code session
  // in the same repo got there before us, mv fails and that session handles it.
  const name = pending[0].name
  await $.fs.write(`${done}/.keep`, '')
  const moved = await $.process.run(['mv', `${inbox}/${name}`, `${done}/${name}`])
  if (moved.exitCode !== 0) return 'Another session took that review.'

  const markdown = await $.fs.read(`${done}/${name}`)
  if (markdown.trim() === '') return 'The waiting review was empty; skipped.'

  inFlight = true
  $.ui.status(`review ${name} queued`)
  $.ui.toast(`Review received from Neovim (${name})`)
  // Waits for the session to be idle, then starts the turn. Not awaited, so a
  // review exported while Claude is busy simply queues behind the current turn.
  void $.prompt
    .submit({ text: PREAMBLE + markdown, asUser: true })
    .finally(() => {
      inFlight = false
      $.ui.status(undefined)
    })
  return `Sent review ${name} to Claude.`
}

export const register: Register = on => {
  on('session.start', async ($, e, next) => {
    // Watch the inbox: a review exported from Neovim reaches Claude with no typing.
    $.clock.every(POLL_MS, async () => {
      await pickUp($)
    })
    try {
      await $.command.register({
        name: 'nvim-review',
        description: 'Send the next review exported from Neovim to Claude now',
      })
    } catch {
      // A name clash only costs the manual command; the watcher still runs.
    }
    return next(e)
  })

  on('command.run', { command: 'nvim-review' }, async $ => {
    return { text: await pickUp($) }
  })
}
