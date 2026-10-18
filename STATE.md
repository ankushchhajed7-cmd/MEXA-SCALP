# MEXA SCALP — STATE

**Current version:** v1.07 (2026-10-18)
**Live URL (main merge ke baad):** https://ankushchhajed7-cmd.github.io/MEXA-SCALP/

## Kya hai
Pocket Option jaisa look wala **practice signal app**. Asli paisa nahi — virtual DEMO balance.
Plan: Pehle app me trade karke signal check karo → sahi chala to **Step 2: MT5 Auto EA**.

## Files
| File | Kaam |
|---|---|
| index.html | Pura app (single file, vanilla JS) |
| manifest.json | PWA install info |
| sw.js | Service worker (network-first, offline shell) |
| icon-192.png / icon-512.png | Gold "MS" icon |
| STATE.md | Ye file |
| mt5/MEXA SCALP Signal v1.00.mq5 | MT5 indicator — same signal + phone push (manual install, MQL5\Indicators) |
| mt5/MEXA SCALP Trade EA v1.00.mq5 | **AUTO TRADE EA** — signal par khud trade (demo pe pehle) |
| mt5/MEXA SCALP Signal EA v1.00.mq5 | Same signal, EA form (koi trade nahi) — VPS Helper se deploy (Samusignal repo `vps-ea/`) |

## Version history
- **MT5 Trade EA v1.00** (2026-10-18) — `mt5/MEXA SCALP Trade EA v1.00.mq5` (user ke rules)
  - Signal: EMA 9/21 + RSI 14 (BUY 50–70, SELL 30–50) — user ne 9/21 hi chuna
  - Entry Mode input: **CLOSE** (default, candle close par pakka signal) / LIVE — Strategy Tester me dono compare karna
  - Lot = balance ka **1% risk** (SL $2 se auto), **TP $3 / SL $2** order ke saath
  - **Exit rule**: har candle close se **5 sec pehle** — net profit > $0.10 ho to BOOK; loss me ho to TP/SL tak wait (agli candle phir check)
  - Max spread **$0.30**, rollover 23:55–00:10 (server) skip, 1 trade at a time (magic 18102026), **daily stop 3%** (sirf MEXA ka P/L)
  - Push: open / BOOK / TP / SL / daily stop
- **v1.07** (2026-10-18) — Signal jaldi (user: "signal 2-3 min baad aata hai, move nikal jata hai")
  - ⚡ **LIVE signal** (default ON): chalu candle par EMA cross hote hi usi pal alert (har candle max 1), chart par chamakta ⚡ tir, banner "⚡ LIVE"
  - Candle close par cross wapas → **"सिग्नल कैंसल"** voice + grey banner + tir hatta hai + vibrate; close par pakka ho to chup
  - **Speed preset**: ⚡ FAST (EMA 5/13, RSI 7, BUY 50–80, SELL 20–50) = naya default; NORMAL (9/21, RSI 14, 50–70 / 30–50)
  - Purane users par ek baar FAST + LIVE apne aap lag jata hai
  - Report sirf candle-close signals ka; LIVE ka asli result Trades tab (Signal wali)
