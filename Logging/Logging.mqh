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
 * Logger fatal_log("FileName.fatal.log", LOG_LEVEL_FATAL);
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
		LOG_LEVEL_FATAL,
		LOG_LEVEL_INFO
	};

	// If you need to add more logging levels, please update level characters at file end.
	static const char LOGLEVEL_CHAR[];
public:
	Logger(const string filename, LOG_LEVEL level=LOG_LEVEL_INFO) :
		_level(level),
		_handle(INVALID_HANDLE)
	{
		if (!StringLen(filename))
			return;
	  
		_handle = FileOpen(filename, FILE_WRITE | FILE_SHARE_READ | FILE_TXT, '\t', CP_UTF8);
      
		if (_handle == INVALID_HANDLE) {
			printf("Logger construstor: Failed to open log file %s", filename);
			return;
		}
	}

	~Logger()
	{
		if (IsActive())
			FileClose(_handle);
	}

	void Fatal(const string str)
	{
		WriteMessage(LOG_LEVEL_FATAL, str);
	}
   
	void Info(const string str)
	{
		WriteMessage(LOG_LEVEL_INFO, str);
	}

private:
	bool IsActive()
	{
		return _handle != INVALID_HANDLE;
	}
   
	string FormatMessage(LOG_LEVEL level, const string str)
	{
		string time_str = TimeToString(TimeCurrent(), TIME_DATE|TIME_MINUTES);
		return StringFormat("[%s] [%s] %s\n", time_str, LOGLEVEL_CHAR[level], str);
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

		if (level > _level)
			return;

		WriteFormattedMessage(FormatMessage(level, str));
	}
	   
private:
	LOG_LEVEL _level;
	int _handle;   
};

/*
 * Initialization of the static constants
 */
static const char Logger::LOGLEVEL_CHAR[] = {'F', 'I'};
