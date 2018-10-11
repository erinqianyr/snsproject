module.exports = function(app, db) {
  app.post('/', (req, res) => {
    //Create note here
    console.log(req.body)
    res.send('Hello!')
  });

  app.get('/', (req, res) => {
    res.send('Hello World!')
  });
};
