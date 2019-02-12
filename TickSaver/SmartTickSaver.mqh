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
/*
public:
	TickSaver(const string filename, const string symbol, int flush_ticks = -1) :
		_handle(_handle),
		_flush_ticks(flush_ticks),
		_ticks_count(0)
	{
		if (!StringLen(filename))
			return;
	  
		_handle = FileOpen(filename, FILE_COMMON | FILE_WRITE | FILE_SHARE_READ | FILE_TXT | FILE_ANSI, '\t', CP_UTF8);
      
		if (_handle == INVALID_HANDLE) {
			printf("TickSaver: Failed to open file %s", filename);
			return;
		}

		// Write header
		FileWriteString(
			_handle,
			"time_msc, bid, ask, last, volume_real, bid_change, ask_change, last_change, volume_change, buy_deal, sell_deal\r\n"
		);
	}

	~TickSaver()
	{
		if (IsValid())
			FileClose(_handle);
	}
	
	/*
	 * No exceptions in language produce additional code
	 *
	bool IsValid()
	{
		return _handle != INVALID_HANDLE;
	}
	
	void Save(MqlTick& price)
	{
		if (!IsValid())
			return;
	
		string str = StringFormat(
			"%I64u,%f,%f,%f,%f,%u,%u,%u,%u,%u,%u\r\n",
			price.time_msc, 
			price.bid,
			price.ask,
			price.last,
			price.volume_real,
			uint(bool(price.flags & TICK_FLAG_BID)),
			uint(bool(price.flags & TICK_FLAG_ASK)),
			uint(bool(price.flags & TICK_FLAG_LAST)),
			uint(bool(price.flags & TICK_FLAG_VOLUME)),
			uint(bool(price.flags & TICK_FLAG_BUY)),
			uint(bool(price.flags & TICK_FLAG_SELL))
		);
		
		FileWriteString(_handle, str);
		
		if (++_ticks_count < _flush_ticks)
			return;
	
		FileFlush(_handle);
		_ticks_count = 0;
	}
	
private:
	int _handle;
	int _flush_ticks;
	int _ticks_count;
};

*/