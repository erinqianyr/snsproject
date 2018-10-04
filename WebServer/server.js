const express = require('express');
const bodyParser = require('body-parser');
const mysql = require('mysql')

const app = express();

const port = 3000;

app.use(bodyParser.urlencoded({ extended: true }));

require('./app/routes')(app, {});

var con = mysql.createConnection({
  host: "localhost",
  user: "lucas",
  password: "admin"
});

con.connect(function(err) {
  if (err)  {
    console.log(err);
  } else {
    console.log("Connected!");
  }
});

app.listen(port, () => {
  console.log('We are live on ' + port);
});
