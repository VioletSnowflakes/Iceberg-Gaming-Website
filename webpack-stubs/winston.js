const noop = () => {};
const logger = { log: noop, info: noop, warn: noop, error: noop };
module.exports = {
  createLogger: () => logger,
  format: { json: noop, combine: noop, timestamp: noop, printf: noop },
  transports: { Http: function() {}, Console: function() {}, File: function() {} },
};
