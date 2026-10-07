# disk-cleaner
macOS 디스크 정리 스크립트입니다. `./clean.sh --dry-run`으로 정리 후보와 설명만 먼저 확인하세요 (삭제 없음).
`./clean.sh`를 실행하면 항목마다 설명을 보여주고 y/n으로 물어보며, y를 고른 항목만 삭제합니다.
sudo는 쓰지 않고, Documents·Desktop·Pictures·iCloud·Keychains·~/.ssh·git 저장소는 건드리지 않으며, ~/Downloads의 큰 파일은 목록만 보여줍니다.
