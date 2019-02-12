/*
 * MQL 5 Ticks to CSV saver
 *
 * (c) Copyright 2019, Anton Zelenov
 *
 *
 *
 * Usage:
 *
 * #include "../path/to/helpers/SmartTickSaver.mqh"
 * 
 * // flush_ticks means that file flushed every flush_ticks ticks, if flush_ticks <= 0 flush will be executed every tick
 * SmartTickSaver ts("FileName.csv", SymbolName, flush_ticks=100);
 *
 * ...
 *
 * // Use like this
 * void OnTick()
 * {
 *    ...
 *    ts.OnTick();
 *    ...
 * }
 *
 * CSV Produced:
 * Column names:
 *   time_msc, bid, ask, last, volume_real, bid_change, ask_change, last_change, volume_change, buy_deal, sell_deal
 * Column types (bool is 0 for False and 1 for True):
 *   ulong, double, double, double, double, bool, bool, bool, bool, bool, bool
 */
 
#include "TickSaver.mqh"


class SmartTickSaver
{
public:
	SmartTickSaver(const string filename, const string symbol, int flush_ticks = -1) :
		_ts(new TickSaver(filename, flush_ticks)),
		_last_tick(0),
		_symbol(symbol)
	{
		if (!_ts.IsValid())
			return;
	}
	
	~SmartTickSaver()
	{
		delete _ts;
	}
	
	bool IsValid()
	{
		return _ts.IsValid();
	}

	void OnTick()
	{
		if (!_last_tick) {
			Init();
			return;
		}

		MqlTick data[];
		CopyTicks(_symbol, data, COPY_TICKS_ALL, _last_tick);

		// First element is the last one of previous ticks series, thus skip it
		for (int i = 1; i < ArraySize(data); i++)
			_ts.Save(data[i]);

		_last_tick = data[ArraySize(data) - 1].time_msc;
	}

private:
	void Init()
	{
		MqlTick price = {0};
	
		// Get price
		if (!SymbolInfoTick(TradeSymbol, price))
			return;
			
		_last_tick = price.time_msc;
	}

private:
	TickSaver* _ts;
	ulong _last_tick;
	string _symbol;
};
