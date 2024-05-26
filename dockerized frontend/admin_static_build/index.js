const express = require("express");
const path = require("path");
const app = express();



app.use((req, res, next)=>{
  res.set('X-Frame-Options', 'SAMEORIGIN');
  res.setHeader('Access-Control-Allow-Origin', 'https://api-stage.crypfi.io'); // Replace with your API URL
  res.setHeader('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept');
  res.setHeader("Content-Security-Policy", "frame-ancestors 'none'")

  next();
 })

app.use(express.static(path.join(__dirname, "build")));

app.get("/*", function (req, res) {
  res.sendFile(path.join(__dirname, "build", "index.html"));
});

app.listen(3000);
