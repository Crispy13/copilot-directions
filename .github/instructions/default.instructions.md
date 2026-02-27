---
description: Default behavior for this workspace/server.
applyTo: '**'
---

## Basic Instructions
1. Use conda environment: `rust_build_env`
```
# no need to source conda.sh. 
# If you invoke a new shell, then source is needed.
conda activate rust_build_env
```
When you need python venv, try to use conda environment first, if it doesn't work, then report the problem to user and ask user which of conda and venv you should use.

2. Use ./tmp for temporary files. Don't use /tmp.

3. When you are stuck in a problem which you can't solve yourself, you can ask user for help. But before that, you should try to solve the problem by yourself, and you should also try to find out what information you need to solve the problem.

4. If you think you have better options to solve problems, you can suggest them to user. But you should also explain why you think your options are better than the current options.


## Note
1. Fix my English if needed. I am not a native speaker.