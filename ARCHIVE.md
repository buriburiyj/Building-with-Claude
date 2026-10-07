# 끝난 프로젝트 보관법

GitHub에는 남기고 내 컴퓨터에서만 숨기는 방법.

## 처음 한 번만
git sparse-checkout set --no-cone '/*'

## 폴더 숨기기 (끝난 프로젝트)
git sparse-checkout add '!/apps/폴더명/'

## 숨긴 목록 보기
git sparse-checkout list

## 전부 다시 꺼내기
git sparse-checkout disable

## 주의
- 레포 안에서 rm이나 Finder로 직접 지우지 말 것 (자동 push가 GitHub에서도 지움)
- 숨긴 폴더는 Claude Code가 못 읽음. 다시 작업하려면 disable 먼저
