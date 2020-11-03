# find branch, commit, repo from git command
if [ "$GIT_BRANCH" != "" ];
then
  branch="$GIT_BRANCH"

elif [ "$branch" = "" ];
then
  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || hg branch 2>/dev/null || echo "")
  if [ "$branch" = "HEAD" ];
  then
    branch=""
  fi
fi