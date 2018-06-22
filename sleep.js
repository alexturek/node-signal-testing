console.log(`starting`);

setTimeout(() => console.log('finished'), 30000);

setInterval(() => console.log(`.`), 500);

process.on('SIGTERM', () => {
  console.log(`Node exiting`);
  process.exit(0);
});

process.on("SIGINT", () => {
  console.log(`Node exiting`);
  process.exit(0);
});
