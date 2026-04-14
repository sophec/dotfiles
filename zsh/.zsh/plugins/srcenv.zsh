function srcenv() {
  envs=()

  if [ -f .venv/bin/activate ]; then
    envs+=(".venv/bin/activate#.venv#Python venv#")
  fi

  idf_envs=()
  for e ($HOME/esp/esp-idf-*/export.sh); do
    dir="${e%/export.sh}"
    ver="${dir#*esp-idf-}"
    idf_envs+=("$e#$dir#ESP-IDF $ver#esp-idf-$ver")
  done
  envs+=("${idf_envs[@]}")

  uei_envs=()
  for e (/opt/uei/ueipac-*/env.sh); do
    dir="${e%/env.sh}"
    ver="${dir#*ueipac-}"
    uei_envs+=("$e#$dir#PowerDNA $ver#powerdna-$ver")
  done
  envs+=("${uei_envs[@]}")

  if [[ "${#envs[@]}" == 0 ]]; then
    printf "no environments found\n"
    return
  fi

  # fields are separated with # and are:
  # 1. path to export script
  # 2. path to environment
  # 3. environment name
  # 4. environment prompt (or empty if no need, like with python or something?)
  chosen="$(print -l "${envs[@]}" \
    | fzf -e --reverse --height='20%' --min-height=10 --no-sort --border=rounded \
    --prompt="select an environment: " -d '#' --with-nth='{3} (from {2})' \
    --accept-nth='{1}#{4}' --info=hidden)"
  if [[ $? != 0 ]]; then
    return
  fi

  env_prompt="${chosen#*#}"
  env_src="${chosen%#*}"
  source "$env_src"
  export PROMPTUS_PREFIX="$env_prompt"
}
