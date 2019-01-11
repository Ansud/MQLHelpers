/*
 * MQL 5 Simple logging facility
 *
 * (c) Copyright 2019, Anton Zelenov
 *
 *
 *
 * Usage:
 *
 * #include "../path/to/helpers/Logging/Logging.mqh"
 * 
 * // Create log file with fatal messages only
 * Logger fatal_log("FileName.fatal.log", fatal_only=true);
 * // Or with all messages
 * Logger all_log("FileName.log");
 *
 * ...
 *
 * // Use logging with string. 
 * all_log.Fatal("Something bad happened..")
 * // etc
 *
 * Unfortunately MQL5 do not support varargs, thus you must preformat string to output it to log.
 *
 */
 
class Logger
{
private:
	enum LOG_LEVEL {
		FATAL,
		INFO,
		LOG_LEVEL_MAX
	};

public:
	Logger(const string filename, bool fatal_only=false) :
		_fatal_only(fatal_only),
		_handle(INVALID_HANDLE)
	{
		if (!StringLen(filename))
			return;
	  
		_handle = FileOpen(filename, FILE_WRITE | FILE_SHARE_READ | FILE_TXT, '\t', CP_UTF8);
      
		if (_handle == INVALID_HANDLE) {
			printf("Logger construstor: Failed to open log file %s", filename);
			return;
		}

		// Weird, but array initialization via curly brackets is not working.
		_loglevel_char[FATAL] = 'F';
		_loglevel_char[INFO] = 'I';
	}

	~Logger()
	{
		if (IsActive())
			FileClose(_handle);
	}

	void Fatal(const string str)
	{
		WriteMessage(FATAL, str);
	}
   
	void Info(const string str)
	{
		if (_fatal_only)
			return;

		WriteMessage(INFO, str);
	}

private:
	bool IsActive()
	{
		return _handle != INVALID_HANDLE;
	}
   
	string FormatMessage(LOG_LEVEL level, const string str)
	{
		string time_str = TimeToString(TimeCurrent(), TIME_DATE|TIME_MINUTES);
		return StringFormat("[%s] [%s] %s\n", time_str, _loglevel_char[level], str);
	}

	void WriteFormattedMessage(const string str)
	{
		FileWriteString(_handle, str);
		FileFlush(_handle);
	}

	void WriteMessage(LOG_LEVEL level, const string str)
	{
		if (!IsActive())
			return;   

		WriteFormattedMessage(FormatMessage(level, str));
	}
	   
private:
	bool _fatal_only;
	int _handle;   
	char _loglevel_char[LOG_LEVEL_MAX];
};
