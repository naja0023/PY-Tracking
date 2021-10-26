const router = require('express').Router();
const config = require("../config/dbConfig.js");
const mysql = require("mysql");
const con = mysql.createConnection(config);
const checkUser = require('./middleware');


router.get("/newrequdata", checkUser, (req, res) => {
    const sql = "SELECT user_request.user_email as em,route,DATE_FORMAT(req_date,'%d-%m-%Y %h:%m') as req,DATE_FORMAT(res_date,'%d-%m-%Y %h:%m') as res,driver.name AS name,driver.name as last FROM `user_request` LEFT JOIN driver ON driver.driver_id = user_request.res_driver WHERE MONTH(req_date)=MONTH(CURRENT_TIMESTAMP)";
    con.query(sql, function(err, result, fields) {
        if (err) {
            console.error(err.message);
            res.status(503).send("Database error");
            return;
        } else {
            res.render('newrequdata', { resule: result })
        }
    });
})


module.exports = router;