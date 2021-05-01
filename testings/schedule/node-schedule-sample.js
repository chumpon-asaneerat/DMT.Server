const schedule = require('node-schedule');

// Display log when second is 3
const rule = new schedule.RecurrenceRule();
rule.second = 3;

const job = schedule.scheduleJob(rule, function(){
  console.log('The answer to life, the universe, and everything!');
});
