const fs = require("fs");
const input = fs.readFileSync("input.txt", { encoding: "utf8" }).split("\n").map(e => e.split(''));

// PART 1
const rowLength = input[0].length - 1;
const colLength = input.length - 1;
const possibleConnections = {
    top: ['|', 'F', '7', 'S'],
    bottom: ['|', 'J', 'L', 'S'],
    left: ['-', 'L', 'F', 'S'],
    right: ['-', 'J', '7', 'S'],
}
const pipeDirections = {
    '|': ['top', 'bottom'],
    'F': ['bottom', 'right'],
    'J': ['top', 'left'],
    '7': ['bottom', 'left'],
    'L': ['top', 'right'],
    '-': ['left', 'right'],
    'S': ['top', 'bottom', 'left', 'right']
}

let start;
input.forEach((row, rowIndex) => {
    const colIndex = row.indexOf('S')
    if(colIndex > -1){
        start = [rowIndex, colIndex]
    }
})

const getNextCoordinates = (prevDir, row, col) => {
    const currentPipe = input[row][col];
    const directions = pipeDirections[currentPipe];
    let nextCol  = col;
    let nextRow = row;
    let nextDir;
    directions.forEach(dir => {
        if(dir == 'top' && prevDir !== 'top' && row > 0 && possibleConnections.top.includes(input[row - 1][col])) {
            nextRow = row - 1;
            nextDir = 'bottom'
        }
        if(dir == 'bottom' && prevDir !== 'bottom' && row < colLength && possibleConnections.bottom.includes(input[row + 1][col])) {
            nextRow = row + 1;
            nextDir = 'top'
        }
        if(dir == 'left' && prevDir !== 'left' && col > 0 && possibleConnections.left.includes(input[row][col - 1])) {
            nextCol = col - 1;
            nextDir = 'right'
        }
        if(dir == 'right' && prevDir !== 'right' && col <rowLength && possibleConnections.right.includes(input[row][col + 1])) {
            nextCol = col + 1;
            nextDir = 'left'
        }
    })
    return {dir: nextDir, row: nextRow, col: nextCol}

}

let currentRow = start[0];
let currentCol = start[1];
let prevDir = 'bottom';
let count = 0;
while(input[currentRow][currentCol] !== 'S' || count <= 0){
    let n = getNextCoordinates(prevDir, currentRow, currentCol)
    currentCol = n.col;
    currentRow = n.row;
    prevDir = n.dir;
    count+=1
}

console.log(count / 2)