- **v1.06** (2026-10-18) — Voice fix: Devanagari "हेलो" ko phone ki voice "hevu" bol rahi thi → ab "Hello" English me likha (baaki line Hindi me). APK me voice chal gayi (v1.05 + naya APK #32 confirm).
- **v1.05** (2026-10-18) — **APK support**: apk-factory ke naye `ANVAlert` bridge se Voice (Android TTS), Notification, Vibrate; `ANVScreen.keepOn` se Screen ON. Chrome/Home-screen me pehle jaisa Web API. APK naye apk-factory workflow (branch `feature-alert-bridge`) se dobara banana hoga.
- **v1.04** (2026-10-18) — 🗣 **Voice alert**: signal par phone ki Hindi voice bolti hai "हेलो अंकुश, गोल्ड में बाय/सेल सिग्नल आया है"; trade WIN/LOSS bhi bolta hai. Settings: Voice ON/OFF, naam badlo, Voice Test. (Voice ON ho to beep 1 baar, phir awaaz)
- **MT5 Signal EA v1.00** (2026-10-18) — `mt5/MEXA SCALP Signal EA v1.00.mq5`: indicator wala hi signal + push, par EA form me kyunki VPS Helper sirf MQL5\Experts me daalta hai. Koi trade nahi, Algo Trading OFF ho tab bhi chalta hai. VPS par bheja: Samusignal repo `vps-ea/` (main).
- **MT5 Indicator v1.00** (2026-10-18) — `mt5/MEXA SCALP Signal v1.00.mq5`
  - App wala same EMA 9/21 + RSI 14 signal, sirf closed candle, asli XAUUSD data
  - SendNotification push (MT5 phone app) + popup Alert + sound, chart par arrows + EMA lines
  - Message: `MEXA SCALP | XAUUSD M1 | BUY @ price | RSI | TP x SL y`
  - Lagate hi 1 test push; koi trade nahi karta
  - Install: VPS MT5 → MQL5\Indicators me file → compile → XAUUSD M1 chart par lagao; Tools > Options > Notifications me phone ka MetaQuotes ID
- **v1.03** (2026-10-18) — **🔆 SCREEN ON/OFF** button (chips row, connection dot ke bagal): Wake Lock se screen band nahi hoti jab app khula ho; setting yaad rehti hai, app wapas khulne par apne aap phir lagti hai
- **v1.02** (2026-10-18) — Header me Demo Balance ke bagal **↻ Refresh** button: tap par menu → 🔄 App + Chart Refresh (naya version + data reload) / 💰 Demo Balance Reset
- **v1.01** (2026-10-18) — Alert fixes (user feedback)
  - Sound bahut kam tha → square wave + compressor, Volume Low/Med/High/MAX (default High), signal tone 3 baar
  - Vibrate button: pehle tap par OFF ho jata tha (confusing) → ab buttons par "ON/OFF" likha, support/block check ke saath sahi message
  - Notification: Android Chrome ke liye service-worker notification (`showNotification`), "support nahi" ki asli wajah batata hai (in-app browser / block / http)
  - Settings me "▶ Test Alert" button; notification tap karne par app khulta hai
- **v1.00** (2026-10-18) — First build
  - Live GOLD (PAXG/USDT) + BTC/USDT chart (Binance public feed, key nahi chahiye)
  - TF: 1 MIN / 5 MIN
  - Signal: EMA 9/21 crossover + RSI 14 filter (BUY: RSI 50–70, SELL: RSI 30–50), sirf closed candle par
  - Alert: sound + vibrate + banner + BUY/SELL button glow (+ optional notification)
  - Trade modes: ⏱ EXPIRY (Pocket Option) aur 🎯 TP/SL (MT5 style, 0.01 lot = $1 per $1 move)
  - Trades tab: open/history, win %, net P/L, "Signal wali" trades ka win %
  - Report tab: loaded ~500 candles ke har signal ka auto result, dono modes, break-even %
  - Theme: Gold mirror / Silver mirror

## Default settings
| Setting | Value |
|---|---|
| Asset / TF | GOLD (PAXG) / 1M |
| Preset / LIVE | ⚡ FAST / ON (NORMAL bhi available) |
| EMA fast / slow | 5 / 13 (NORMAL: 9 / 21) |
| RSI period | 7 (NORMAL: 14) |
| BUY RSI range | 50–80 (NORMAL: 50–70) |
| SELL RSI range | 20–50 (NORMAL: 30–50) |
| Expiry / Amount / Payout | 1:00 / $10 / 85% |
| Lot / TP / SL (Gold) | 0.01 / $3 / $2 |
| Lot / TP / SL (BTC) | 0.01 / $150 / $100 |
| Start balance | $1000 |
| Volume | High (3 of 4) |
| Screen ON | OFF (default) |
| Voice / Naam | ON / अंकुश |

## Decisions
- Trade EA: entry CLOSE recommend kiya (exit rule ko pura ~55 sec milta hai, repaint/cancel nahi, backtest sahi). LIVE input me rakha.
- Honest risk: chhota profit book + poora $10 loss → approx 70%+ win chahiye; pehle demo + Strategy Tester (Every tick based on real ticks).
- Daily loss sirf MEXA magic ke deals se ginta hai (PERSONAL FX ka P/L nahi). EA restart par us waqt ka balance day-start maana jaata hai.
- LIVE signal repaint ho sakta hai (candle ke beech cross aakar wapas ja sakta hai) — isliye close par confirm/cancel. Tez signal = zyada galat signal, ye trade-off user ne chuna.
- MT5 Signal EA abhi bhi candle-close (NORMAL 9/21) par hai — LIVE/FAST waha baad me.
- Voice phone ke Text-to-speech (Google TTS) se — offline file nahi. MT5 push ki tune MT5 app khud tay karta hai, EA se badal nahi sakte.
- Phone lock / app band hone par signal nahi aata (signal phone ke app me banta hai). Screen ON button jugaad hai; asli background alert ke liye aage MT5 indicator + SendNotification (push) plan.
- Alert sound phone ke **Media volume** se chalta hai; notification sirf tab jab app background me ho.
- Data: Binance `data-api.binance.vision` + `data-stream.binance.vision` (market-data domain), fallback api.binance.com; WebSocket fail ho to 3 sec polling.
- GOLD = PAXG/USDT (XAUUSD ke saath chalta hai, bilkul same nahi). XAUUSD asli feed ke liye API key wala source chahiye.
- TP/SL report me agar ek hi candle me TP aur SL dono touch ho to **SL maana** (safe side).
- Asset switch tab tak block jab tak open trades hain.
- Pocket Option / Olymp Trade se koi connection nahi (RBI Alert List platforms) — sirf practice + aage MT5.

## Pending / Next
- [ ] Trade EA: Strategy Tester XAUUSDm M1, 1–2 mahine, CLOSE vs LIVE compare → demo par 1 hafta
- [ ] Confirm PERSONAL FX dusre magic ki trades ko nahi chhoota
- [ ] VPS par **MEXA SCALP Signal EA** naye XAUUSD M1 chart par lagao (auto-compile ho chuka hoga) + push test karo
- [ ] Kuch din app me trade karke Report check karo (30–50+ signals)
- [ ] Best settings mile to **MT5 EA (MEXA SCALP EA)** — same EMA/RSI logic, TP/SL, XAUUSD M1/M5
- [ ] APK dobara banao: apk-factory → Run workflow (branch `feature-alert-bridge` ya merge ke baad main) → URL Pages link, package `com.ankushnewvision.mexascalp`
