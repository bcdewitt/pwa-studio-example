#!/bin/bash

# Run `chmod u+x initvscode.sh`, `./initvscode.sh` to create files for VSCode

touch api/.devcontainer.json
cat > api/.devcontainer.json << EOM
{
  "name": "FM API Dev Container",
  "dockerComposeFile": ["../docker-compose.yml", "../docker-compose.override.yml"],
  "service": "api",
  "workspaceFolder": "/workspace/api",

  // Use 'settings' to set *default* container specific settings.json values on container create.
  // You can edit these settings after create using File > Preferences > Settings > Remote.
  "settings": {
    "terminal.integrated.shell.linux": "/bin/bash",

    // Find ./node_modules/eslint, and plugins starting here
    "eslint.workingDirectories": [ "./api" ]
  },

  // Specifies a command that should be run after the container has been created.
  "postCreateCommand": "npm i",

  // Add the IDs of extensions you want installed when the container is created in the array below.
  "extensions": [
    "ms-azuretools.vscode-docker",
    "dbaeumer.vscode-eslint",
    "editorconfig.editorconfig",
    "mhutchie.git-graph"
  ],

  "shutdownAction": "none"
}
EOM

touch app/.devcontainer.json
cat > app/.devcontainer.json << EOM
{
  "name": "FM Expressions App Dev Container",
  "dockerComposeFile": ["../docker-compose.yml", "../docker-compose.override.yml"],
  "service": "app",
  "workspaceFolder": "/workspace/app",

  // Use 'settings' to set *default* container specific settings.json values on container create.
  // You can edit these settings after create using File > Preferences > Settings > Remote.
  "settings": {
    "terminal.integrated.shell.linux": "/bin/bash",

    // Find ./node_modules/eslint, and plugins starting here
    "eslint.workingDirectories": [ "./app" ]
  },

  // Specifies a command that should be run after the container has been created.
  "postCreateCommand": "npm i",

  // Add the IDs of extensions you want installed when the container is created in the array below.
  "extensions": [
    "ms-azuretools.vscode-docker",
    "dbaeumer.vscode-eslint",
    "editorconfig.editorconfig",
    "mhutchie.git-graph"
  ],

  "shutdownAction": "none"
}
EOM

mkdir -p .vscode
touch .vscode/launch.json
cat > .vscode/launch.json << EOM
{
  // Use IntelliSense to learn about possible attributes.
  // Hover to view descriptions of existing attributes.
  // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
  "version": "0.2.0",
  "configurations": [
    {
      "type": "node",
      "request": "launch",
      "name": "(App) Launch Program",
      "cwd": "\${workspaceFolder}/app",
      "program": "\${workspaceFolder}/app/src/index.ts",
      "outFiles": ["\${workspaceFolder}/app/dist/**/*.js"],
      "console": "integratedTerminal",
      "internalConsoleOptions": "neverOpen",
      "preLaunchTask": "(App) Build"
    },
    {
      "type": "node",
      "request": "launch",
      "name": "(App) Jest All",
      "cwd": "\${workspaceFolder}/app",
      "program": "\${workspaceFolder}/app/node_modules/.bin/jest",
      "args": ["--runInBand"],
      "console": "integratedTerminal",
      "internalConsoleOptions": "neverOpen",
      "disableOptimisticBPs": true,
      "windows": {
        "program": "\${workspaceFolder}/app/node_modules/jest/bin/jest",
      },
      "timeout": 25000,
      "preLaunchTask": "(App) Build"
    },
    {
      "type": "node",
      "request": "launch",
      "name": "(App) Jest Current File",
      "cwd": "\${workspaceFolder}/app",
      "program": "\${workspaceFolder}/app/node_modules/.bin/jest",
      "args": [
        "\${relativeFile}",
        "--config",
        "jest.config.js"
      ],
      "console": "integratedTerminal",
      "internalConsoleOptions": "neverOpen",
      "disableOptimisticBPs": true,
      "windows": {
        "program": "\${workspaceFolder}/app/node_modules/jest/bin/jest",
      },
      "timeout": 25000,
      "preLaunchTask": "(App) Build"
    }
  ]
}
EOM

touch .vscode/test.code-snippets
cat > .vscode/test.code-snippets << EOM
{
  // https://code.visualstudio.com/docs/editor/userdefinedsnippets
  //
  // Place your fm-expressions workspace snippets here. Each snippet is defined under a snippet name and has a scope, prefix, body and
  // description. Add comma separated ids of the languages where the snippet is applicable in the scope field. If scope
  // is left empty or omitted, the snippet gets applied to all languages. The prefix is what is
  // used to trigger the snippet and the body will be expanded and inserted. Possible variables are:
  // \$1, \$2 for tab stops, \$0 for the final cursor position, and \${1:label}, \${2:another} for placeholders.
  // Placeholders with the same ids are connected.
  // Example:
  // "Print to console": {
  //    "scope": "javascript,typescript",
  //    "prefix": "log",
  //    "body": [
  //      "console.log('\$1');",
  //      "\$2"
  //    ],
  //    "description": "Log output to console"
  // }
  //
  "Add new test": {
    "scope": "javascript,typescript",
    "prefix": "describe",
    "body": [
      "describe('\${1:test}', () => {",
      "  it('\${2:adds 1 + 1 to equal 2}', () => {",
      "    expect.assertions(1)",
      "    \${3:const result = 1 + 1}",
      "    expect(\${4:result}).\${5:toBe(2)}",
      "  })",
      "})",
      ""
    ],
    "description": "Add a new Jest test"
  }
}
EOM

touch .vscode/tasks.json
cat > .vscode/tasks.json << EOM
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "(App) Build",
      "group": {
        "kind": "build",
        "isDefault": true
      },
      "type": "shell",
      "command": "(cd ./app && npm run build)"
    }
  ]
}
EOM
