let results = '';

process.stdin.on('readable', () => {
  if (chunk) {
    results += chunk;
  }
});

prcess.stdin.on('end', () => {
  const exitCode = /Exited \((\d+)\)/.match(results);
});
