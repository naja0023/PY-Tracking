const router = require('express').Router();
const config = require("../config/dbConfig.js");
const mysql = require("mysql");
const con = mysql.createConnection(config);
const checkUser = require('./middleware');
const bcrypt = require("bcryptjs");


router.get("/newadminse", checkUser, (req, res) => {
    const sql = "SELECT * FROM driver WHERE  role = 2";
    con.query(sql, function(err, result, fields) {
        if (err) {
            console.error(err.message);
            res.status(503).send("Database error");
            return;
        } else {
            const sql2 = "SELECT COUNT(driver_id) AS num FROM `driver` WHERE role =2";
            con.query(sql2, function(err, result2, fields) {
                if (err) {
                    console.error(err.message);
                    res.status(503).send("Database error1");
                    return;
                } else {
                    const sql3 = "SELECT COUNT(driver_id) AS num1 FROM `driver` WHERE role =2 AND MONTH(`str_date`)=MONTH(CURRENT_TIMESTAMP)";
                    con.query(sql3, function(err, result3, fields) {
                        if (err) {
                            console.error(err.message);
                            res.status(503).send("Database error2");
                            return;
                        } else {
                            const sql4 = "SELECT  user_name,name,lastname,point,report,DATE_FORMAT(rv_date,'%d-%m-%Y %r') as rd_date FROM review_driver  LEFT JOIN driver ON driver.driver_id = review_driver.driver_id WHERE role =2 AND MONTH(`rv_date`)=MONTH(CURRENT_TIMESTAMP)ORDER BY rv_date DESC";
                            con.query(sql4, function(err, result4, fields) {
                                if (err) {
                                    console.error(err.message);
                                    res.status(503).send("Database error3");
                                    return;
                                } else {

                                    res.render('newadmin', { count: result2, resule: result, count1: result3, count2: result4 })
                                }
                            })

                        }
                    })

                }
            })
        }
    });
})

router.get("/countdriver", checkUser, (req, res) => {
    const sql = "SELECT COUNT(driver_id) AS num FROM `driver` WHERE role =2";
    con.query(sql, function(err, result, fields) {
        if (err) {
            console.error(err.message);
            res.status(503).send("Database error");
            return;
        } else {
            res.render('newadmin', { count: result })
        }
    });
})

//  --- add new post ---
// router.post('/adminse/new', checkUser, (req, res) => {
//     const username = req.body.username;
//     const password = req.body.password;
//     const name = req.body.name;
//     const lastname = req.body.lastname;
//     const email = req.body.email;
//     const tell = req.body.tell;
//     const id_card = req.body.id_card;
//     const address = req.body.address;
//     const sub = req.body.sub;
//     const dist = req.body.dist;
//     const prov = req.body.prov;
//     const zip = req.body.zip;
//     const sex = req.body.sex;
//     const role = req.body.role;

//     const sql = "INSERT INTO driver(username,password,name,lastname,email,tell,id_card,address,sub,dist,prov,zip,sex,role)VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
//     con.query(sql, [username, password, name, lastname, email, tell, id_card, address, sub, dist, prov, zip, sex, role], function(err, result, fields) {
//         if (err) {
//             console.error(err.message);
//             res.status(503).send("Database error");
//             return;
//         }

//         // get inserted rows
//         const numrows = result.affectedRows;
//         if (numrows != 1) {
//             console.error("can not insert data");
//             res.status(503).send("Database error");
//         } else {
//             res.send("/newadminse");
//         }
//     });
// });

router.post("/adminse/new", function(req, res) {
    const username = req.body.username;
    const password = req.body.password;
    const name = req.body.name;
    const lastname = req.body.lastname;
    const email = req.body.email;
    const tell = req.body.tell;
    const id_card = req.body.id_card;
    const address = req.body.address;
    const sub = req.body.sub;
    const dist = req.body.dist;
    const prov = req.body.prov;
    const zip = req.body.zip;
    const sex = req.body.sex;
    const role = req.body.role;

    //checked existing username
    let sql = "SELECT driver_id FROM driver WHERE username=?";
    con.query(sql, [username], function(err, result, fields) {
        if (err) {
            console.error(err.message);
            res.status(500).send("Database server error");
            return;
        }

        const numrows = result.length;
        //if repeated username
        if (numrows > 0) {
            res.status(400).send("ขออภัย, ไอดีผู้ใช้นี้ถูกใช้งานแล้ว");
        } else {
            bcrypt.hash(password, 10, function(err, hash) {
                //return hashed password, 60 characters
                sql = "INSERT INTO driver(username,password,name,lastname,email,tell,id_card,address,sub,dist,prov,zip,sex,role)VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
                con.query(sql, [username, hash, name, lastname, email, tell, id_card, address, sub, dist, prov, zip, sex, role], function(err, result, fields) {
                    if (err) {
                        console.error(err.message);
                        res.status(500).send("Database server error");
                        return;
                    }

                    const numrows = result.affectedRows;
                    if (numrows != 1) {
                        res.status(500).send("Insert failed");
                    } else {
                        res.status(200).send('/newadminse')
                    }
                });
            });
        }
    });
});

//  --- edit a post ---
router.put('/adminse/edit', checkUser, (req, res) => {
    const username = req.body.username;
    const password = req.body.password;
    const name = req.body.name;
    const lastname = req.body.lastname;
    const email = req.body.email;
    const tell = req.body.tell;
    const id_card = req.body.id_card;
    const address = req.body.address;
    const sub = req.body.sub;
    const dist = req.body.dist;
    const prov = req.body.prov;
    const zip = req.body.zip;
    const sex = req.body.sex
    const role = req.body.role;
    const driver_id = req.body.driver_id;
    console.log(req.body)
        // const sql = "UPDATE driver SET username=?,password=?,name=?,lastname=?,email=?,tell=?,id_card=?,address=?,sub=?,dist=?,prov=?,zip=?,sex=?,role=? WHERE driver_id=?"
        // con.query(sql, [username, password, name, lastname, email, tell, id_card, address, sub, dist, prov, zip, sex, role, driver_id], (err, result) => {
        //     if (err) {
        //         console.log(err);
        //         res.status(503).send("Server error");
        //     } else {
        //         res.status(200).send('/newadminse');
        //     }
        // });
    bcrypt.hash(password, 10, function(err, hash) {
        //return hashed password, 60 characters
        sql = "UPDATE driver SET username=?,password=?,name=?,lastname=?,email=?,tell=?,id_card=?,address=?,sub=?,dist=?,prov=?,zip=?,sex=?,role=? WHERE driver_id=?";
        con.query(sql, [username, hash, name, lastname, email, tell, id_card, address, sub, dist, prov, zip, sex, role, driver_id], function(err, result, fields) {
            if (err) {
                console.error(err.message);
                res.status(500).send("Database server error");
                return;
            }

            const numrows = result.affectedRows;
            if (numrows != 1) {
                res.status(500).send("Insert failed");
            } else {
                res.status(200).send('/newadminse')
            }
        });
    });
});





module.exports = router;