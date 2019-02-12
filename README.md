# MQLHelpers
Various small helpers for MQL5 projects

## Getting Started

You need to download or clone code and put it somewhere inside your Metatrader experts code folder.

### Prerequisites

You need [Metatrater 5](https://www.metaquotes.net/ru/metatrader5) from [MetaQuotes](https://www.metaquotes.net/) obviously.

## Usage

### Logging system

The logging system is very simple and used for gathering various messages in one file.

```cpp

#include "../path/to/helpers/Logging/Logging.mqh"

// Create log file with fatal messages only
Logger fatal_log("FileName.fatal.log", LOG_LEVEL_FATAL);
// Or with all messages
Logger all_log("FileName.log");

...

// Use logging with string. 
all_log.Fatal("Something bad happened..")

```

Unfortunately MQL5 do not support varargs, thus you must preformat string to output it to log.

### Tick saving utility

It is very useful to store tick history in CSV to analyze it via Python or R. And it is very simple to use:

```cpp

#include "../path/to/helpers/SmartTickSaver.mqh"

// flush_ticks means that file flushed every flush_ticks ticks, 
// if flush_ticks <= 0 flush will be executed every tick
SmartTickSaver ts("FileName.csv", SymbolName, flush_ticks=100);

...

void OnTick()
{
   ...
   ts.OnTick();
   ...
}

```

Afrer you add this to your expert you will receive CSV like this:
```
time_msc, bid, ask, last, volume_real, bid_change, ask_change, last_change, volume_change, buy_deal, sell_deal
1549975731212,65975.000000,65978.000000,65978.000000,0.000000,1,0,0,0,0,0
1549975731212,65975.000000,65978.000000,65977.000000,1.000000,0,0,1,1,0,1
1549975731212,65975.000000,65978.000000,65975.000000,2.000000,0,0,1,1,0,1
1549975731509,65975.000000,65978.000000,65975.000000,3.000000,0,0,1,1,0,1
1549975731562,65975.000000,65978.000000,65975.000000,18.000000,0,0,1,1,0,1
1549975731960,65975.000000,65978.000000,65978.000000,1.000000,0,0,1,1,1,0
1549975733134,65975.000000,65978.000000,65975.000000,2.000000,0,0,1,1,0,1
1549975733556,65975.000000,65978.000000,65975.000000,2.000000,0,0,1,1,0,1
1549975733720,65975.000000,65978.000000,65978.000000,1.000000,0,0,1,1,1,0
1549975733720,65975.000000,65978.000000,65978.000000,1.000000,0,0,1,1,1,0
1549975733720,65975.000000,65978.000000,65978.000000,1.000000,0,0,1,1,1,0
1549975734115,65975.000000,65978.000000,65978.000000,1.000000,0,0,1,1,1,0
1549975734115,65975.000000,65978.000000,65978.000000,9.000000,0,0,1,1,1,0
1549975734115,65975.000000,65978.000000,65978.000000,25.000000,0,0,1,1,1,0
```



## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

