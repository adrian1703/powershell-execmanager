# **PSCmdManager**

`PSCmdManager` is a PowerShell-based tool designed to manage serialized workflows using a YAML configuration. It provides a modular and repeatable approach to execute tasks and actions, making it ideal for tasks like automating software installations, system setups, or other deterministic workflows.

---

## **Overview**

The module uses YAML files to define tasks and actions, which are executed in a serialized manner. Each task can consist of multiple actions, allowing for configurable and repeatable workflows. It includes predefined functions for downloading files (`Invoke-Download`) and executing installers (`Invoke-Exe`) but can be extended with custom commands.

A primary use case is the **fresh and repeatable setup of environments**, such as installing software on a new machine or configuring a system.

---

## **Features**

- **YAML Configuration**: Define tasks, actions, and reusable defaults for a flexible setup.
- **Predefined Actions**: Comes with built-in functions:
    - `Invoke-Download`: For downloading files from the internet.
    - `Invoke-Exe`: For executing installer files with arguments.
- (soon) **Implicit Command Invokation Support**: Omit the definition process of actions and invoke any command your powershell is equipped with. 
- **Serialized Execution**:
    - Tasks are executed in order.
    - Actions within a task are executed sequentially.
- **Environment Variables Support**: Incorporate dynamic values (e.g., file paths, user environment variables) using `${}` syntax in the YAML file. These placeholders are automatically resolved to their current environment variable values at runtime. **Define temporary environment variables** for the specific execution context in the config YAML.
- **Dry-Run Mode**: Simulate the execution without performing actual actions, useful for testing configurations.
- **Repeatable Workflows**: Reuse the YAML configuration for consistent and repeatable task executions.

---

## **Structure**

This project consists of the following critical components:

### 1. **Core Functions**
The following functions are used to drive task execution and workflows:

| Function                     | Description                                                                                    |
|------------------------------|------------------------------------------------------------------------------------------------|
| `Start-RunAllTasks`          | Executes all tasks defined in the YAML configuration.                                          |
| `Start-RunTaskAllActions`    | Executes all actions for a specified task.                                                    |
| `Start-RunTaskAction`        | Executes a single action for a specific task.                                                 |
| `Invoke-Download`            | Downloads files using a URL.                                                                  |
| `Invoke-Exe`                 | Runs executable files with specified arguments.                                               |

### 2. **YAML Configuration**
The YAML file defines the schema, tasks, actions, and default configurations for all operations. Example sections include:
- **Actions**: Specify reusable commands like file downloads or application installation.
- **Environment**: Place for defining environment variables for the execution context
- **Tasks**: Define high-level steps consisting of one or more actions.

---

## **Environment Variable Support (Using `${}`)**

The configuration file supports placeholder values in the `${VAR_NAME}` format. These placeholders will be dynamically resolved at runtime based on the current system's environment variables.

For example:
```yaml
schema:
  version: 1
  
action-definitions:
  download:
    definition:
      function: "Invoke-Download"
      args:
        -fileName
        -link
        -downloadFolder
    defaults:
      downloadFolder: "${TMP}"
      
environment:
  - env: "FILENAME"
    val: "file.zip"
    
tasks:
  - name: "ExampleTask"
    actions:
      - cmd: download
        args:
          fileName: "example.zip"
          link: "https://example.com/${FILENAME}" # Resolves to "https://example.com/file.zip"
          downloadFolder: "${MY_CUSTOM_FOLDER}" # Resolves to the value of $env:MY_CUSTOM_FOLDER
```

### **How It Works**
- `${}` placeholders in the YAML file map to environment variables (e.g., `TMP`, `USERPROFILE`).
- During task execution, placeholders are expanded to their corresponding environment variable values.
- If a variable is not set, the process throws an error to alert the user.

**Tip**: To set custom environment variables, define them before running the tasks:
```powershell
$env:MY_CUSTOM_FOLDER = "C:\MyCustomPath"
```

---

## **Configuration Example**

Below is an example of a YAML configuration file (`config-example.yaml`):

