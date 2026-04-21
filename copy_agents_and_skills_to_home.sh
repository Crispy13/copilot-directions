cp .github/agents/* ~/.copilot/agents/

GENERAL_SKILLS=(
    brainstorming
    committee
    committee-member
    skill-creator
    research
    discussion-mode
    fit-skill-to-copilot
)
for skill in "${GENERAL_SKILLS[@]}"
do
    # echo "  - $skill"
    rm -rf ~/.copilot/skills/$skill
    cp -r .github/skills/$skill ~/.copilot/skills/
done
# cp .github/prompts/ms-workflow.prompt.md ~/.copilot/prompts/