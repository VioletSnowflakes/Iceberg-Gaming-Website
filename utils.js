const winston = require("winston");
const {DateTime} = require("luxon");
const credentials = require("./credentials.js");
const { createLogger, format, transports } = require('winston');
const base_url = credentials.base_url;

// In the browser bundle, webpack aliases winston to webpack-stubs/winston.js (a no-op).
// On the server, this uses the real winston.
const customLevels = {
  levels: {
    emergency: 0,
    alert: 1,
    critical: 2,
    error: 3,
    warn: 4,
    notice: 5,
    info: 6,
    debug: 7,
    success: 8
  },
}
const loggerTransports = [];
if (credentials.datadog) {
  loggerTransports.push(new transports.Http({
    host: credentials.datadog.logger.host,
    path: credentials.datadog.logger.path,
    ssl:  credentials.datadog.logger.ssl
  }));
} else {
  loggerTransports.push(new transports.Console());
}
const logger = createLogger({
  level: 'info',
  levels: customLevels.levels,
  exitOnError: false,
  format: format.json(),
  transports: loggerTransports,
});

const commonMessages = {
  accessPage: "User Accessed a Page",
  restrictedPage: "Attempt at accessing restricted page"
}

function alertGeneral() {
  alert("Oops! An error has occurred. Please try again later. If this problem continues, please contact an admin.");
}
function alertApplication() {
  alert("Oops! An error has occurred. Please make sure all fields that are required were filled in. If they were, you may have an application already waiting a response.");
}
const doesUserContainRoles = (userRoles, containsRoles) => {
  return userRoles.some(role => containsRoles.includes(role))
}

function applicationDivisionDisplay(division) {
  division = division.toLowerCase();
  if(division === "cgs") {
    return "Chryse Guard Security"
  } else if(division === "iceberg") {
    return "Iceberg Gaming"
  } else if(division === "17th") {
    return "17th Brigade Combat Team";
  }
}

function getCurrentDateISO() {
  return DateTime.local().setZone('America/Chicago').toISO();
}

module.exports = {
  logger,
  commonMessages,
  base_url,
  alertGeneral,
  doesUserContainRoles,
  applicationDivisionDisplay,
  getCurrentDateISO,
  alertApplication
}
