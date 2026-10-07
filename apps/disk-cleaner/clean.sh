#!/bin/bash
# macOS disk cleaner: measures common cache/junk locations and deletes them
# one by one after confirmation. No sudo. Use --dry-run to preview only.
set -u

DRY_RUN=0
MIN_KB=$((100 * 1024))
BIG_DOWNLOAD_MB=500

usage() {
  echo "Usage: $0 [--dry-run]"
  echo "  --dry-run  show what would be cleaned; delete nothing and ask nothing"
}

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    -h|--help) usage; exit 0 ;;
    *) usage; exit 1 ;;
  esac
done

# ---------- helpers ----------

human() { # KB -> human readable
  awk -v k="${1:-0}" 'BEGIN {
    if (k >= 1048576) printf "%.1f GB", k / 1048576;
    else if (k >= 1024) printf "%.0f MB", k / 1024;
    else printf "%d KB", k }'
}

to_kb() { # "1.2GB" / "340MB (50%)" -> KB
  echo "$1" | awk '{
    if (match($0, /[0-9.]+/)) {
      n = substr($0, RSTART, RLENGTH)
      u = toupper(substr($0, RSTART + RLENGTH))
      sub(/^[^A-Z]+/, "", u)
      if (match(u, /^[A-Z]+/)) u = substr(u, RSTART, RLENGTH)
      m = 1 / 1024
      if (u == "KB") m = 1
      else if (u == "MB") m = 1024
      else if (u == "GB") m = 1048576
      else if (u == "TB") m = 1073741824
      printf "%d", n * m
    } else print 0 }'
}

path_kb() {
  [ -e "$1" ] || { echo 0; return; }
  local s
  s=$(du -sk "$1" 2>/dev/null | awk '{print $1}')
  echo "${s:-0}"
}

avail_kb() { df -k / | awk 'NR==2 {print $4}'; }

have() { command -v "$1" >/dev/null 2>&1; }

