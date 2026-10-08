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

## 업데이트 (2026-10-09)
미확인 칸이 절반 이상이라 추가 검색 후 보강. 변경점만 기록.

- **NVIDIA ① 한도**: 미확인 -> 기본 40 RPM, 가입 시 1,000 크레딧 (서드파티/공식 포럼 사용자 글, 크레딧 폐지설과 충돌, 단일 계열 출처) [12][13]. 연구/테스트 무료, 프로덕션은 AI Enterprise 라이선스 필요 [13]. 한도 상향은 공식적으로 불가 안내 [12].
- **Mistral ① 한도**: 미확인 -> Experiment(무료): 1 RPS, 500,000 TPM, 월 10억 토큰 (공식 헬프센터 내용을 검색 요약으로 확인; 페이지 직접 fetch는 404, 단일 출처) [14]. ③ 가입: 전화번호 인증 + 학습 데이터 사용 동의 필요 (서드파티) [15].
- **Groq ① 한도**: 미확인 -> 공식 표의 gpt-oss-120b/20b, qwen3.8-27b: 30 RPM, 1,000 RPD, 8K TPM, 200K TPD. 단 공식 페이지가 "Developer 플랜 기준"이라 명시하므로 무료 플랜 수치는 서드파티 값과 일치하는 것만 확인됨 (서드파티) [9][16]. ③ 카드 불필요 (서드파티) [16]. 정확한 무료 한도는 콘솔 Limits 페이지에서 확인 필요.
- **Gemini ① 한도**: 미확인 -> 여전히 미확인. 서드파티가 10~15 RPM, 250~1,500 RPD 등으로 서로 충돌 [17]. 공식은 AI Studio 확인을 안내.
- **Gemini ② 모델 (충돌)**: 공식 가격 페이지(재확인 2026-10-09)는 2.5 Pro, 2.5 Flash, 3.x Flash 계열이 무료, 3.1 Pro Preview는 무료 아님 [6]. 서드파티는 "2026-04 Pro 무료 폐지"라고 주장 [17]. **공식 우선**이나 계정별 차이 가능.
- **OpenRouter ① (확정)**: `:free` 20 RPM, 일 50회 / 누적 구매 10 크레딧 이상이면 일 1,000회. 임계값은 "1 크레딧 낮은 9부터" 적용 (공식) [2].

### 추천 변경 없음 (보강)
Gemini 유지. 단 한도 수치는 단일 확인 불가. 대안: 공개 코드 한정 Groq(gpt-oss-120b, 일 토큰 200K 제한) 또는 Mistral(월 10억 토큰으로 가장 넉넉하나 학습 동의 필요).

### 추가 출처
[12] https://forums.developer.nvidia.com/t/request-for-nvidia-nim-api-rate-limit-increase-40-200-rpm-agentic-development-workflow/378941 (확인일: 2026-10-09, 공식 포럼 사용자 글)
[13] https://forums.developer.nvidia.com/t/api-credits-for-build-nvidia-com/306633 (확인일: 2026-10-09, 공식 포럼)
[14] https://help.mistral.ai/en/articles/225174-what-are-the-limits-of-the-free-tier (확인일: 2026-10-09, 공식; 검색 요약으로만 확인, fetch 404)
[15] https://mintlify.com/cheahjs/free-llm-api-resources/providers/free/mistral-plateforme (확인일: 2026-10-09, 서드파티)
[16] https://benchlm.ai/free-tier/groq , https://community.groq.com/t/is-there-a-free-tier-and-what-are-its-limits/790 (확인일: 2026-10-09, 서드파티)
[17] https://agentdeals.dev/gemini-api-pricing-changes , https://tinkerllm.com/blog/gemini-api-free-tier-limits-rate-quotas/ (확인일: 2026-10-09, 서드파티)

## 업데이트 2 (2026-10-09, Gemini 정정 + 코딩 모델 칸 재확인)
- **Gemini 모델 정정 (old -> new)**: "2.5 Pro / 2.5 Flash 중심" -> **3.8 Flash가 무료 최선** ("long-horizon software engineering" 설명), 3.7 Flash도 무료 (코딩·에이전트용). 무료 텍스트: 3.8/3.7/3.6/3.5 Flash, 3.5·3.1 Flash-Lite, 3 Flash Preview, Gemma 4 [6][18].
- **Pro급 (확인 결과)**: 최신 Pro인 `gemini-3.1-pro-preview`는 무료 티어 **Not available** [6]. `gemini-2.5-pro`는 가격 페이지에 무료로 표기되나, 모델 페이지는 2.5 계열을 "limited access(기존 사용자 한정)"로 표기하고 신규 프로젝트에는 3.5 Flash-Lite / 3.8 Flash를 권장 [18]. 즉 **"최신 Pro급은 무료에서 빠짐"**, 2.5 Pro는 신규 계정에서 사용 가능한지 미확인(공식 페이지끼리 표현 불일치).
- **Gemini 한도**: rate-limits 공식 페이지는 무료 수치를 싣지 않고 "AI Studio에서 확인"만 안내 [5]. 표기: **AI Studio 로그인 후 확인 필요**. (이전 업데이트의 서드파티 수치는 참고 불가로 폐기.)
- **코딩 모델 칸 (공식 모델 목록 기준)**:
  - Gemini: gemini-3.8-flash, gemini-3.7-flash (무료) [18]
  - Groq: 공식 페이지가 코딩 전용 모델을 지정하지 않음. 범용 중 gpt-oss-120b(Production), qwen3.8-27b·minimax-m2.7(Preview) [10]. 무료 여부는 콘솔 Limits 확인 필요.
  - Mistral: Codestral 25.08(코드 완성), Mistral Medium 3.5(에이전트·코딩), Small 4(코딩 통합). Devstral은 폐기 예정. 무료 티어에서 쓸 수 있는 모델은 미확인 [19].
  - OpenRouter 무료(`:free`) 코딩용: poolside/laguna-s-2.1, laguna-xs-2.1, cohere/north-mini-code, nvidia/nemotron-3-ultra-550b-a55b [20]. (API 목록 fetch는 `:free` 0건으로 불일치, 컬렉션 페이지 기준 채택, 단일 출처)
  - NVIDIA: laguna-xs-2.1, nemotron-3-super/ultra, kimi-k3, gemma-4-31b-it 등 코딩·에이전트용 표기 [21]. 무료/프리뷰 라벨은 페이지에 없음, 무료 여부는 위 포럼 근거(서드파티성)만 존재.
- **추천 재판단**: 바뀐 점은 "Pro급 무료"라는 근거가 사라진 것. 그래도 **Gemini 무료 티어(gemini-3.8-flash)** 유지. 이유: 공식 설명상 코딩 특화 최신 모델이 무료로 확인된 유일한 곳. 단 Pro급 품질이 필요하면 무료로는 불가. 대안은 OpenRouter 무료 Laguna/North Mini Code(일 50회 한계). 한도·학습 사용 정책은 AI Studio에서 확인하고 공개 가능한 코드에만 사용.

### 추가 출처
[18] https://ai.google.dev/gemini-api/docs/models (확인일: 2026-10-09, 공식)
[19] https://docs.mistral.ai/getting-started/models/models_overview/ (확인일: 2026-10-09, 공식)
[20] https://openrouter.ai/collections/free-models (확인일: 2026-10-09, 공식, 단일 출처)
[21] https://build.nvidia.com/models (확인일: 2026-10-09, 공식)
