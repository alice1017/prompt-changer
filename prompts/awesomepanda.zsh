# The MIT License (MIT)
#
# Copyright (c) 2009-2018 Robby Russell and contributors
# See the full list at https://github.com/robbyrussell/oh-my-zsh/contributors
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


# Setting option
setopt prompt_subst

# Setting autoload
autoload -Uz promptinit ; promptinit # for initialize prompt
autoload -Uz colors     ; colors     # for colorize prompt

# the svn plugin has to be activated for this to work.
function svn_prompt_info() {
  local info
  info=$(svn info 2>&1) || return 1; # capture stdout and stderr
  local repo_need_upgrade=$(svn_repo_need_upgrade $info)

  if [[ -n $repo_need_upgrade ]]; then
    printf '%s%s%s%s%s%s%s\n' \
      $ZSH_PROMPT_BASE_COLOR \
      $ZSH_THEME_SVN_PROMPT_PREFIX \
      $ZSH_PROMPT_BASE_COLOR \
      $repo_need_upgrade \
      $ZSH_PROMPT_BASE_COLOR \
      $ZSH_THEME_SVN_PROMPT_SUFFIX \
      $ZSH_PROMPT_BASE_COLOR
  else
    printf '%s%s%s %s%s:%s%s%s%s%s' \
      $ZSH_PROMPT_BASE_COLOR \
      $ZSH_THEME_SVN_PROMPT_PREFIX \
      \
      "$(svn_status_info $info)" \
      $ZSH_PROMPT_BASE_COLOR \
      \
      $ZSH_THEME_BRANCH_NAME_COLOR \
      $(svn_current_branch_name $info) \
      $ZSH_PROMPT_BASE_COLOR \
      \
      $(svn_current_revision $info) \
      $ZSH_PROMPT_BASE_COLOR \
      \
      $ZSH_THEME_SVN_PROMPT_SUFFIX \
      $ZSH_PROMPT_BASE_COLOR
  fi
}

function svn_repo_need_upgrade() {
  grep -q "E155036" <<< ${1:-$(svn info 2> /dev/null)} && \
    echo "E155036: upgrade repo with svn upgrade"
}


# Outputs current branch info in prompt format
function git_prompt_info() {
  local ref
  if [[ "$(command git config --get oh-my-zsh.hide-status 2>/dev/null)" != "1" ]]; then
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
}

# Checks if working tree is dirty
function parse_git_dirty() {
  local STATUS=''
  local -a FLAGS
  FLAGS=('--porcelain')
  if [[ "$(command git config --get oh-my-zsh.hide-dirty)" != "1" ]]; then
    if [[ $POST_1_7_2_GIT -gt 0 ]]; then
      FLAGS+='--ignore-submodules=dirty'
    fi
    if [[ "$DISABLE_UNTRACKED_FILES_DIRTY" == "true" ]]; then
      FLAGS+='--untracked-files=no'
    fi
    STATUS=$(command git status ${FLAGS} 2> /dev/null | tail -n1)
  fi
  if [[ -n $STATUS ]]; then
    echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
  else
    echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi
}

# Compares the provided version of git to the version installed and on path
# Outputs -1, 0, or 1 if the installed version is less than, equal to, or
# greater than the input version, respectively.
function git_compare_version() {
  local INPUT_GIT_VERSION INSTALLED_GIT_VERSION
  INPUT_GIT_VERSION=(${(s/./)1})
  INSTALLED_GIT_VERSION=($(command git --version 2>/dev/null))
  INSTALLED_GIT_VERSION=(${(s/./)INSTALLED_GIT_VERSION[3]})

  for i in {1..3}; do
    if [[ $INSTALLED_GIT_VERSION[$i] -gt $INPUT_GIT_VERSION[$i] ]]; then
      echo 1
      return 0
    fi
    if [[ $INSTALLED_GIT_VERSION[$i] -lt $INPUT_GIT_VERSION[$i] ]]; then
      echo -1
      return 0
    fi
  done
  echo 0
}

POST_1_7_2_GIT=$(git_compare_version "1.7.2")
DISABLE_UNTRACKED_FILES_DIRTY=true


local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ %s)"
PROMPT='${ret_status}%{$fg_bold[green]%}%p %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%}$(svn_prompt_info)%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%})%{$fg[yellow]%} ✗ %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%}) "

ZSH_PROMPT_BASE_COLOR="%{$fg_bold[blue]%}"
ZSH_THEME_REPO_NAME_COLOR="%{$fg_bold[red]%}"

ZSH_THEME_SVN_PROMPT_PREFIX="svn:("
ZSH_THEME_SVN_PROMPT_SUFFIX=")"
ZSH_THEME_SVN_PROMPT_DIRTY="%{$fg[red]%} ✘ %{$reset_color%}"
ZSH_THEME_SVN_PROMPT_CLEAN=" "
