const router = require('express').Router();
const config = require("../config/dbConfig.js");
const mysql = require("mysql");
const con = mysql.createConnection(config);
const checkUser = require('./middleware');


router.get("/adminse", checkUser, (req, res) => {
    const sql = "SELECT * FROM driver WHERE  role = 2";
    con.query(sql, function(err, result, fields) {
        if (err) {
            console.error(err.message);
            res.status(503).send("Database error");
            return;
        } else {
            res.render('admin', { resule: result })
        }
    });
})

//  --- add new post ---
router.post('/adminse/new', checkUser, (req, res) => {
    const username = req.body.username;
    const password = req.body.password;
    const name = req.body.name;
    const lastname = req.body.lastname;
    const email = req.body.email;
    const tell = req.body.tell;
    const id_card = req.body.id_card;
    const role = req.body.role

    const sql = "INSERT INTO driver(username,password,name,lastname,email,tell,id_card, role)VALUES(?,?,?,?,?,?,?,?)"
    con.query(sql, [username, password, name, lastname, email, tell, id_card, role], function(err, result, fields) {
        if (err) {
            console.error(err.message);
            res.status(503).send("Database error");
            return;
        }

        // get inserted rows
        const numrows = result.affectedRows;
        if (numrows != 1) {
            console.error("can not insert data");
            res.status(503).send("Database error");
        } else {
            res.send("/adminse");
        }
    });
});

//  --- edit a post ---
router.put('/adminse/edit', checkUser, (req, res) => {
    const { username, password, name, lastname, email, tell, id_card, role } = req.body;
    console.log(req.body)
    const sql = "UPDATE driver SET username=?,password=?,name=?,lastname=?,email=?,tell=?,id_card=?, role=? WHERE driver_id= ?"
    con.query(sql, [name, lastname, tell, email, id_card, role, id], (err, result) => {
        if (err) {
            console.log(err);
            res.status(503).send("Server error");
        } else {
            res.status(200).send('/adminse');
        }
    });
});

// --- delete selected blog of a user ---
router.delete('/adminse/:id', checkUser, (req, res) => {
    const blogID = req.params.id;
    const sql = "DELETE FROM driver WHERE driver_id =?"
    con.query(sql, [blogID], (err, result) => {
        if (err) {
            console.log(err);
            res.status(503).send("Server error");
        } else {
            res.status(200).send('/adminse');
        }
    });
});

module.exports = router;