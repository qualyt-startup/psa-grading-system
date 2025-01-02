#!/usr/bin/env zsh

# Variables
PROJECT_DIR="$HOME/grading_app"
REPO_URL="git@github.com:qualyt-startup/psa-grading-system.git"
ANGULAR_CLI_VERSION="19.0.5"

echo "Setting up grading app..."

# Clone repository
if [ ! -d "$PROJECT_DIR" ]; then
    echo "Cloning repository..."
    git clone "$REPO_URL" "$PROJECT_DIR" || { echo "Failed to clone repository"; exit 1; }
else
    echo "Repository already cloned."
fi

# Navigate to project directory
cd "$PROJECT_DIR" || { echo "Failed to access project directory"; exit 1; }

# Install Angular CLI
echo "Installing Angular CLI version $ANGULAR_CLI_VERSION..."
npm install -g @angular/cli@$ANGULAR_CLI_VERSION

# Install project dependencies
echo "Installing project dependencies..."
npm install

# Set up ESLint
echo "Setting up ESLint..."
npm install eslint --save-dev
npx eslint --init << 'END_ESLINT'
problems
esm
none
typescript
browser
yes
npm
END_ESLINT

# Create Prettier configuration
echo "Creating Prettier configuration..."
cat << 'PRETTIER' > .prettierrc
{
  "semi": true,
  "singleQuote": true,
  "trailingComma": "all",
  "printWidth": 80
}
PRETTIER

# Update tsconfig.json
echo "Updating tsconfig.json..."
if [ -f tsconfig.json ]; then
    sed -i '' 's/"strict": false/"strict": true/' tsconfig.json
else
    echo "tsconfig.json not found"
fi

# Add CI pipeline configuration
echo "Creating CI pipeline configuration..."
mkdir -p .github/workflows
cat << 'CI' > .github/workflows/ci.yml
name: CI Pipeline

on:
  push:
    branches:
      - main
  pull_request:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '20'
      - name: Install dependencies
        run: npm ci
      - name: Run lint
        run: npm run lint
      - name: Run tests
        run: npm test
      - name: Build project
        run: npm run build
CI

# Update README
echo "Updating README file..."
cat << 'README' > README.md
# PSA Grading System

An Angular-based grading system designed for PSA teams in various sports.

## Features
- Intuitive User Interface
- Comprehensive Analytics
- Modern Design

## Installation
Clone the repository:
```bash
git clone $REPO_URL
cd grading_app
npm install
