const { ToadScheduler, SimpleIntervalJob, Task, AsyncTask } = require('toad-scheduler')

const scheduler = new ToadScheduler()
let counter = 0

const task = new Task('simple task', () => { 
    counter++;
    console.log('show count :', counter) }
)

// const task = new AsyncTask('simple task', 
//     () => { 
//         return db.pollForSomeData().then((result) => { /* continue the promise chain */ }) 

//     },
//     (err) => { 
//         /* handle error here */ 
//     }
// )

const job = new SimpleIntervalJob({ seconds: 3, }, task)

scheduler.addSimpleIntervalJob(job)

// when stopping your app
//scheduler.stop()

//console.log('program stop')