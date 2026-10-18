//+------------------------------------------------------------------+
//|                                   MEXA SCALP Signal v1.00.mq5    |
//|                                   Ankush New Vision              |
//+------------------------------------------------------------------+
//  CHANGELOG
//  v1.00 (2026-10-18)
//   - MEXA SCALP app wala same signal: EMA 9/21 crossover + RSI 14 filter
//     BUY  = EMA fast upar cross + RSI 50..70
//     SELL = EMA fast niche cross + RSI 30..50
//   - Sirf CLOSED candle par signal (repaint nahi)
//   - Phone par PUSH notification (MT5 app) — phone lock ho tab bhi
//   - Popup Alert + sound, chart par BUY/SELL arrows + dono EMA lines
//   - Message me TP/SL price (app jaisa: Gold TP $3, SL $2)
//   - Lagate hi 1 test push (timeframe badalne par dobara nahi)
//   - Koi trade NAHI karta — sirf signal
//+------------------------------------------------------------------+
#property copyright   "Ankush New Vision"
#property version     "1.00"
#property description "MEXA SCALP Signal — EMA 9/21 cross + RSI 14 filter."
#property description "Closed candle par BUY/SELL arrow + phone push notification."
#property indicator_chart_window
#property indicator_buffers 4
#property indicator_plots   4

#property indicator_label1  "EMA Fast"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrDeepSkyBlue
#property indicator_width1  2

#property indicator_label2  "EMA Slow"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrOrange
#property indicator_width2  2

#property indicator_label3  "BUY"
#property indicator_type3   DRAW_ARROW
#property indicator_color3  clrLime
#property indicator_width3  3

#property indicator_label4  "SELL"
#property indicator_type4   DRAW_ARROW
#property indicator_color4  clrRed
#property indicator_width4  3

//--- inputs
input group "=== Signal (app jaisa) ==="
input int    InpEmaFast      = 9;     // EMA Fast
input int    InpEmaSlow      = 21;    // EMA Slow
input int    InpRsiPeriod    = 14;    // RSI Period
input double InpBuyRsiMin    = 50;    // BUY: RSI min
input double InpBuyRsiMax    = 70;    // BUY: RSI max
input double InpSellRsiMin   = 30;    // SELL: RSI min
input double InpSellRsiMax   = 50;    // SELL: RSI max

input group "=== Alerts ==="
input bool   InpPush         = true;  // Phone PUSH notification (MT5 app)
input bool   InpPopup        = true;  // Popup Alert (terminal)
input bool   InpSound        = true;  // Sound
input string InpSoundFile    = "alert.wav"; // Sound file
input bool   InpTestPush     = true;  // Lagate hi 1 test push bhejo

input group "=== TP / SL (sirf message me) ==="
input bool   InpShowTpSl     = true;  // Message me TP/SL dikhao
input double InpTpMove       = 3.0;   // TP price move ($)
input double InpSlMove       = 2.0;   // SL price move ($)

//--- buffers / handles
double   FastBuf[], SlowBuf[], BuyBuf[], SellBuf[];
int      hFast = INVALID_HANDLE, hSlow = INVALID_HANDLE, hRsi = INVALID_HANDLE;
datetime lastSigBar = 0;
string   lastSigText = "abhi koi nahi";

//+------------------------------------------------------------------+
string TfName()
{
   return StringSubstr(EnumToString((ENUM_TIMEFRAMES)_Period), 7);
}

//+------------------------------------------------------------------+
void ShowComment()
{
   Comment("MEXA SCALP Signal v1.00  |  ", _Symbol, " ", TfName(),
           "  |  EMA ", InpEmaFast, "/", InpEmaSlow, "  RSI ", InpRsiPeriod,
           "\nPush: ", (InpPush ? (TerminalInfoInteger(TERMINAL_NOTIFICATIONS_ENABLED) ? "ON" : "OFF (Tools > Options > Notifications)") : "band"),
           "\nLast signal: ", lastSigText);
}

//+------------------------------------------------------------------+
int OnInit()
{
   if(InpEmaFast < 1 || InpEmaSlow <= InpEmaFast || InpRsiPeriod < 2)
   {
      Print("MEXA SCALP: galat inputs — EMA Slow, EMA Fast se bada hona chahiye");
      return(INIT_PARAMETERS_INCORRECT);
   }

   SetIndexBuffer(0, FastBuf, INDICATOR_DATA);
   SetIndexBuffer(1, SlowBuf, INDICATOR_DATA);
   SetIndexBuffer(2, BuyBuf,  INDICATOR_DATA);
   SetIndexBuffer(3, SellBuf, INDICATOR_DATA);
   ArraySetAsSeries(FastBuf, true);
   ArraySetAsSeries(SlowBuf, true);
   ArraySetAsSeries(BuyBuf,  true);
   ArraySetAsSeries(SellBuf, true);

   PlotIndexSetInteger(2, PLOT_ARROW, 233);        // up arrow
   PlotIndexSetInteger(3, PLOT_ARROW, 234);        // down arrow
   PlotIndexSetInteger(2, PLOT_ARROW_SHIFT, 12);   // candle ke niche
   PlotIndexSetInteger(3, PLOT_ARROW_SHIFT, -12);  // candle ke upar
   for(int p = 0; p < 4; p++)
      PlotIndexSetDouble(p, PLOT_EMPTY_VALUE, EMPTY_VALUE);

   hFast = iMA(_Symbol, _Period, InpEmaFast, 0, MODE_EMA, PRICE_CLOSE);
   hSlow = iMA(_Symbol, _Period, InpEmaSlow, 0, MODE_EMA, PRICE_CLOSE);
   hRsi  = iRSI(_Symbol, _Period, InpRsiPeriod, PRICE_CLOSE);
   if(hFast == INVALID_HANDLE || hSlow == INVALID_HANDLE || hRsi == INVALID_HANDLE)
   {
      Print("MEXA SCALP: indicator handle nahi bana, error ", GetLastError());
      return(INIT_FAILED);
   }

   IndicatorSetString(INDICATOR_SHORTNAME, "MEXA SCALP (" + IntegerToString(InpEmaFast) + "/" +
                      IntegerToString(InpEmaSlow) + ", RSI " + IntegerToString(InpRsiPeriod) + ")");
   IndicatorSetInteger(INDICATOR_DIGITS, _Digits);

   //--- test push (timeframe/symbol change par nahi)
   int prevReason = UninitializeReason();
   if(InpPush && InpTestPush && prevReason != REASON_CHARTCHANGE && prevReason != REASON_PARAMETERS)
   {
      if(!TerminalInfoInteger(TERMINAL_NOTIFICATIONS_ENABLED))
         Alert("MEXA SCALP: Push notification OFF hai. Tools > Options > Notifications me MetaQuotes ID daalo aur Enable karo.");
      else if(!SendNotification("MEXA SCALP test OK - " + _Symbol + " " + TfName() + " signal alerts chalu"))
         Print("MEXA SCALP: test push fail, error ", GetLastError());
   }

   ShowComment();
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   if(hFast != INVALID_HANDLE) IndicatorRelease(hFast);
   if(hSlow != INVALID_HANDLE) IndicatorRelease(hSlow);
   if(hRsi  != INVALID_HANDLE) IndicatorRelease(hRsi);
   Comment("");
}