```yaml
schema:
  version: 1
  
action-definitions:
  download:
    definition:
      function: "Invoke-Download"
      args:
        -fileName
        -link
        -downloadFolder
    defaults:
      downloadFolder: "${TMP}"
  callExe:
    definition:
      function: "Invoke-Exe"
      args:
        -fileName
        -fileLocation
        -execArguments
    defaults:
      fileLocation: "${TMP}"

tasks:
  - name: "Rider"
    description: "Download and install Rider IDE"
    actions:
      - cmd: download
        args:
          fileName: "install.exe"
          link: "https://download.jetbrains.com/rider/JetBrains.Rider-2024.3.4.exe"
      - cmd: callExe
        args:
          fileName: "install.exe"
          execArguments:
              - "/S"
              - "/CONFIG=${SETUP_PROJ}/src/rider/silent.config"
              - "/LOG=${TMP}/rider_install.log"
              - "/D=${IDES}/jetbrains/Rider"
```

In this example:
- `${TMP}` resolves to the system's temporary directory.
- `${SETUP_PROJ}` and `${IDES}` must be defined as environment variables.

---

## **Getting Started**

### **1. Installation**

Import the module into your PowerShell session:
```powershell
Import-Module .\PSCmdManager.psd1
```

### **2. Prepare YAML Configuration**

Create or modify a YAML file to define tasks and actions. Use placeholders like `${TMP}` or `${SETUP_PROJ}` to customize behavior based on environment variables.

### **3. Execute Tasks**

- Execute all tasks:
  ```powershell
  Start-RunAllTasks -configPath "C:\path\to\your\config.yaml"
  ```
- Dry-run to simulate execution:
  ```powershell
  Start-RunAllTasks -configPath "C:\path\to\your\config.yaml" -dry
  ```
- Run a specific task:
  ```powershell
  Start-RunTaskAllActions -configPath "C:\path\to\your\config.yaml" -taskName "Rider"
  ```
- Run a specific action of a task:
  ```powershell
  Start-RunTaskAction -configPath "C:\path\to\your\config.yaml" -taskName "Rider" -actionName "download"
  ```

---

## **Dry-Run Mode**

Test workflows without executing actions using the `-dry` flag. This is ideal for:
- Validating YAML configurations and ensuring correctness.
- Debugging task and action definitions.

**Example**:
```powershell
Start-RunAllTasks -configPath "C:\path\to\config.yaml" -dry
```

---

## **Error Handling**

- **Validation**: The system validates task and action references, resolving placeholders and ensuring proper configuration before execution.
- **Execution Errors**: If an action fails (e.g., download fails, executable not found, unresolved environment variables), the system stops and displays the error for troubleshooting.

---

## **Extensibility**

`PSCmdManager` can be extended by adding custom actions to the schema or implementing functions to handle new types of tasks. Use these steps:
1. Define the new action type in the **YAML schema**.
2. Implement the corresponding function in your PowerShell scripts.
3. Configure the arguments and defaults in your YAML file.

---

## **Examples**

### **1. Download and Install a JetBrains IDE**
```yaml
schema:
  version: 1
  
action-definitions:
  download:
    definition:
      function: "Invoke-Download"
      args:
        -fileName
        -link
        -downloadFolder
    defaults:
      downloadFolder: "${TMP}"
  callExe:
    definition:
      function: "Invoke-Exe"
      args:
        -fileName
        -fileLocation
        -execArguments
    defaults:
      fileLocation: "${TMP}"

tasks:
  - name: "Rider"
    description: "Download and install Rider IDE"
    actions:
      - cmd: download
        args:
          fileName: "install.exe"
          link: "https://download.jetbrains.com/rider/JetBrains.Rider-2024.3.4.exe"
      - cmd: callExe
        args:
          fileName: "install.exe"
          execArguments:
            - "/S"
            - "/CONFIG=${SETUP_PROJ}/src/rider/silent.config"
            - "/LOG=${TMP}/rider_install.log"
            - "/D=${IDES}/jetbrains/Rider"
```

**Command**:
```powershell
Start-RunTaskAllActions -configPath "C:\config.yaml" -taskName "Rider"
```

---

## **Tests**
Example for invoking certain tests
```powershell
Invoke-Pester .\Tests\Unit\
```

## **Contributing**

1. Fork the repository.
2. Create a new branch for your feature or fix.
3. Submit a pull request with a detailed explanation of your changes.

---

## **License**

This project is licensed under the [MIT License](LICENSE).

---

## **Author**

Created by **Adrian Kuhn**. If you have questions or issues, please open an issue in the repository.

---