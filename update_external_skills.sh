set -e

echo "Updating submodules..."
git submodule update --init --recursive --remote

# skill copy function
update_skill() {
    local skill=$1
    local repo_name=$2
    local target_dir=".github/skills/$skill"

    echo "  - $skill"
    # echo "Updating $skill from $repo_name..."
    rm -rf $target_dir
    cp -r $repo_name/skills/$skill $target_dir
}

# Anthropic
ANTHROPIC_SKILLS=(
    skill-creator
    # frontend-design
    # pdf
)

echo "Anthropic:"
for skill in "${ANTHROPIC_SKILLS[@]}"
do
    update_skill $skill anthropics-skills
done


OBRA_SUPERPWERS_SKILLS=(
    brainstorming
)

echo "Obra Superpowers:"
for skill in "${OBRA_SUPERPWERS_SKILLS[@]}"
do
    update_skill $skill obra-superpowers
done

VERCEL_LABS_SKILLS=(
    find-skills
)

echo "Vercel Labs:"
for skill in "${VERCEL_LABS_SKILLS[@]}"
do
    update_skill $skill vercel-labs-skills
done

echo -e "\n> Complete"