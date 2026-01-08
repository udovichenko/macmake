/**
 * Calculate responsive CSS value using clamp-like formula
 * Equivalent to SCSS calculate() function
 */
function calculate(size1, size2, breakpoint1 = 393, breakpoint2 = 1440) {
  const vwRaw = (size1 - size2) / (breakpoint1 - breakpoint2);
  const px = Math.round(size2 - breakpoint2 * vwRaw);
  const vw = Math.round(vwRaw * 1000) / 10; // *100 then round to 1 decimal

  return `calc(${px}px + ${vw}vw)`;
}

// Parse command line arguments
const args = process.argv.slice(2);

if (args.length === 0) {
  console.error('Usage: node calc.js "size1,size2[,breakpoint1,breakpoint2]"');
  console.error('Example: node calc.js "10,20,380,1440" or node calc.js "16,24"');
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

const result = calculate(size1, size2, breakpoint1, breakpoint2);
const comment = `/* ${breakpoint1}:${size1} - ${breakpoint2}:${size2} */`;
const output = `${result}; ${comment}`;

console.log(output);