//+------------------------------------------------------------------+
void FireSignal(const int dir, const double price, const double rsi, const datetime barTime)
{
   string side = (dir > 0 ? "BUY" : "SELL");
   string msg  = "MEXA SCALP | " + _Symbol + " " + TfName() + " | " + side + " @ " +
                 DoubleToString(price, _Digits) + " | RSI " + DoubleToString(rsi, 0);
   if(InpShowTpSl)
   {
      double tp = price + dir * InpTpMove;
      double sl = price - dir * InpSlMove;
      msg += " | TP " + DoubleToString(tp, _Digits) + " SL " + DoubleToString(sl, _Digits);
   }

   lastSigText = side + " @ " + DoubleToString(price, _Digits) + "  (" +
                 TimeToString(barTime + PeriodSeconds(), TIME_MINUTES) + ")";

   if(InpPush && TerminalInfoInteger(TERMINAL_NOTIFICATIONS_ENABLED))
   {
      if(!SendNotification(msg))
         Print("MEXA SCALP: push fail, error ", GetLastError());
   }
   if(InpPopup)
      Alert(msg);                       // Alert apni sound bhi bajata hai
   else if(InpSound)
      PlaySound(InpSoundFile);

   Print(msg);
   ShowComment();
}

//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
   ArraySetAsSeries(time,  true);
   ArraySetAsSeries(high,  true);
   ArraySetAsSeries(low,   true);
   ArraySetAsSeries(close, true);

   int warm = MathMax(InpEmaSlow, InpRsiPeriod) + 3;
   if(rates_total < warm + 3)
      return(0);

   if(BarsCalculated(hFast) < rates_total || BarsCalculated(hSlow) < rates_total ||
      BarsCalculated(hRsi) < rates_total)
      return(prev_calculated);

   int limit;
   if(prev_calculated <= 0)
   {
      limit = rates_total - warm;
      ArrayInitialize(FastBuf, EMPTY_VALUE);
      ArrayInitialize(SlowBuf, EMPTY_VALUE);
      ArrayInitialize(BuyBuf,  EMPTY_VALUE);
      ArrayInitialize(SellBuf, EMPTY_VALUE);
   }
   else
      limit = rates_total - prev_calculated + 1;
   if(limit < 1) limit = 1;

   int need = limit + 2;
   double f[], s[], r[];
   ArraySetAsSeries(f, true);
   ArraySetAsSeries(s, true);
   ArraySetAsSeries(r, true);
   if(CopyBuffer(hFast, 0, 0, need, f) < need) return(prev_calculated);
   if(CopyBuffer(hSlow, 0, 0, need, s) < need) return(prev_calculated);
   if(CopyBuffer(hRsi,  0, 0, need, r) < need) return(prev_calculated);

   for(int k = limit; k >= 0; k--)
   {
      FastBuf[k] = f[k];
      SlowBuf[k] = s[k];
      BuyBuf[k]  = EMPTY_VALUE;
      SellBuf[k] = EMPTY_VALUE;
      if(k == 0) continue;               // chalu candle par signal nahi

      bool crossUp   = (f[k + 1] <= s[k + 1] && f[k] > s[k]);
      bool crossDown = (f[k + 1] >= s[k + 1] && f[k] < s[k]);

      if(crossUp && r[k] >= InpBuyRsiMin && r[k] <= InpBuyRsiMax)
         BuyBuf[k] = low[k];
      else if(crossDown && r[k] >= InpSellRsiMin && r[k] <= InpSellRsiMax)
         SellBuf[k] = high[k];
   }

   //--- alert: sirf naya closed candle (bar 1), ek baar
   if(prev_calculated <= 0)
      lastSigBar = time[1];              // purane signal par alert nahi
   else if(time[1] != lastSigBar)
   {
      if(BuyBuf[1] != EMPTY_VALUE)
      {
         lastSigBar = time[1];
         FireSignal(+1, close[1], r[1], time[1]);
      }
      else if(SellBuf[1] != EMPTY_VALUE)
      {
         lastSigBar = time[1];
         FireSignal(-1, close[1], r[1], time[1]);
      }
   }

   return(rates_total);
}
//+------------------------------------------------------------------+
