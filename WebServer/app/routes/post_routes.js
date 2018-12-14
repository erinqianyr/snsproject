module.exports = function(app, con, utils) {

  // Checks if inputted parameters are valid
  function checkParameters(input, expected) {
    if (input != undefined) {
      expected.forEach((field) => {
        if (input[field] == undefined) {
          return false;
        }
      });

      for (var k in input) {
        if (typeof input[k] && input[k].charAt(0) == '{') {
          var v = JSON.parse(input[k]);
          if (typeof v == 'object' && Object.keys(v).length == 0) {
            return false;
          }
        }
      }

      return true;
    }
    return false;
  }

  // Attempts to log the user in.
  // If successful, sends back STATUS: 200
  // If successful, will also send back headers, containing the type of user
  // and the id of said user.
  app.post('/login', (req, res) => {
    const fields = ['name', 'password'];
    // ASSUMPTION: No two users can have the same name.
    // Not even

    const input = req.body;

    if (!checkParameters(input, fields)) {
      res.sendStatus(400);
      return;
    }

    var username = input.name.toLowerCase();
    var password = input.password;

    var query = 'SELECT r.rid, r.name, r.password FROM \
                READERS r WHERE r.name=' + '"' + username + '"';

    con.query(query, (err1, rows1) => {
      if (err1) console.log(err1);

      var result = rows1[0];
      if (result != undefined) {

        if (result.password === password) {
          console.log('Reader ' + result.rid + ' has logged in.');
          res.set({
            'type': 'reader',
            'id': result.rid
          });

          res.sendStatus(200);
        } else {
          res.sendStatus(401);
        }

      } else {

        query = 'SELECT p.pid, p.name, p.password FROM \
                PUBLISHERS p WHERE p.name=' + '"' + username + '"';

        con.query(query, (err2, rows2) => {
          if (err2) console.log(err2);

          result = rows2[0];
          if (result != undefined) {

            if (result.password === password) {
              console.log('Publisher ' + result.pid + ' has logged in.');
              res.set({
                'type': 'publisher',
                'id': result.pid
              });
              res.sendStatus(200);
            } else {
              res.sendStatus(401);
            }

          } else {
            res.sendStatus(401);
          }
        });

      }
    });

  });

  // Takes a new reader, adds them to the verification table until verified.
  app.post('/new_reader', (req, res) => {
    const fields = ['name', 'address', 'email', 'password'];

    // roleType is 0 for a reader.
    const roleType = 0;
    const input = req.body;

    if (!checkParameters(input, fields)) {
      res.sendStatus(400);
      return;
    }

    var currDate = new Date();
    utils.isNameTaken(input.name.toLowerCase(), (result) => {

      if (result == false) {

        const reader = { name: input.name.toLowerCase(), address: input.address,
                        email: input.email, password: input.password,
                        verification_time: utils.getDateTime(currDate),
                        role: roleType};

        const query = 'INSERT INTO VERIFICATION SET ?';

        // Add them to verification table, and send the email if it was successful.
        con.query(query, reader, (err, res) => {
          if (err) console.log(err);
          else utils.sendMail(input.email, res.insertId, currDate);
        });

        console.log('Successfully added reader to verification table.')

        res.sendStatus(200);
      } else {
        res.sendStatus(401);
      }
    });
  });

  // Takes an rid and a map of cid -> [sid ...].
  // Associates a reader with certain categories.
  app.post('/subscribe', (req, res) => {
    const fields = ['rid', 'subscriptions'];

    const input = req.body;

    var categories = JSON.parse(input.subscriptions);
    const q = 'INSERT INTO SUBSCRIPTION (rid, cid, sid) VALUES ?';

    // Removes all remaining subscriptions before adding them again :)
    utils.removeSubscriptions(input.rid);
    if (Object.keys(categories).length != 0) {
      utils.associateCategory(input.rid, categories, q);
    }

    res.sendStatus(200);
  });

  // Removes a reader and their inbox and archives it.
  // Only takes a map of rid -> the number.
  app.post('/delete_reader', (req, res) => {
    const fields = ['rid'];

    const input = req.body;

    if (!checkParameters(input, fields)) {
      res.sendStatus(400);
      return;
    }

    const rid = input.rid;

    const getReader = 'SELECT * FROM READERS WHERE rid=' + rid;
    const getInbox = 'SELECT * FROM INBOX WHERE rid=' + rid;

    con.query(getReader, (err1, rows1) => {
      if (err1) console.log(err1);

      var reader = rows1[0];

      con.query(getInbox, (err2, rows2) => {
        if (err2) console.log(err2);
        // Make sure reader exists.
        if (reader != undefined) {
          console.log('Reader ' + rid + ' has been archived.')
          utils.archiveReader(reader, rows2);
        }
      });
    });

    res.sendStatus(200);
  });

  // Deletes a publisher and all of their messages.
  // Only takes a pid from the body.
  app.post('/delete_publisher', (req, res) => {
    const fields = ['pid'];
    const input = req.body;

    if (!checkParameters(input, fields)) {
      res.sendStatus(400);
      return;
    }

    const pid = input.pid;

    utils.archivePublisher(pid);
    res.sendStatus(200);
  });

  // Inserts a publisher into PUBLISHERS.
  app.post('/new_publisher', (req, res) => {
    const fields = ['name', 'address', 'email', 'password'];
    // roleType is 1 for a publisher.
    const roleType = 1;
    const input = req.body;

    if (!checkParameters(input, fields)) {
      res.sendStatus(400);
      return;
    }

    var currDate = new Date();

    utils.isNameTaken(input.name.toLowerCase(), (result) => {

      if (result == false) {
        const publisher = { name: input.name.toLowerCase(), address: input.address,
                        email: input.email, password: input.password,
                        verification_time: utils.getDateTime(currDate),
                        role: roleType};

        const query = 'INSERT INTO VERIFICATION SET ?';

        // Add them to verification table, and send the email if it was successful.
        con.query(query, publisher, (err, res) => {
          if (err) console.log(err);
          else utils.sendMail(input.email, res.insertId, currDate);
        });

        console.log('Successfully added publisher to verification table.')

        res.sendStatus(200);
      } else {
        res.sendStatus(401);
      }
    });
  });

  // Insert message into MESSAGES.

  // IMPORTANT: make sure the user cannot send two of the same subcategory
  // under the same category.
  app.post('/new_message', (req, res) => {
    const fields = ['categories', 'start_time', 'end_time', 'title', 'content',
                    'pid', 'lat', 'lon', 'mes_range'];

    // App will send in a map of categories to subcategories.
    // key -> category name.
    // value -> list of subcategories (will be empty if whole cat. selected).

    const input = req.body;

    if (!checkParameters(input, fields)) {
      res.sendStatus(400);
      return;
    }

    var categories = JSON.parse(input.categories);


    // Both of these dates are in date format NOT DATETIME.
    var startDate = utils.convertToUtc(new Date(input.start_time));
    var endDate = utils.convertToUtc(new Date(input.end_time));

    const message = { title: input.title, content: input.content,
                      pid: input.pid, lat: input.lat,
                      lon: input.lon, mes_range: input.mes_range,
                      start_time: input.start_time, end_time: input.end_time };

    const query = 'INSERT INTO MESSAGES SET ?';

    con.query(query, message, (err, res) => {
      if (err) console.log(err);

      // Original solution:
      // var categories = JSON.parse(input.categories);
      // utils.createCategories(categories, res.insertId);

      // Associates the message with the categories.
      const q = 'INSERT INTO MESSAGE_CATEGORY (mid, cid, sid, timed_out) VALUES ?';
      console.log('Successfully added message ' + res.insertId + ' to table.');

      utils.associateCategory(res.insertId, categories, q, true);

      // Associate multimedia (sound or images) with the message.
      if (input.images != undefined) {
        utils.insertMultimedia(res.insertId, JSON.parse(input.images));
      }

      // Schedules the message for timeout.
      utils.scheduleMessageRemoval(endDate, res.insertId);
    });

    res.sendStatus(200);
  });

  // Takes a  new category, adds it to the database.
  app.post('/new_category', (req, res) => {
    const fields = ['new_category'];

    const input = req.body;

    if (!checkParameters(input, fields)) {
      res.sendStatus(400);
      return;
    }

    var newCategory = input.new_category;

    console.log('Category ' + newCategory + ' has been created.');
    utils.createCategory(newCategory);
    res.sendStatus(200);
  });

  // Takes a map, with a key of a categories ID, and a value of a list of
  // new categories.
  app.post('/new_subcategory', (req, res) => {
    const fields = ['cid', 'new_subcategory'];
    const input = req.body;

    if (!checkParameters(input, fields)) {
      res.sendStatus(400);
      return;
    }

    var newSubcategory = input.new_subcategory;
    var cid = input.cid;

    console.log('Subcategory ' + newSubcategory + ' has been created for category ' + cid);

    utils.createSubcategory(cid, newSubcategory);
    res.sendStatus(200);
  });

  // Will find messages given a time interval and/or matching a specific
  // category.
  app.post('/get_messages', (req, res) => {
    const fields = ['type', 'rid'];
    const input = req.body;
    const type = input.type;
    const rid = input.rid;
    const startTime = input.start_time;
    const endTime = input.end_time;
    const categories = input.categories;

    var coords = { lat: input.lat, lon: input.lon };
    // if (input.lat != undefined) {
    //   coords = { lat: input.lat, lon: input.lon }
    // }

    console.log(input);

    if (!checkParameters(input, fields)) {
      res.sendStatus(400);
      return;
    }

    var query = 'SELECT * FROM MESSAGES \
                WHERE mid IN (?)';

    if (type === 'archived') {
      query = 'SELECT * FROM (SELECT * FROM TIMED_OUT_MESSAGES \
                              UNION \
                              SELECT * FROM ARCHIVED_MESSAGES) x \
                              WHERE x.mid IN (?)';
    }


    // They would like to query given a category.
    if (categories != undefined && startTime != undefined) {
      parsedCats = JSON.parse(categories);
      utils.findMessagesWithCategories(parsedCats, (midLst) => {
        utils.findMessagesWithTime(midLst, utils.convertToUtc(new Date(startTime)),
                                utils.convertToUtc(new Date(endTime)), query, (messages) => {

          console.log(messages);
          if (input.lat != undefined) {
            var mesToSnd = [];
            messages.forEach((mes) => {
              let messageId = mes.mid;
              let messageLocation = { lat: mes.lat, lon: mes.lon };
              let mRange = mes.mes_range;

              if (utils.withinRange(coords, messageLocation, mRange)) {
                mesToSnd.push(mes);
              }
            });
            res.send(mesToSnd);
          } else {
            res.send(messages);
          }
        });
      });
    } else if (startTime != undefined) {

      const q = 'SELECT mid FROM (SELECT mid FROM MESSAGES \
                      UNION \
                      SELECT mid FROM TIMED_OUT_MESSAGES \
                      UNION \
                      SELECT mid FROM ARCHIVED_MESSAGES) x';
      con.query(q, (err, rows) => {
        midLst = [];
        rows.forEach((m) => {
          midLst.push(m.mid);
        });
        utils.findMessagesWithTime(midLst, utils.convertToUtc(new Date(startTime)),
                                utils.convertToUtc(new Date(endTime)), query, (messages) => {

          if (input.lat != undefined) {
            var mesToSnd = [];
            messages.forEach((mes) => {
              let messageId = mes.mid;
              let messageLocation = { lat: mes.lat, lon: mes.lon };
              let mRange = mes.mes_range;

              if (utils.withinRange(coords, messageLocation, mRange)) {
                mesToSnd.push(mes);
              }
            });
            res.send(mesToSnd);
          } else {
            res.send(messages);
          }
        });
      });
    } else if (categories != undefined) {
      parsedCats = JSON.parse(categories);
      utils.findMessagesWithCategories(parsedCats, (midLst) => {
        con.query(query, [midLst], (err, messages) => {

          if (input.lat != undefined) {
            var mesToSnd = [];
            messages.forEach((mes) => {
              let messageId = mes.mid;
              let messageLocation = { lat: mes.lat, lon: mes.lon };
              let mRange = mes.mes_range;

              if (utils.withinRange(coords, messageLocation, mRange)) {
                mesToSnd.push(mes);
              }
            });

            res.send(mesToSnd);
          } else {
            res.send(messages);
          }
        });
      });
    } else if (categories == undefined && startTime == undefined) {
      res.sendStatus(400);
    }
  });

  // Will be called when a reader sends a new location
  app.post('/at_location', (req, res) => {
    const fields = ['rid', 'lat', 'lon'];
    const input = req.body;
    const readerId = input.rid;
    const customLocation = input.custom_location;
    const readerLocation = { lat : input.lat, lon: input.lon };

    if (!checkParameters(input, fields)) {
      res.sendStatus(400);
      return;
    }

    console.log('Reader ' + readerId + ' has checked in at lat: ' + input.lat + ' and long: ' + input.lon);

    var messagesToSend = [];

    utils.sharesCategories(readerId, (messages) => {
      messages.forEach((mes) => {
        let messageId = mes.mid;
        let messageLocation = { lat: mes.lat, lon: mes.lon };
        let mRange = mes.mes_range;

        if (utils.withinRange(readerLocation, messageLocation, mRange)) {
          if (customLocation == undefined) {
            utils.addToInbox(readerId, messageId);
          } else {
            messagesToSend.push(mes);
          }
        }

      });
      // Send response messages.
      if (customLocation == undefined) {
        utils.sendEntireInbox(readerId, res);
      } else {
        res.send(messagesToSend);
      }
    });

  });

  // For testing input.
  app.post('/test_input', (req, res) => {
    const input = req.body;
    var multiMedia = JSON.parse(input.media);

    utils.insertMultimedia(input.mid, multiMedia);

    res.send("Test complete.")
  });
};
