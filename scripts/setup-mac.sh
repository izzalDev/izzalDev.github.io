#!/usr/bin/env bash
trap 'exit' SIGINT

if ! command -v brew &>/dev/null; then
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if ! grep -q "$(/opt/homebrew/bin/brew shellenv)" ~/.zprofile; then
  echo "$(/opt/homebrew/bin/brew shellenv)" >> ~/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if ! mas version >/dev/null; then
  brew install --formula mas
fi
