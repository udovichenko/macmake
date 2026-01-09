/**
 * Calculate responsive CSS value with max limit
 * Equivalent to SCSS calculate-limited() function
 */
function calculateLimited(size1, size2, breakpoint1 = 375, breakpoint2 = 1440) {
  const vwRaw = (size1 - size2) / (breakpoint1 - breakpoint2);
  const px = Math.round(size2 - breakpoint2 * vwRaw);
  const vw = Math.round(vwRaw * 1000) / 10; // *100 then round to 1 decimal

  return `min(calc(${px}px + ${vw}vw), ${size2}px)`;
}

// Parse command line arguments
const args = process.argv.slice(2);

if (args.length === 0) {
  console.error('Usage: node calc-limit.js "size1,size2[,breakpoint1,breakpoint2]"');
  console.error('Example: node calc-limit.js "100,150,380,1440" or node calc-limit.js "50,80"');
  process.exit(1);
}

const values = args[0].split(',').map(v => parseFloat(v));

if (values.length < 2) {
  console.error('Error: At least 2 values required (size1:size2)');
  process.exit(1);
}

const size1 = values[0];
const size2 = values[1];
const breakpoint1 = values.length > 2 ? values[2] : 393;
const breakpoint2 = values.length > 3 ? values[3] : 1440;

const result = calculateLimited(size1, size2, breakpoint1, breakpoint2);
const comment = `/* ${breakpoint1}:${size1} - ${breakpoint2}:${size2} */`;
const output = `${result}; ${comment}`;

console.log(output);

