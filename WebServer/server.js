const express = require('express');
const bodyParser = require('body-parser');
const mysql = require('mysql');

const app = express();

const port = 3000;

// These coordinates are the University View in College Park.
// const localCoords = { lat: 38.992748, lon:-76.933674 };

app.use(bodyParser.urlencoded({ extended: true }));

// require('./app/routes')(app, {});

var con = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "rootuser123"
});

con.connect(function(err) {
  if (err) console.log(err);
  console.log("Connected!");
});

app.listen(port, () => {
  console.log('We are live on ' + port);
});

// Notes
  // All tables
  // Inbox table
  // Join from publishers to their messages

  // DATETIME format:
  // YYYY-MM-DD HH:MM:SS

// Given two coordinates passed in as associative arrays, will decide if they
// are within the range (measured in kms).

// Credit :
// https://gist.github.com/moshmage/2ae02baa14d10bd6092424dcef5a1186#file-withinradius-js
function withinRange(coords1, coords2, range) {
  'use strict';

  let R = 6371;
  let deg2rad = (n) => { return Math.tan(n * (Math.PI/180)) };

  let dLat = deg2rad(coords2.lat - coords1.lat);
  let dLon = deg2rad(coords2.lon - coords1.lon);

  let a = Math.sin(dLat/2) * Math.sin(dLat/2) + Math.cos(deg2rad(coords1.lat)) *
  Math.cos(deg2rad(coords2.lat)) * Math.sin(dLon/2) * Math.sin(dLon/2);

  let c = 2 * Math.asin(Math.sqrt(a));
  let d = R * c;

  return (d <= range);
}

// Will take a readers id, and add all messages to his inbox that currenetly
// aren't there and need to be.
function addToInbox(rid, mid) {

  const entry = { rid: rid, mid: mid };

  const query = 'INSERT IGNORE INTO INBOX SET ?';

  con.query(query, entry, (err ,res) => {
    if (err) console.log(err);
  });
  console.log('Reader: ' + rid + ' recieved message: ' + mid);
}

// Takes a new reader as an input and inserts a new tuple into READERS.
app.post('/create_reader', (req, res) => {

  const input = req.body;
  const reader = { name: input.name, address: input.address,
                  email: input.email, password: input.password };

  const query = 'INSERT INTO READERS SET ?';

  con.query(query, reader, (err, res) => {
    if (err) console.log(err);
  });

  console.log('Successfully added reader to table.')

  res.send('Request sent successfully!');
});

// Inserts a publisher into PUBLISHERS.
app.post('/create_publisher', (req, res) => {
  const input = req.body;
  const publisher = { name: input.name, address: input.address,
                    email: input.email, password: input.password };

  const query = 'INSERT INTO PUBLISHERS SET ?';

  con.query(query, publisher, (err, res) => {
    if (err) console.log(err);
  });

  console.log('Successfully added publisher to table.')

  res.send('Request sent successfully!');
});

// Insert message into MESSAGES.
app.post('/create_message', (req, res) => {
  const input = req.body;
  const message = { content: input.content, pid: input.pid, lat: input.lat,
                  lon: input.lon, mes_range: input.mes_range,
                  start_time: input.start_time, end_time: input.end_time };
  const query = 'INSERT INTO MESSAGES SET ?';

  con.query(query, message, (err, res) => {
    if (err) console.log(err);
  });

  console.log('Successfully added message to table.')

  res.send('Request sent successfully!');
});

// Will be called when a reader sends a new location
app.post('/at_location', (req, res) => {
  const input = req.body;

  const readerId = input.rid;
  const readerLocation = { lat : input.lat, lon: input.lon };

  const messageQuery = 'SELECT * FROM MESSAGES';

  con.query(messageQuery, (err, rows) => {
    if (err) console.log(err);

    rows.forEach((mes) => {
      let messageId = mes.mid;
      let messageLocation = { lat: mes.lat, lon: mes.lon };
      let mRange = mes.mes_range;

      if (withinRange(readerLocation, messageLocation, mRange)) {
        addToInbox(readerId, messageId);
      }

    });

  });

  res.send('Request sent successfully!');
});



// Retrieves the entire READERS table and displays it in browser.
app.get('/readers', (req, res) => {

  const query = 'SELECT * FROM READERS';

  con.query(query, (err, rows) => {
    if (err) console.log(err);

    // Log the name of each reader in READERS.
    // rows.forEach((row) => {
    //   console.log(row.name);
    // });

    res.send(rows);
  });

});

//Retrieves PUBLISHERS table.
app.get('/publishers', (req, res) => {
  const query = 'SELECT * FROM PUBLISHERS';

  con.query(query, (err, rows) => {
    if (err) console.log(err);
    res.send(rows);
  });
});

// Performs a join to show all of the publishers and all of their messages.
app.get('/publishers_messages', (req, res) => {

  const query = "SELECT * FROM PUBLISHERS p \
              INNER JOIN MESSAGES m ON p.pid = m.pid";

  con.query(query, (err, rows) => {
    if (err) console.log(err);

    res.send(rows);
  });
});

app.get('/readers_messages', (req, res) => {

  const query = 'SELECT * FROM INBOX';

  con.query(query, (err, rows) => {
    if (err) console.log(err);

    res.send(rows);
  });
});

// Home page for the test server.
app.get('/', (req, res) => {
  res.send('Welcome to the test server!');
});
