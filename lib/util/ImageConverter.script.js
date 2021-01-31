const sharp = require("sharp");

let inputFile = process.argv[2]
let outputFile = process.argv[3]
let format = process.argv[4]
let height = process.argv[5] == 'null' ? null : Number.parseInt(process.argv[5])
let width = process.argv[5] == 'null' ? null : Number.parseInt(process.argv[6]) || null

sharp(inputFile)
.resize(width, height)
.toFormat(format)
.toFile(outputFile)
.then((_) => process.exit(0))
.catch((e) => {
    console.error(e)
    process.exit(1)
})