#! /usr/bin/env bash
set -e
trap 'rm -f $TMPDIR/ansible-*' EXIT

createTempFile() {
  local outfile=$(mktemp -t "ansible-$1")

  op read "op://homeserver/ansible/$1" --force --out-file $outfile
}

if ! command -v op &> /dev/null; then
  echo "Error: 'op' command not found. Please install 1Password CLI."
  exit 1
fi

while (( "$#" )); do
  case "$1" in
    --tags|-t)
      TAGS="$2"
      shift 2
      ;;
    *)
      echo "Error: unknown option '$1'"
      exit 1
      ;;
  esac
done

echo "[secrets] loading secrets from 1Password CLI..."

# TODO: get all from 1Password as a single JSON object
export ANSIBLE_INVENTORY=$(createTempFile "hosts")
export ANSIBLE_VAULT_PASSWORD_FILE=$(createTempFile "vault-passwd")
export ANSIBLE_BECOME_PASSWORD_FILE=$(createTempFile "become-passwd")
export ANSIBLE_PRIVATE_KEY_FILE=$(op read "op://homeserver/ansible/private-key-file-path")

echo "[secrets] done!"

if [ -z "$TAGS" ]; then
  ansible-playbook setup.yml
else
  echo "[ansible] running playbook with tags: $TAGS"
  ansible-playbook setup.yml --tags "$TAGS"
fi