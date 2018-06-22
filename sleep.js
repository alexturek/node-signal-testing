console.log(`starting`);

setTimeout(() => console.log('finished'), 30000);

setInterval(() => console.log(`.`), 500);

process.on('SIGTERM', () => {
  console.log(`Received sigterm`);
  process.exit(0);
});
