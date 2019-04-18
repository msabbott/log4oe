# log4oe

A basic implementation of the log4j framework for OpenEdge. Provides a logging framework for OpenEdge ABL applications.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See Using log4e for notes on how to integrate the library into your ABL application. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

What things you need to install the software and how to install them

```
Give examples
```

### Developing for log4oe

To develop on the framework (e.g. creating new features, bug fixing, etc) follow the steps below. For information on how to use the framework in your application, and to deploy the code, see the Deployment section.

Download the framework source from this repository using Git.
```
git clone https://github.com/msabbott/log4oe.git /oelibraries/log4oe
```

#### Unit Tests

Unit tests are written using OEUnit, and therefore an installation of this library is required to run, create or amend unit tests.

To run all unit tests, the file log4oe/Tests/AllTests.cls can be run, this file includes all tests suites available. 

## Using log4oe

Using the log4oe library is a case of downloading a release version of the library, or using a clone of the repository, and including it in the PROPATH of your application. The root directory of the library should be added, **not** the "log4oe" sub-directory.

```
PROPATH="/oelibraries/log4oe:$PROPATH"
```

### Basic Usage
In each procedure file/class where a logger is required, include the following class:
```
USING log4oe.Logger.
```
Start logging using the default logger configuration (LogManagerConfig) and output (LogManagerAppender) using the Logger class's static methods:
```
Logger:FATAL("Eek! Something bad happened. I give up!").
Logger:ERROR("An error occurred").
Logger:WARN("Things don't look good to me").
Logger:INFO("FYI...").
Logger:DEBUG("LogManager Log Level: " + STRING(LOG-MANAGER:LOGGING-LEVEL)).
Logger:TRACE("Started procedure").
```

You may also log errors captured as Progress.Lang.Error objects:
```
CATCH e AS Progress.Lang.Error :
    Logger:ERROR(e).
END CATCH.
```

### Using LoggerFactory and Logger Configurations
log4oe supports configurations, which allow configuration options to be read from a number of different locations. This configuration is then applied to one or more loggers using the LogFactory class's static methods.

```
USING log4oe.Logger.
USING log4oe.LoggerFactory.
USING log4oe.LogLevel.

LoggerFactory:getConfig():setLogLevel(LogLevel:INFO).
LoggerFactory:getConfig():setSubsystemName("My Test Application").

Logger:INFO("This message should be logged").
Logger:DEBUG("This message should not be logged").
```

Multiple loggers can be created simultaneously using the static method `LoggerFactory:getLogger("MyLogger").`

Example:
```
USING log4oe.Logger.
USING log4oe.Logger.ILogger.
USING log4oe.LoggerFactory.
USING log4oe.LogLevel.

DEFINE VARIABLE MyLogger AS ILogger NO-UNDO.

LoggerFactory:getConfig():setLogLevel(LogLevel:INFO).
LoggerFactory:getConfig():setSubsystemName("My Test Application").

ASSIGN MyLogger = LoggerFactory:getLogger("MyLogger").

Logger:INFO("This message should be logged").
Logger:DEBUG("This message should not be logged").

MyLogger:INFO("Message from MyLogger").
MyLogger:DEBUG("Message from MyLogger that won't be logged").
```

### Logging to files

By using the LogFileConfiguration, and specifying an output directory, log data can be written to a file. Data is written to a file matching the logger name with ".log" appended to the end.

```
USING log4oe.Logger.
USING log4oe.Logger.ILogger.
USING log4oe.LoggerFactory.
USING log4oe.LogLevel.
USING log4oe.LoggerConfig.LogFileConfig.

DEFINE VARIABLE FileConfig AS LogFileConfig NO-UNDO.
DEFINE VARIABLE MyLogger   AS ILogger       NO-UNDO.

ASSIGN FileConfig = NEW LogFileConfig().

FileConfig:setOutputDirectory("./logs").
FileConfig:setLogLevel(LogLevel:INFO).
FileConfig:setSubsystemName("My Test Application").

/* FileConfig is now used for all loggers created through the LoggerFactory */
LoggerFactory:setConfig(FileConfig).

/* Log messages issued through MyLogger will be written to "./logs/MyLogger.log" */
ASSIGN MyLogger = LoggerFactory:getLogger("MyLogger").

/* Log messages issued by default logger will be written to "./logs/log4oeDefaultLogger.log" */
Logger:INFO("This message should be logged").
Logger:DEBUG("This message should not be logged").

MyLogger:INFO("Message from MyLogger").
MyLogger:DEBUG("Message from MyLogger that won't be logged").
```

## Deployment

When deploying an application that uses log4oe, you will need to include the library's root directory in the PROPATH.

This could be achieved by downloading the repository into a separate directory and including that in the PROPATH. Alternatively, the directory "log4oe" in the library's root directory (including all of it's content and sub-directory) could be added into the source directories for your application.

Note that the "Tests" directory can be excluded.

## Contributing

Please read [CONTRIBUTING.md](https://github.com/msabbott/log4oe/blob/master/CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/msabbott/log4oe/tags). 

## Authors

* **Mark Abbott** - *Initial work* - [msabbott](https://github.com/msabbott)

See also the list of [contributors](https://github.com/msabbott/log4oe/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
