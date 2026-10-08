# 코딩용 무료 AI API 비교 (NVIDIA, OpenRouter, Gemini, Mistral, Groq)

기준: ① 무료 한도 ② 코딩용 주요 모델 ③ 가입·결제 요건 ④ 프라이버시(학습 사용) ⑤ 제약·안정성

> 주의: 모든 수치는 공식 페이지를 WebFetch 요약기로 읽은 결과(원문 직접 대조 아님)이며, 대부분 단일 출처다. "미확인"은 공식 페이지에서 찾지 못했다는 뜻이다.

| 항목 | ① 무료 한도 | ② 코딩 모델 | ③ 가입·결제 | ④ 프라이버시 | ⑤ 제약 |
|------|------------|------------|------------|-------------|--------|
| NVIDIA | 미확인 | 미확인 | NVIDIA Developer 계정 필요 [1]; 전화/카드 미확인 | 미확인 | 미확인 (FAQ·약관 404) |
| OpenRouter | `:free` 모델 분당 20회, 일 50회 (누적 구매 크레딧 10 이상이면 일 1,000회) [2] | 무료 코딩 모델 목록 미확인 | 계정 생성 후 크레딧 구매가 기본, 무료 모델 예외 여부 미확인 [2][3] | 프롬프트 기본 비로깅 [2]; 일부 제공자는 학습 가능 [3][4]; 무료 모델 별도 언급 미확인 | 낮은 한도라 프로덕션에 부적합 [2]; 제공자 폴백/실패 가능 |
| Gemini | 수치 미확인 (AI Studio에서 확인하라고 안내) [5] | 2.5 Pro / 2.5 Flash / 2.5 Flash-Lite 등 무료 표기 [6] (모델 ID 재확인 필요) | "활성 프로젝트 또는 무료 체험" [5]; Google 계정만으로 가능한지 미확인 | **무료는 입력/출력을 제품 개선에 사용, 사람이 검토할 수 있음** [6][7]; 유료는 미사용 | EEA 사용자 대상이면 유료만 허용 [7]; 18세 이상 |
| Mistral | 미확인 (한도 페이지 404) | 미확인 | 미확인 | Studio 무료 모드는 입출력을 학습에 쓸 수 있음 (Experiment 플랜 자체는 미확인) [8] | 미확인 |
| Groq | 무료 수치 미확인 (문서의 표는 유료 Developer 기준) [9] | Production: llama-3.3-70b, gpt-oss-120b/20b 등 (무료 여부 미확인) [10] | 미확인 | 기본 추론 데이터 비보관, 로그 최대 30일, 학습 사용 미확인 [11] | Preview 모델은 프로덕션 사용 불가 [10] |

## 기준별 핵심
- ① 한도: 숫자로 확인된 곳은 OpenRouter뿐이다. 일 50회는 코딩 작업에는 매우 적다. 나머지 4곳은 공식 페이지에서 무료 수치를 못 얻었으므로 각 콘솔(AI Studio, Groq settings/limits 등)에서 직접 확인해야 한다.
- ② 모델: Gemini만 무료 모델명이 공식 가격 페이지에 확인된다. Groq는 모델 목록은 있으나 무료 여부가 명시되지 않았다.
- ③ 가입: OpenRouter는 크레딧 구매를 전제로 하는 약관 문구가 있다. 나머지는 전화/카드 요건이 미확인이다.
- ④ 프라이버시: Gemini 무료와 Mistral Studio 무료는 학습·검토에 쓰일 수 있다고 명시되어 있다. 비공개 코드는 넣지 않는 편이 안전하다. Groq는 기본 비보관이다.
- ⑤ 제약: OpenRouter와 Groq Preview는 프로덕션 사용 제한이 명시되어 있다.

## 추천 (잠정)
**Gemini (무료 티어)**: 무료 모델(Pro급 포함)이 공식 페이지에 명시된 유일한 곳이고, OpenRouter는 일 50회라 코딩에 부족하다. 단, 무료 티어 입력이 제품 개선에 쓰이므로 공개 가능한 코드에만 쓰고, 실제 한도는 AI Studio에서 확인할 것. 나머지 4곳은 재조사 전까지 비교 불가.

## 출처
[1] https://docs.api.nvidia.com/nim/docs/api-quickstart (확인일: 2026-10-09, 공식)
[2] https://openrouter.ai/docs/api-reference/limits , https://openrouter.ai/docs/faq (확인일: 2026-10-09, 공식; 임계값 "10 크레딧"과 "약 9 크레딧" 표현이 엇갈려 정확한 임계값은 미확인)
[3] https://openrouter.ai/terms (확인일: 2026-10-09, 공식)
[4] https://openrouter.ai/privacy (확인일: 2026-10-09, 공식)
[5] https://ai.google.dev/gemini-api/docs/rate-limits (확인일: 2026-10-09, 공식)
[6] https://ai.google.dev/gemini-api/docs/pricing (확인일: 2026-10-09, 공식)
[7] https://ai.google.dev/gemini-api/terms (확인일: 2026-10-09, 공식)
[8] Mistral help center 데이터 학습 관련 문서 (확인일: 2026-10-09, 공식; 에이전트가 URL을 추측해 접근한 것이라 정확한 URL 미확인, 단일 출처)
[9] https://console.groq.com/docs/rate-limits (확인일: 2026-10-09, 공식)
[10] https://console.groq.com/docs/models (확인일: 2026-10-09, 공식)
[11] https://console.groq.com/docs/your-data (확인일: 2026-10-09, 공식)
