# SSH Configuration for Multiple GitHub Accounts

This configuration enables using separate SSH keys for personal and work GitHub accounts.

## Setup

### 1. Generate Work SSH Key

```bash
ssh-keygen -t ed25519 -C "your.work@email.com" -f ~/.ssh/id_ed25519_work
```

When prompted:
- **Passphrase**: Use a strong passphrase (recommended)
- The private key will be saved to `~/.ssh/id_ed25519_work`
- The public key will be saved to `~/.ssh/id_ed25519_work.pub`

### 2. Add Work SSH Key to GitHub

```bash
# Copy public key to clipboard (macOS)
pbcopy < ~/.ssh/id_ed25519_work.pub

# Or display it
cat ~/.ssh/id_ed25519_work.pub
```

Then:
1. Log into your **work** GitHub account
2. Go to Settings → SSH and GPG keys → New SSH key
3. Paste the public key
4. Give it a descriptive title (e.g., "MacBook Work Key")

### 3. Start SSH Agent and Add Keys

```bash
# Start ssh-agent (if not already running)
eval "$(ssh-agent -s)"

# Add personal key
ssh-add ~/.ssh/id_ed25519

# Add work key with passphrase
ssh-add ~/.ssh/id_ed25519_work
```

**Optional**: Add to `~/.zshrc` or `~/.bashrc` to persist across sessions:
```bash
# Auto-start ssh-agent
if [ -z "$SSH_AUTH_SOCK" ]; then
  eval "$(ssh-agent -s)" > /dev/null
fi
```

### 4. Verify Connection

```bash
# Test personal GitHub
ssh -T git@github.com
# Expected: "Hi <personal-username>! You've successfully authenticated..."

# Test work GitHub
ssh -T git@github-work
# Expected: "Hi <work-username>! You've successfully authenticated..."
```

## Usage

### Clone Repositories

**Personal repos** (default behavior, no changes):
```bash
git clone git@github.com:username/repo.git
```

**Work repos** (use `github-work` host alias):
```bash
git clone git@github-work:company/repo.git
```

### Change Existing Repository

If you need to switch an existing repo to use the work account:

```bash
cd /path/to/repo
git remote set-url origin git@github-work:company/repo.git
```

### Set Repository-Specific Git Identity

Work repos typically need different commit author info:

```bash
cd /path/to/work/repo
git config user.name "Your Name"
git config user.email "your.work@email.com"
```

**Tip**: Create a shell alias or function to automate this:
```bash
# Add to ~/.zshrc or ~/.bashrc
work-repo() {
  git config user.email "your.work@email.com"
  echo "Set git user.email to $(git config user.email)"
}
```

## Troubleshooting

### "Permission denied (publickey)"

1. Verify key exists: `ls -l ~/.ssh/id_ed25519_work`
2. Check key is loaded: `ssh-add -l`
3. If not loaded: `ssh-add ~/.ssh/id_ed25519_work`
4. Test with verbose output: `ssh -vT git@github-work`

### Wrong account being used

Check which key is being offered:
```bash
ssh -vT git@github-work 2>&1 | grep "Offering public key"
```

Should show `~/.ssh/id_ed25519_work`.

### Key permissions

SSH keys must have restrictive permissions:
```bash
chmod 600 ~/.ssh/id_ed25519_work
chmod 644 ~/.ssh/id_ed25519_work.pub
```

## Security Notes

- **Never commit private keys** (`.gitignore` already blocks `**/*.key`, `**/*.pem`)
- SSH keys in `~/.ssh/` are NOT tracked by this dotfiles repo
- Only the SSH `config` file is version controlled
- Always use passphrases for SSH keys
