const express = require('express');
const bodyParser = require('body-parser');
const mysql = require('mysql')

const app = express();

const port = 3000;

app.use(bodyParser.urlencoded({ extended: true }));

// require('./app/routes')(app, {});

var con = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "rootuser123"
});

con.connect(function(err) {
  if (err) console.log(err);
  console.log("Connected!")
});

app.listen(port, () => {
  console.log('We are live on ' + port);
});



// Takes a new reader as an input and inserts a new tuple into READERS.
app.post('/reader_insert', (req, res) => {

  const input = req.body;
  const reader = {name: input.name, address: input.address,
                  email: input.email, password: input.password};

  con.query('INSERT INTO READERS SET ?', reader, (err, res) => {
    if(err) console.log(err);
  });

  res.send('Request sent successfully!')
});

// Retrieves the entire READERS table and displays it in browser.
app.get('/table', (req, res) => {

  con.query('SELECT * FROM READERS', (err, rows) => {
    if(err) console.log(err);

    // Log the name of each reader in READERS.
    rows.forEach((row) => {
      console.log(row.name);
    });

    res.send(rows);
  });

});

// Home page for the test server.
app.get('/', (req, res) => {
  res.send('Welcome to the test server!')
});