# Refuse to touch anything outside the allowed cleanup area.
guard() {
  local p="$1"
  case "$p" in "$HOME"/*) ;; *) return 1 ;; esac
  local d
  for d in Documents Desktop Pictures "Library/Mobile Documents" "Library/Keychains" .ssh; do
    case "$p" in "$HOME/$d"|"$HOME/$d"/*) return 1 ;; esac
  done
  case "$p" in
    "$HOME/.claude"|"$HOME/.claude/"*)
      case "$p" in "$HOME/.claude/downloads/"*) ;; *) return 1 ;; esac ;;
  esac
  [ -e "$p/.git" ] && return 1
  return 0
}

run() { # run a command, or only print it in dry-run mode
  if [ "$DRY_RUN" = 1 ]; then echo "  [dry-run] $*"; else "$@"; fi
}

clear_children() { # clear_children DIR [extra find args]
  local dir="$1"; shift
  if ! guard "$dir"; then echo "  건너뜀(보호된 경로): $dir"; return; fi
  [ -d "$dir" ] || return
  if [ "$DRY_RUN" = 1 ]; then
    echo "  [dry-run] $dir 안의 항목 삭제"
  else
    find "$dir" -mindepth 1 -maxdepth 1 "$@" -exec rm -rf {} + 2>/dev/null
  fi
}

# ---------- item: measure / describe / delete ----------

CACHES="$HOME/Library/Caches"
CACHES_EXCL=(! -name Homebrew ! -name pip ! -name Yarn)

measure_caches() {
  [ -d "$CACHES" ] || { echo 0; return; }
  find "$CACHES" -mindepth 1 -maxdepth 1 "${CACHES_EXCL[@]}" -exec du -sk {} + 2>/dev/null |
    awk '{s += $1} END {print s + 0}'
}
title_caches() { echo "~/Library/Caches (앱 캐시)"; }
describe_caches() {
  echo "  무엇: 앱들이 속도를 위해 임시로 저장해 둔 파일 (Homebrew/pip/Yarn 캐시는 별도 항목)"
  echo "  왜 쌓임: 브라우저, 앱, 개발 도구가 사용할 때마다 캐시를 계속 추가함"
  echo "  지우면: 필요할 때 자동으로 다시 생기며, 처음 실행 시 앱이 잠깐 느려질 수 있음"
  echo "  위험도: 안전"
}
delete_caches() { clear_children "$CACHES" "${CACHES_EXCL[@]}"; }

measure_brew() {
  have brew || { echo 0; return; }
  local line
  line=$(brew cleanup -n 2>/dev/null | grep -i 'approximately' | sed 's/.*approximately //')
  [ -n "$line" ] && to_kb "$line" || echo 0
}
title_brew() { echo "Homebrew 캐시 (brew cleanup)"; }
describe_brew() {
  echo "  무엇: Homebrew가 받아 둔 설치 파일과 패키지의 오래된 버전"
  echo "  왜 쌓임: brew upgrade 때 이전 버전과 다운로드 파일이 그대로 남음"
  echo "  지우면: 공식 명령 brew cleanup이 오래된 것만 지움. 현재 쓰는 버전은 그대로 유지됨"
  echo "  위험도: 안전"
}
delete_brew() { run brew cleanup; }

measure_npm() { path_kb "$HOME/.npm"; }
title_npm() { echo "~/.npm (npm 캐시)"; }
describe_npm() {
  echo "  무엇: npm install 때 내려받은 패키지 압축 파일 캐시"
  echo "  왜 쌓임: 프로젝트마다 설치할 때 받은 패키지가 계속 누적됨"
  echo "  지우면: 다음 npm install 때 필요한 패키지를 다시 내려받아 처음에는 느려짐"
  echo "  위험도: 안전"
}
delete_npm() { if have npm; then run npm cache clean --force; else clear_children "$HOME/.npm"; fi; }

PNPM_DIR=""
measure_pnpm() {
  have pnpm || { echo 0; return; }
  PNPM_DIR=$(pnpm store path 2>/dev/null)
  [ -n "$PNPM_DIR" ] && path_kb "$PNPM_DIR" || echo 0
}
title_pnpm() { echo "pnpm 스토어"; }
describe_pnpm() {
  echo "  무엇: pnpm이 모든 프로젝트와 공유하는 패키지 저장소"
  echo "  왜 쌓임: 프로젝트를 지워도 받아 둔 패키지는 스토어에 남음"
  echo "  지우면: pnpm store prune은 어떤 프로젝트도 쓰지 않는 패키지만 지움. 필요하면 다시 받음"
  echo "  위험도: 안전"
}
delete_pnpm() { run pnpm store prune; }

YARN_DIR=""
measure_yarn() {
  if have yarn; then YARN_DIR=$(yarn cache dir 2>/dev/null); fi
  [ -n "$YARN_DIR" ] || YARN_DIR="$HOME/Library/Caches/Yarn"
  path_kb "$YARN_DIR"
}
title_yarn() { echo "Yarn 캐시"; }
describe_yarn() {
  echo "  무엇: Yarn이 내려받은 패키지 캐시"
  echo "  왜 쌓임: yarn install을 할 때마다 패키지가 누적됨"
  echo "  지우면: 다음 설치 때 다시 내려받아 처음에는 느려짐"
  echo "  위험도: 안전"
}
delete_yarn() { if have yarn; then run yarn cache clean; else clear_children "$YARN_DIR"; fi; }

PIP_DIR=""
measure_pip() {
  if have pip3; then PIP_DIR=$(pip3 cache dir 2>/dev/null); fi
  [ -n "$PIP_DIR" ] || PIP_DIR="$HOME/Library/Caches/pip"
  path_kb "$PIP_DIR"
}
title_pip() { echo "pip 캐시"; }
describe_pip() {
  echo "  무엇: pip가 내려받거나 빌드한 파이썬 패키지(wheel) 캐시"
  echo "  왜 쌓임: pip install을 할 때마다 파일이 저장됨"
  echo "  지우면: 다음 설치 때 다시 내려받거나 빌드해야 해서 처음에는 느려짐"
  echo "  위험도: 안전"
}
delete_pip() { if have pip3; then run pip3 cache purge; else clear_children "$PIP_DIR"; fi; }

DERIVED="$HOME/Library/Developer/Xcode/DerivedData"
measure_xcode() { path_kb "$DERIVED"; }
title_xcode() { echo "Xcode DerivedData"; }
describe_xcode() {
  echo "  무엇: Xcode의 빌드 결과물과 인덱스 파일"
  echo "  왜 쌓임: 프로젝트를 빌드할 때마다 생기고, 지운 프로젝트의 것도 남음"
  echo "  지우면: 다음 빌드 때 자동으로 다시 생김. 첫 빌드와 인덱싱이 오래 걸림"
  echo "  위험도: 안전"
}
delete_xcode() { clear_children "$DERIVED"; }

SIM_DEVICES="$HOME/Library/Developer/CoreSimulator/Devices"
unavailable_sim_ids() {
  have xcrun || return
  xcrun simctl list devices unavailable 2>/dev/null |
    grep -Eo '[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}' | sort -u
}
measure_simulators() {
  local id total=0 s
  for id in $(unavailable_sim_ids); do
    s=$(path_kb "$SIM_DEVICES/$id")
    total=$((total + s))
  done
  echo "$total"
}
title_simulators() { echo "Xcode 사용 불가 시뮬레이터"; }
describe_simulators() {
  echo "  무엇: 지금 설치된 Xcode/iOS 런타임으로는 실행할 수 없는 옛 시뮬레이터 기기"
  echo "  왜 쌓임: Xcode나 iOS 런타임을 업데이트하면 이전 기기가 버려진 채 남음"
  echo "  지우면: xcrun simctl delete unavailable이 쓸 수 없는 기기만 지움. 쓸 수 있는 기기는 그대로"
  echo "  위험도: 안전"
}
delete_simulators() { run xcrun simctl delete unavailable; }

docker_ready() { have docker && docker info >/dev/null 2>&1; }
measure_docker() {
  docker_ready || { echo 0; return; }
  local line total=0 s
  while IFS= read -r line; do
    s=$(to_kb "$line")
    total=$((total + s))
  done < <(docker system df --format '{{.Reclaimable}}' 2>/dev/null)
  echo "$total"
}
title_docker() { echo "Docker (사용하지 않는 데이터)"; }
describe_docker() {
  echo "  무엇: 중지된 컨테이너, 태그 없는 이미지, 미사용 네트워크, 빌드 캐시"
  echo "  왜 쌓임: 이미지를 빌드하고 컨테이너를 돌릴 때마다 찌꺼기가 남음"
  echo "  지우면: docker system prune -f로 미사용 항목만 지움. 볼륨과 실행 중인 컨테이너는 건드리지 않음. 이미지는 다시 빌드/다운로드 필요"
  echo "  위험도: 주의 (중지된 컨테이너 안의 데이터는 사라짐)"
}
delete_docker() { run docker system prune -f; }

TRASH="$HOME/.Trash"
measure_trash() { path_kb "$TRASH"; }
title_trash() { echo "휴지통 (~/.Trash)"; }
describe_trash() {
  echo "  무엇: 휴지통에 버려 둔 파일"
  echo "  왜 쌓임: 휴지통을 비우기 전까지 파일이 계속 용량을 차지함"
  echo "  지우면: 영구 삭제되어 복구할 수 없음. 먼저 휴지통 내용을 확인할 것"
  echo "  위험도: 주의 (되돌릴 수 없음)"
}
delete_trash() { clear_children "$TRASH"; }

CLAUDE_DL="$HOME/.claude/downloads"
old_claude_files() { # every claude-* binary except the newest version
  [ -d "$CLAUDE_DL" ] || return
  ls -1 "$CLAUDE_DL" 2>/dev/null | grep '^claude-' | sort -V | sed '$d'
}
measure_claudedl() {
  local f total=0 s
  while IFS= read -r f; do
    [ -n "$f" ] || continue
    s=$(path_kb "$CLAUDE_DL/$f")
    total=$((total + s))
  done < <(old_claude_files)
  echo "$total"
}
title_claudedl() { echo "~/.claude/downloads 옛 버전 파일"; }
describe_claudedl() {
  echo "  무엇: Claude Code 자동 업데이트가 내려받은 이전 버전 실행 파일 (가장 최신 버전 1개는 남김)"
  echo "  왜 쌓임: 업데이트할 때마다 새 버전이 추가되고 이전 버전은 자동으로 지워지지 않음"
  echo "  지우면: 현재 버전에는 영향 없음. 설정 파일은 건드리지 않음"
  echo "  위험도: 안전"
}
delete_claudedl() {
  local f
  while IFS= read -r f; do
    [ -n "$f" ] || continue
    if guard "$CLAUDE_DL/$f"; then run rm -f "$CLAUDE_DL/$f"; fi
  done < <(old_claude_files)
}

# ---------- main ----------

[ "$(uname)" = "Darwin" ] || { echo "macOS 전용 스크립트입니다."; exit 1; }

[ "$DRY_RUN" = 1 ] && echo "** dry-run 모드: 아무것도 삭제하지 않습니다 **"
echo
echo "== 현재 디스크 상태 =="
df -h /
BEFORE_KB=$(avail_kb)

echo
echo "== 용량 측정 중 (시간이 걸릴 수 있습니다) =="
IDS=(caches brew npm pnpm yarn pip xcode simulators docker trash claudedl)
LIST=""
for id in "${IDS[@]}"; do
  kb=$("measure_$id")
  kb=${kb:-0}
  [ "$kb" -ge "$MIN_KB" ] && LIST="$LIST$kb $id"$'\n'
done
SORTED=$(printf '%s' "$LIST" | sort -rn)

if [ -z "$SORTED" ]; then
  echo "100MB 이상 정리할 항목이 없습니다."
else
  echo
  echo "== 정리 후보 (큰 순서) =="
  while read -r kb id; do
    [ -n "$id" ] || continue
    printf '  %10s  %s\n' "$(human "$kb")" "$("title_$id")"
  done <<< "$SORTED"
fi

SELECTED_KB=0
while read -r kb id; do
  [ -n "$id" ] || continue
  echo
  echo "------------------------------------------------------------"
  echo "[$("title_$id")]  $(human "$kb")"
  "describe_$id"
  if [ "$DRY_RUN" = 1 ]; then
    "delete_$id"
    continue
  fi
  read -r -p "  삭제할까요? [y/N] " ans
  case "$ans" in
    y|Y) "delete_$id"; SELECTED_KB=$((SELECTED_KB + kb)) ;;
    *) echo "  건너뜀" ;;
  esac
done <<< "$SORTED"

DL="$HOME/Downloads"
if [ -d "$DL" ]; then
  BIG=$(find "$DL" -type f -size +"${BIG_DOWNLOAD_MB}"M -exec du -sk {} + 2>/dev/null | sort -rn)
  if [ -n "$BIG" ]; then
    echo
    echo "------------------------------------------------------------"
    echo "[~/Downloads 의 ${BIG_DOWNLOAD_MB}MB 이상 파일] 목록만 보여주며 삭제하지 않습니다"
    while read -r kb p; do
      printf '  %10s  %s\n' "$(human "$kb")" "${p/#$HOME/~}"
    done <<< "$BIG"
  fi
fi

echo
echo "== 결과 =="
if [ "$DRY_RUN" = 1 ]; then
  echo "dry-run: 변경 없음"
else
  AFTER_KB=$(avail_kb)
  echo "확보한 용량: $(human $((AFTER_KB - BEFORE_KB))) (선택한 항목 추정치 $(human "$SELECTED_KB"))"
fi
df -h /
