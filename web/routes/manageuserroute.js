const router = require('express').Router();
const config = require("../config/dbConfig.js");
const mysql = require("mysql");
const con = mysql.createConnection(config);


router.get("/adminse", (req, res) => {
    const sql = "SELECT * FROM user";
    con.query(sql,  function (err, result, fields) {
        if (err) {
            console.error(err.message);
            res.status(503).send("Database error");
            return;
        }else{
           res.render('admin',{resule:result})  
        }

    });
    
})

//  --- add new post ---
router.post('/adminse/new', (req, res) => {
    const username = req.body.username;
    const email = req.body.email;
    const tel = req.body.tel;
    const role = req.body.role

    const sql = "INSERT INTO user(name, email, role,tel) VALUES(?,?,?,?)";
    con.query(sql, [username, email,role, tel], function (err, result, fields) {
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
        }
        else {
            res.send("/adminse");
        }
    });
});

//  --- edit a post ---
router.put('/adminse/edit', (req, res) => {
    const { name, tel,email, id,role } = req.body;
    console.log(req.body)
    const sql = "UPDATE user SET name = ?, email = ?,tel =?,role =? WHERE Id = ?"
    con.query(sql, [name, email, tel,role, id], (err, result) => {
        if (err) {
            console.log(err);
            res.status(503).send("Server error");
        } else {
            res.status(200).send('/adminse');
        }
    });
});

// --- delete selected blog of a user ---
router.delete('/adminse/:id',  (req, res) => {
    const blogID = req.params.id;
    const sql = "DELETE FROM user WHERE Id =?"
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