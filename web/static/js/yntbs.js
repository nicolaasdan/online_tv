let Y = $("#Y")
let N = $("#N")
let T = $("#T")
let B = $("#B")
let S = $("#S")
let char = $("#char")
let watch = $("#watch")

let y = Math.floor((Math.random() * 16))
let n = Math.floor((Math.random() * 16))
let t = Math.floor((Math.random() * 16))
let b = Math.floor((Math.random() * 16))
let s = Math.floor((Math.random() * 16))


var yntbs = ["#1abc9c", "#16a085", "#2ecc71", "#27ae60", "#3498db", "#2980b9", "#9b59b6", "#8e44ad", "#34495e", "#2c3e50", "#f1c40f", "#f39c12", "#e67e22", "#d35400", "#e74c3c", "#c0392b"];

Y.css("color", yntbs[y])
N.css("color", yntbs[y])
T.css("color", yntbs[y])
B.css("color", yntbs[b])
S.css("color", yntbs[b])
$('a').css("color", yntbs[y])
$('a').css("border-color", yntbs[y])
$('H1').css("color", yntbs[y])
$('H3').css("color", yntbs[b])
