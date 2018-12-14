module.exports = function(app, con, utils) {

  // Called when user is verified, and will insert into real table if the
  // verification was completed in the limited time.
  app.get('/verify', (req, res) => {
    utils.verifyUser(req.query.id, new Date(), res);
  });

  // Gets all categories and subcategories.
  app.get('/categories', (req, res) => {
    const query1 = 'SELECT * FROM CATEGORY';
    con.query(query1, (err1, cats) => {
      if (err1) console.log(err1);

      const query2 = 'SELECT * FROM SUBCATEGORY';
      con.query(query2, (err2, subCats) => {

        var responseData = {};
        responseData['categories'] = cats;
        responseData['subcategories'] = subCats;

        res.send(responseData);
      });
    });
  });

  // Takes an rid in the query, gets readers current subscriptions.
  app.get('/subscriptions', (req, res) => {
    if (req.query == undefined || req.query.rid == undefined) {
      res.sendStatus(400);
      return;
    }

    const rid = req.query.rid;
    const query = 'SELECT cid, sid FROM SUBSCRIPTION WHERE rid=' + rid;

    con.query(query, (err, subs) => {
      if (err) console.log(err);

      res.send(subs);
    });
  });

  // Gets all messages for a given publisher with pid in the query.
  app.get('/publishers_messages', (req, res) => {
    if (req.query == undefined || req.query.pid == undefined) {
      res.sendStatus(400);
      return;
    }

    const query = 'SELECT * FROM MESSAGES WHERE pid=' + req.query.pid;

    con.query(query, (err, rows) => {
      if (err) console.log(err);

      mesLst = [];
      rows.forEach((row) => {
        row.start_time = utils.getDateTime(row.start_time);
        row.end_time = utils.getDateTime(row.end_time);
        mesLst.push(row)
      });

      res.send(mesLst);
    });
  });

  // Gets all messages a reader will have recived with rid in the query.
  app.get('/readers_messages', (req, res) => {

    if (req.query == undefined || req.query.rid == undefined) {
      res.sendStatus(400);
      return;
    }

    const query = 'SELECT mid FROM INBOX WHERE rid=' + req.query.rid;

    con.query(query, (err, rows) => {
      if (err) console.log(err);

      midLst = [];
      rows.forEach((row) => {
        midLst.push(row.mid);
      });
      const getMessages = 'SELECT * FROM MESSAGES WHERE mid IN (?)';

      con.query(getMessages, [midLst], (err2, messages) => {
        if (err2) console.log(err2);

        mesLst = [];
        messages.forEach((row) => {
          row.start_time = utils.getDateTime(row.start_time);
          row.end_time = utils.getDateTime(row.end_time);
          mesLst.push(row)
        });

        res.send(mesLst);
      });
    });
  });

  // Gets all the multimeda for a specific message.
  app.get('/message_media', (req, res) => {
    if (req.query == undefined || req.query.mid == undefined) {
      res.sendStatus(400);
      return;
    }

    const mid = req.query.mid;
    const query = 'SELECT media, type FROM MESSAGE_MULTIMEDIA WHERE mid=' + mid;

    con.query(query, (err, rows) => {
      if (err) console.log(err);
      res.send(rows);
    });
  });

  // Home page for the test server.
  app.get('/', (req, res) => {
    res.send('Welcome to the test server!');
  });

  // Get request made specifically for testing util functions.
  app.get('/test', (req, res) => {
    utils.sendEntireInbox(20, res);
  });
};
