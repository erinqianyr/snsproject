const express = require('express');
var bodyParser = require('body-parser');
const mysql = require('mysql');
const mailer = require('nodemailer');

// sns424PG28@gmail.com
// MeatballPresident33&

const app = express();

const port = 3000;

// Change default timezone to UTC.
process.env.TZ = 'utc';

// These coordinates are the University View in College Park.
// const localCoords = { lat: 38.992748, lon:-76.933674 };

// McKeldin coords: { lat: 38.985938, lon: -76.944646 }

// Costco coords: { lat: 39.033121, lon: -76.908866 }

// DATETIME format:
// YYYY-MM-DD HH:MM:SS

app.use(bodyParser.urlencoded({ extended: true , limit: '50mb'}));

app.listen(port, () => {
  console.log('We are live on ' + port);
});

// Open connection to database.
var con = mysql.createConnection({
  host: "localhost",
  user: "lucas",
  password: "admin",
  database: "demo_sns",
  timezone: 'utc'
});

con.connect(function(err) {
  if (err) console.log(err);
  else console.log("Connected!");
});

var transporter = mailer.createTransport({
  service: 'gmail',
  auth: {
    user: 'sns424PG28@gmail.com',
    pass: 'MeatballPresident33&'
  }
});

// Get utility functions and make available for all requests.
const utils = require('./app/utils/utils')(app, con, transporter);

// Link to routes index.
require('./app/routes/')(app, con, utils);

// Allows the ability to change the servers' address with cmd prompt.
process.stdin.resume();
process.stdin.setEncoding('utf8');

process.stdin.on('data', function(text) {
  utils.changeServerAddress(text.trim());
});
