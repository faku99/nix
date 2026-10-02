import type { EngineInterface, Register } from 'claude-code'

// Neovim drops exported reviews here (relative to the session's working directory,
// so start Claude Code from the repo root).
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

// Pick up the oldest review in the inbox, if any. Returns what happened, for /nvim-review.
async function pickUp($: EngineInterface): Promise<string> {
  if (inFlight) return 'A review is already queued for Claude.'
  if (!(await $.fs.exists(INBOX))) return 'No review waiting (nothing in .review/inbox).'

  const entries = await $.fs.list(INBOX)
  const pending = entries
    .filter(f => f.kind === 'file' && f.name.endsWith('.md'))
    .sort((a, b) => a.mtimeMs - b.mtimeMs)
  if (pending.length === 0) return 'No review waiting (nothing in .review/inbox).'

  // Claim it by moving it out of the inbox first. If another Claude Code session
  // in the same repo got there before us, mv fails and that session handles it.
  const name = pending[0].name
  await $.fs.write(`${DONE}/.keep`, '')
  const moved = await $.process.run(['mv', `${INBOX}/${name}`, `${DONE}/${name}`])
  if (moved.exitCode !== 0) return 'Another session took that review.'

  const markdown = await $.fs.read(`${DONE}/${name}`)
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
