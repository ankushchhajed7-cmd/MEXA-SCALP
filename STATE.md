# MEXA SCALP — STATE

**Current version:** v1.00 (2026-10-18)
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

## Version history
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
| EMA fast / slow | 9 / 21 |
| RSI period | 14 |
| BUY RSI range | 50–70 |
| SELL RSI range | 30–50 |
| Expiry / Amount / Payout | 1:00 / $10 / 85% |
| Lot / TP / SL (Gold) | 0.01 / $3 / $2 |
| Lot / TP / SL (BTC) | 0.01 / $150 / $100 |
| Start balance | $1000 |

## Decisions
- Data: Binance `data-api.binance.vision` + `data-stream.binance.vision` (market-data domain), fallback api.binance.com; WebSocket fail ho to 3 sec polling.
- GOLD = PAXG/USDT (XAUUSD ke saath chalta hai, bilkul same nahi). XAUUSD asli feed ke liye API key wala source chahiye.
- TP/SL report me agar ek hi candle me TP aur SL dono touch ho to **SL maana** (safe side).
- Asset switch tab tak block jab tak open trades hain.
- Pocket Option / Olymp Trade se koi connection nahi (RBI Alert List platforms) — sirf practice + aage MT5.

## Pending / Next
- [ ] Kuch din app me trade karke Report check karo (30–50+ signals)
- [ ] Best settings mile to **MT5 EA (MEXA SCALP EA)** — same EMA/RSI logic, TP/SL, XAUUSD M1/M5
- [ ] APK via apk-factory (URL: Pages link)
